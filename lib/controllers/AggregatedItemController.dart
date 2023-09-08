import 'package:get/get.dart';
import 'package:kwantapo/data/podos/lib.dart';

class AggregatedItemController extends GetxController {

  final String _tag = "AggregatedItemController";
  RxList<AggregatedItem> aggregatedList = <AggregatedItem>[].obs;
  RxBool hasAggregatedList = false.obs;

  AggregatedItemController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    aggregatedList.clear();
    hasAggregatedList.value = false;
    super.onClose();
  }
}
