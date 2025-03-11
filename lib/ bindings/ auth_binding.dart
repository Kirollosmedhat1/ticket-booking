// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:darbelsalib/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
