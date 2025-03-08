import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:darbelsalib/controllers/ticket_controller.dart';

class CartPage extends StatelessWidget {
  final TicketController ticketController = Get.find<TicketController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: Obx(() {
        return ticketController.selectedSeats.isEmpty
            ? Center(child: Text("No seats selected"))
            : ListView.builder(
                itemCount: ticketController.selectedSeats.length,
                itemBuilder: (context, index) {
                  String seatNumber = ticketController.selectedSeats[index];

                  return ListTile(
                    title: Text("Seat $seatNumber"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        ticketController.removeSeat(seatNumber);
                      },
                    ),
                  );
                },
              );
      }),
    );
  }
}
