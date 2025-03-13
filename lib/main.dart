import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darbelsalib/%20bindings/%20auth_binding.dart';
import 'package:darbelsalib/routes/app_routes.dart';
import 'package:darbelsalib/controllers/auth_controller.dart';
import 'package:darbelsalib/screen_size_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: false, // Ensure no offline cache issues
    sslEnabled: true, // Ensure it connects to Firestore
  );

  Get.put(AuthController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSizeHandler.initialize(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AuthBinding(), 
      initialRoute: '/home',
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
