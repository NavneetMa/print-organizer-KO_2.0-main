import 'package:get/get.dart';
import 'package:kwantapo/controllers/SnoozeKotController.dart';
import 'package:kwantapo/controllers/TextSizeController.dart';
import 'package:kwantapo/controllers/lib.dart';

class KitchenSMDashboardBinding implements Bindings {

  @override
  void dependencies() {
    Get.put(AggregatedItemController(), permanent: true);
    Get.put(SnoozeKotController(), permanent: true);
    Get.put(TextSizeController(), permanent: true);
  }
}
