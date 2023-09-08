import 'package:get/get.dart';
import 'package:kwantapo/controllers/KOTController.dart';
import 'package:kwantapo/data/podos/Kot.dart';
import 'package:kwantapo/services/DataService.dart';
import 'package:kwantapo/services/MasterTerminalService.dart';
import 'package:kwantapo/utils/DateTimeUtils.dart';

class KotListWidgetModel{
  static KotListWidgetModel? _instance;
  factory KotListWidgetModel() => getInstance;
  KotListWidgetModel._();
  final KOTController _controller = Get.find<KOTController>();

  static KotListWidgetModel get getInstance {
    _instance ??= KotListWidgetModel._();
    return _instance!;
  }

  void onKotSum(int id) {
    final kot = _controller.kotList.firstWhere((kot) => kot!.id! == id);
    DataService.getInstance.addAggregateItems(id,hideKot: kot!.hideKot);
  }

  void onKotFinished(Kot kot) {
    final duration = DateTimeUtils.getInstance.getTimePassed(DateTime.parse(kot.receivedTime!));
    MasterTerminalService.getInstance.sendFinishedKot(kot.id!, duration);
  }

}