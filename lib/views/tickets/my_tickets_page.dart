// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:darbelsalib/views/widgets/tickets_card.dart';
import 'package:flutter/material.dart';

class MyTicketsPage extends StatelessWidget {
  const MyTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenhight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("My tickets"),
      ),
      body: ListView(
        children: [
          TicketsCard(
            seatNumber: "A22",
            seatCategory: "first Line",
          )
        ],
      ),
    );
  }
}
