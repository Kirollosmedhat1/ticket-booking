import 'package:darbelsalib/views/auth/welcom_page.dart';
import 'package:darbelsalib/views/home/current_service_page.dart';
import 'package:darbelsalib/views/tickets/cart.dart';
import 'package:darbelsalib/views/tickets/my_tickets_page.dart';
import 'package:darbelsalib/views/tickets/select_seat.dart';
import 'package:darbelsalib/views/tickets/select_section.dart';
import 'package:get/get.dart';
import '../views/auth/login_page.dart';
import '../views/auth/register_page.dart';
import '../views/home/home_page.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(name: '/register', page: () => RegisterPage()),
    GetPage(name: '/home', page: () => HomePage()),
    GetPage(name: '/selectsection', page: () => const SelectSection()),
    GetPage(name: '/cart', page: () => CartPage()),
    GetPage(name: '/selectsection', page: () => const SelectSection()),
    GetPage(name: '/selectseat/:sectionNumber', page: () => SelectSeat()),
    GetPage(name: '/welcome', page: () => const WelcomPage()),
    GetPage(name: '/mytickets', page: () => const MyTicketsPage()),
    GetPage(name: '/currentservice', page: () => const CurrentServicePage()),
    GetPage(name: '/selectseat', page: () => SelectSeat()),
    GetPage(name: '/SelectSection', page: () => const SelectSection()),
    GetPage(name: '/cart', page: () => CartPage()),
    GetPage(
      name: '/ticketdetails',
      page: () => TicketDetailsPage(
        eventBanner:
            'assets/images/WhatsApp Image 2025-02-24 at 7.35.48 AM 1-2.png',
        seatCategory: "Section 1",
        seatNumber: "A1",
      ),
    ),
  ];
}
