import 'package:darbelsalib/views/auth/welcom_page.dart';
import 'package:darbelsalib/views/home/current_service_page.dart';
// import 'package:darbelsalib/views/payment/checkout_page.dart';
import 'package:darbelsalib/views/tickets/cart.dart';
import 'package:darbelsalib/views/tickets/my_tickets_page.dart';
import 'package:darbelsalib/views/tickets/select_seat.dart';
import 'package:darbelsalib/views/tickets/select_section.dart';
import 'package:darbelsalib/views/tickets/ticket_detail_page.dart';
import 'package:get/get.dart';
import '../views/auth/login_page.dart';
import '../views/auth/register_page.dart';
import '../views/home/home_page.dart';
import '../views/payment/payment_confirmation_page.dart'; // Import the new page

class AppRoutes {
  static final routes = [
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(name: '/register', page: () => RegisterPage()),
    GetPage(name: '/home', page: () => HomePage()),
    GetPage(name: '/selectsection', page: () => const SelectSection()),
    // GetPage(name: '/checkout', page: () => CheckoutPage()),
    GetPage(name: '/cart', page: () => CartPage()),
    GetPage(name: '/welcome', page: () => const WelcomPage()),
    GetPage(name: '/mytickets', page: () =>  MyTicketsPage()),
    GetPage(name: '/currentservice', page: () => const CurrentServicePage()),
    GetPage(
      name: '/selectseat/:sectionNumber',
      page: () => SelectSeat(),
    ),
    GetPage(name: '/SelectSection', page: () => const SelectSection()),
    GetPage(name: '/cart', page: () => CartPage()),
    GetPage(name: '/ticketsdetails', page: () => TicketDetailsPage()),
    // Add the new route for PaymentConfirmationPage
    GetPage(
      name: '/payment-confirmation/:paymentId',
      page: () => PaymentConfirmationPage(paymentId: Get.parameters['paymentId']!),
    ),
  ];
}