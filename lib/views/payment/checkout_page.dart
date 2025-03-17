

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:darbelsalib/controllers/ticket_controller.dart';

class CheckoutPage extends StatelessWidget {
  final TicketController ticketController = Get.put(TicketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Selected Seats", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                return ticketController.selectedSeats.isEmpty
                    ? Center(child: Text("No seats selected"))
                    : ListView.builder(
                        itemCount: ticketController.selectedSeats.length,
                        itemBuilder: (context, index) {
                          String seatNumber = ticketController.selectedSeats[index];
                          double seatPrice = ticketController.getSeatPrice(seatNumber);
                          String seatCategory = ticketController.getSeatCategory(seatNumber);

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              title: Text("Seat $seatNumber"),
                              subtitle: Text("Category: $seatCategory"),
                              trailing: Text("\$${seatPrice.toStringAsFixed(2)}"),
                            ),
                          );
                        },
                      );
              }),
            ),
            Divider(),
            Obx(() {
              double totalPrice = ticketController.getTotalPrice();
              return Text("Total: \$${totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
            }),
            SizedBox(height: 20),
            Text("Payment Methods", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.payment, color: Colors.blue),
              title: Text("Pay with EasyKash"),
              onTap: () {
                // Placeholder for payment integration
                Get.snackbar("Payment", "EasyKash payment selected");
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder for proceeding to payment
                Get.snackbar("Checkout", "Proceeding to payment...");
              },
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              child: Text("Proceed to Payment"),
            ),
          ],
        ),
      ),
    );
  }
}
