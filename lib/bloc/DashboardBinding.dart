import 'package:get/get.dart';
import 'package:kwantapo/controllers/SnoozeKotController.dart';
import 'package:kwantapo/controllers/TextSizeController.dart';
import 'package:kwantapo/controllers/lib.dart';

class DashboardBinding implements Bindings {

  @override
  void dependencies() {
    Get.put(KOTController(), permanent: true);
    Get.put(KeyboardInputController());
    Get.put(PrinterController());
    Get.put(FilterController());
    Get.put(AggregatedItemController(), permanent: true);
    Get.put(SnoozeKotController());
    Get.put(TextSizeController(), permanent: true);
  }
}
