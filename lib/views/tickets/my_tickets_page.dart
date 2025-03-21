import 'package:darbelsalib/models/ticket_model.dart';
import 'package:darbelsalib/views/tickets/ticket_detail_page.dart';
import 'package:darbelsalib/views/widgets/custom_loading_indicator.dart';
import 'package:darbelsalib/views/widgets/go_back_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:darbelsalib/controllers/ticket_controller.dart';
import 'package:darbelsalib/views/widgets/tickets_card.dart';

class MyTicketsPage extends StatefulWidget {
  MyTicketsPage({super.key});

  @override
  State<MyTicketsPage> createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  final TicketController _ticketController = Get.find<TicketController>();

  @override
  void initState() {
    super.initState();
    _ticketController.fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Tickets"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (_ticketController.isLoading.value) {
                  return Center(child: CustomLoadingIndicator());
                } else if (_ticketController.tickets.isEmpty) {
                  return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "No Tickets Found",
                    style: TextStyle(color: Colors.white,fontSize: 20),
                  ),
                ],
              ),
            );
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await _ticketController.fetchTickets();
                    },
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _ticketController.tickets.length,
                      itemBuilder: (context, index) {
                        final TicketModel ticket =
                            _ticketController.tickets[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => TicketDetailsPage(), arguments: {
                              'seatNumber': ticket.seatNumber,
                              'seatCategory': ticket.section,
                              'buyerName': ticket.buyerName,
                              'buyerPhoneNumber': ticket.buyerPhoneNumber,
                            });
                          },
                          child: TicketsCard(
                            seatNumber: ticket.seatNumber,
                            seatCategory: ticket.section,
                            buyerName: ticket.buyerName,
                            buyerPhoneNumber: ticket.buyerPhoneNumber,
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: GoBackText(
                text: "Go Home",
                onTap: () => Get.toNamed("/home"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
