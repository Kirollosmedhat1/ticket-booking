import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:darbelsalib/controllers/ticket_controller.dart';
import 'package:darbelsalib/views/widgets/tickets_card.dart';

class MyTicketsPage extends StatelessWidget {
  final TicketController _ticketController = Get.find<TicketController>();

  MyTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Tickets"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _ticketController.fetchTickets(); // Refresh tickets
            },
          ),
        ],
      ),
     body: SafeArea(
  child: Column(
    children: [
      Expanded(
        child: Obx(() {
          if (_ticketController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (_ticketController.tickets.isEmpty) {
            return Center(child: Text("No tickets found"));
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
                  final ticket = _ticketController.tickets[index];
                  return TicketsCard(
                    seatNumber: ticket['seat']['seat_number'] ?? "N/A",
                    seatCategory: ticket['seat']['category']['name'] ?? "N/A",
                  );
                },
              ),
            );
          }
        }),
      ),
    ],
  ),
),

    );
  }
}
