import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darbelsalib/%20bindings/%20auth_binding.dart';
import 'package:darbelsalib/core/services/token_storage_service.dart';
import 'package:darbelsalib/routes/app_routes.dart';
import 'package:darbelsalib/controllers/auth_controller.dart';
import 'package:darbelsalib/controllers/ticket_controller.dart'; // Import the TicketController
import 'package:darbelsalib/screen_size_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: false,
    sslEnabled: true,
  );

  // Initialize controllers
  Get.put(AuthController());
  Get.put(TicketController());

  await GetStorage.init();

  TokenStorageService tokenStorageService = TokenStorageService();
  String? token = await tokenStorageService.getToken();

  setUrlStrategy(PathUrlStrategy());

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;
  
  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    ScreenSizeHandler.initialize(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontSize: ScreenSizeHandler.smaller * 0.065,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          centerTitle: true,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialBinding: AuthBinding(),
      initialRoute: token != null ? '/home' : '/welcome', // Check if token exists
      getPages: AppRoutes.routes,
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const Scaffold(
          body: Center(child: Text("Page not found")),
        ),
      ),
    );
  }
}
