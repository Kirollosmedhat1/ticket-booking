// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:darbelsalib/controllers/ticket_controller.dart';
import 'package:darbelsalib/views/widgets/seat_card.dart';

class CartPage extends StatelessWidget {
  final TicketController ticketController = Get.put(TicketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: Obx(() {
        if (ticketController.selectedSeats.isEmpty) {
          return Center(child: Text("No seats selected"));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: ticketController.selectedSeats.length,
                itemBuilder: (context, index) {
                  String seatNumber = ticketController.selectedSeats[index];
                  String category = ticketController.getSeatCategory(seatNumber);
                  double price = ticketController.getSeatPrice(seatNumber);
                  DateTime? expiryTime = ticketController.reservationTimers[seatNumber];
                  return SeatCard(
                    seatNumber: seatNumber,
                    seatCategory: category,
                    seatPrice: price,
                    eventImage: "assets/images/event.jpg",
                    expiryTime: expiryTime,
                  );
                },
              ),
            ),
            Divider(),
            _buildTotalPriceSection(),
            SizedBox(height: 10),
            _buildCheckoutButton(),
          ],
        );
      }),
    );
  }

  /// **Displays Total Price**
  Widget _buildTotalPriceSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total Price:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Obx(() => Text(
                "\$${ticketController.getTotalPrice().toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  /// **Navigates to Checkout Page**
  Widget _buildCheckoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed('/checkout', arguments: {
            'selectedSeats': ticketController.selectedSeats,
            'totalPrice': ticketController.getTotalPrice(),
          });
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text("Proceed to Checkout"),
      ),
    );
  }
}
