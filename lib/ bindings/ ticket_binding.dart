import 'package:get/get.dart';
import '../controllers/ticket_controller.dart';

class TicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TicketController>(() => TicketController());
  }
}
