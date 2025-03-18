import 'dart:async';
import 'dart:convert';
import 'package:darbelsalib/controllers/auth_controller.dart';
import 'package:darbelsalib/controllers/cart_controller.dart';
import 'package:darbelsalib/core/services/api_services.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:darbelsalib/models/seat_model.dart';
import 'package:darbelsalib/views/widgets/book_button.dart';
import 'package:darbelsalib/views/widgets/custom_appbar.dart';
import 'package:darbelsalib/views/widgets/custom_loading_indicator.dart';
import 'package:darbelsalib/views/widgets/go_back_text.dart';
import 'package:darbelsalib/views/widgets/seat_builder.dart';
import 'package:darbelsalib/views/widgets/seat_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SelectSeat extends StatefulWidget {
  @override
  State<SelectSeat> createState() => _SelectSeatState();
}

class _SelectSeatState extends State<SelectSeat> {
  late final String section;
  bool isLoading = false;
  int seatPrice = 0;
  int selectedSeatsCount = 0;
  bool _isInitialLoadCompleted = false;
  final Map<String, Seat> seats = {};
  final AuthController _authController = Get.put(AuthController());
  final ApiService _apiService = ApiService();
  final TokenStorageService _tokenStorageService = TokenStorageService();
  final CartController _cartController = Get.put(CartController());
  final Completer<void> _initialLoadCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
    section = Get.parameters['sectionNumber'] ?? '1';
    listenToSeatsUpdates(section);
  }

  Future<bool> isLoggedIn() async {
    String? token = await _authController.getToken();
    return token != null;
  }

  void addToCart(Seat seat) async {
    setState(() {
      isLoading = true;
    });
    try {
      String? token = await _tokenStorageService.getToken();
      var response = await _apiService.addToCart(token!, {"seat_id": seat.id});
      if (response.statusCode == 200 || response.statusCode == 201) {
        seats[seat.seatNumber]?.status = "selected";
        _cartController.addSeat(seat.seatNumber, seat);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Seat added to cart successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error, ${jsonDecode(response.body)['error']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while adding the seat to the cart.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void removeFromCart(Seat seat) async {
    setState(() {
      isLoading = true;
    });
    try {
      String? token = await _tokenStorageService.getToken();
      var response = await _apiService.removeFromCart(token!, seat.id);
      if (response.statusCode == 200) {
        seats[seat.seatNumber]?.status = "available";
        _cartController.removeSeat(seat.seatNumber);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Seat removed from cart successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove seat from cart.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('An error occurred while removing the seat from the cart.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void getCart() async {
    setState(() {
      isLoading = true;
    });
    String? token = await _tokenStorageService.getToken();
    var response = await _apiService.getUserCart(token!);
    List<dynamic> items = response['items'];
    if (mounted) {
      setState(() {
        for (var item in items) {
          String seatNumber = item['seat']['seat_number'];
          if (seats.containsKey(seatNumber)) {
            seats[seatNumber]?.status = 'selected';
            _cartController.addSeat(seatNumber, seats[seatNumber]!);
          }
        }
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void _onSeatSelected(String seatNumber) {
    setState(() {
      if (seats[seatNumber]?.status == "selected") {
        removeFromCart(seats[seatNumber]!);
      } else if (_cartController.selectedSeats.length < 5) {
        addToCart(seats[seatNumber]!);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: Text(
                "Limit Exceeded",
                style: TextStyle(
                    color: Color(0xffdfa000),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              content: Text(
                "You can only purchase 5 seats at a time.",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "OK",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  List<String> getNeighboringSections(int sectionNumber) {
    switch (sectionNumber) {
      case 1:
        return ['Stage', 'Section 3', '', 'Section 2'];
      case 2:
        return ['Stage', 'Section 4', 'Section 1', ''];
      case 3:
        return ['Section 1', 'Section 5', '', 'Section 4'];
      case 4:
        return ['Section 2', 'Section 6', 'Section 3', ''];
      case 5:
        return ['Section 3', '', '', 'Section 6'];
      case 6:
        return ['Section 4', '', 'Section 5', ''];
      default:
        return [];
    }
  }

  Future<void> listenToSeatsUpdates(String sectionName) async {
    // Swap sections for Firestore structure consistency

    FirebaseFirestore.instance
        .collection('seats')
        .doc('seats')
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        if (!_initialLoadCompleter.isCompleted) {
          _initialLoadCompleter.complete();
        }
        return;
      }

      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('section$sectionName')) {
        if (!_initialLoadCompleter.isCompleted) {
          _initialLoadCompleter.complete();
        }
        return;
      }

      Map<String, dynamic>? sectionData =
          data['section$sectionName'] as Map<String, dynamic>?;
      if (sectionData == null || !sectionData.containsKey('seat_names')) {
        if (!_initialLoadCompleter.isCompleted) {
          _initialLoadCompleter.complete();
        }
        return;
      }

      Map<String, dynamic>? seatNames =
          sectionData['seat_names'] as Map<String, dynamic>?;
      seatPrice = sectionData['price'] ?? 0;
      if (seatNames == null) {
        if (!_initialLoadCompleter.isCompleted) {
          _initialLoadCompleter.complete();
        }
        return;
      }

      seatNames.forEach((seatNameKey, seatDetails) {
        if (seatDetails is Map<String, dynamic>) {
          Seat seat = Seat.fromMap(seatDetails, seatNameKey);
          if (mounted) {
            setState(() {
              seats[seatNameKey] = seat;
            });
            seats[seatNameKey]?.price = seatPrice;
          }
        }
      });

      //if selected seats are found in seats change its status to selected
      _cartController.selectedSeats.forEach((key, value) {
        if (seats.containsKey(key)) {
          seats[key]?.status = "selected";
        }
      });

      if (!_initialLoadCompleter.isCompleted) {
        _initialLoadCompleter.complete();
      }

      if (!_isInitialLoadCompleted) {
        getCart();
        _isInitialLoadCompleted = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int sectionNumber = int.parse(section);
    List<String> neighboringSections = getNeighboringSections(sectionNumber);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(title: "Select Seat"),
      body: FutureBuilder<void>(
        future: _initialLoadCompleter.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !_isInitialLoadCompleted) {
            return Center(
              child: CustomLoadingIndicator(),
            );
          }
          if (seats.isEmpty ||
              seatPrice == 0 ||
              seats == null ||
              seatPrice == null) {
            return Center(child: CustomLoadingIndicator());
          }

          return ModalProgressHUD(
            inAsyncCall: isLoading,
            progressIndicator: CustomLoadingIndicator(),
            opacity: 0.5,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (sectionNumber == 1 || sectionNumber == 2)
                            Image.asset(
                              "assets/images/screen.png",
                            ),
                          Column(
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                size: 30,
                                color: Colors.white,
                              ),
                              Text(
                                neighboringSections[0],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Text(
                            "You are currently in Section $sectionNumber",
                            style: TextStyle(
                                color: Color(0xffdfa000),
                                fontSize: 22,
                                fontWeight: FontWeight.w500),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: SeatBuilder(
                              sectionNumber: sectionNumber,
                              price: seatPrice,
                              seats: seats,
                              onSeatSelected: _onSeatSelected,
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                SeatIndicator(
                                  color: Color(0xff1c1c1c),
                                  description: "Available",
                                ),
                                SeatIndicator(
                                  description: "Reserved",
                                  color: Color(0xffdfa000),
                                ),
                                SeatIndicator(
                                  description: "Selected",
                                  color: Color(0xff7cc3f6),
                                ),
                                SeatIndicator(
                                  description: "On Hold",
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: GoBackText(
                              text: "Go Back",
                              onTap: () => Get.toNamed("/selectsection"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Obx(() {
                    if (_cartController.selectedSeats.isNotEmpty) {
                      return Column(
                        children: [
                          Divider(color: Colors.grey, thickness: 0.5),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 30, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Total in Section",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    Text(
                                      "${_cartController.totalPrice.value} EGP",
                                      style: TextStyle(
                                          color: Color(0xffdfa000),
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                BookButton(
                                  text: "Book",
                                  width: 191,
                                  height: 56,
                                  color: Color(0xffdfa000),
                                  onPressed: () async {
                                    if (!await isLoggedIn()) {
                                      Get.toNamed("/register");
                                    } else {
                                      Get.toNamed("/cart");
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
