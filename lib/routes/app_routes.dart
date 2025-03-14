import 'package:darbelsalib/views/auth/welcom_page.dart';
import 'package:darbelsalib/views/home/current_service_page.dart';
import 'package:darbelsalib/views/payment/checkout_page.dart';
import 'package:darbelsalib/views/tickets/cart.dart';
import 'package:darbelsalib/views/tickets/my_tickets_page.dart';
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
    GetPage(name: '/welcome', page: () => const WelcomPage()),
    GetPage(name: '/mytickets', page: () => const MyTicketsPage()),
    GetPage(name: '/currentservice', page: () => const CurrentServicePage()),
   
  ];
}
