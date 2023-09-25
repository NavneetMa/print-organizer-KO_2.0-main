import 'dart:async';

import 'package:get/get.dart';
import 'package:kwantapo/controllers/KOTController.dart';
import 'package:kwantapo/data/ResCode.dart';
import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/services/DataService.dart';
import 'package:kwantapo/services/kitchen_mode_api/KitchenModeApi.dart';
import 'package:kwantapo/services/snooze_time/SnoozeTimeService.dart';
import 'package:kwantapo/utils/AppConstants.dart';

class Kot {
  int? id = 0;
  List<Item?> items = [];
  int? kotDismissed = 0;
  String? receivedTime = "";
  String? passedTime = "";
  String? hashMD5 = "";
  String? fKotWithSeparator = "";
  String tableName = "";
  String userName = "";
  String kitchenMessage = "";
  String snoozeDateTime = "";
  bool hideKot = false;
  bool isUndoKot = false;
  bool tableNameMatch = false;
  //RxBool eyeColor = false.obs;
  bool eyeColor = false;
  int singleCategory = 1;
  bool inSum = false;

  Kot({
    this.id,
    this.kotDismissed,
    this.receivedTime,
    this.passedTime,
    this.inSum = false,
    this.hashMD5,
    this.fKotWithSeparator,
    this.items = const [],
    this.tableName = "",
    this.userName = "",
    this.kitchenMessage = "",
    this.hideKot = false,
    this.isUndoKot = false,
    this.snoozeDateTime = "",
    this.tableNameMatch = false,
    this.eyeColor = false,
    //RxBool? eyeColor,
    this.singleCategory = 1,
  }) :
        //eyeColor = eyeColor ?? false.obs,

        super();

  Map<String, dynamic> toJson() => {
        'id': id,
        'receivedTime': receivedTime,
        'kotDismissed': kotDismissed,
        'items': items,
        'passedTime': passedTime,
        'hashMD5': hashMD5,
        'fKotWithSeparator': fKotWithSeparator,
        'inSum': inSum,
        'tableName': tableName,
        'userName': userName,
        'kitchenMessage': kitchenMessage,
        'snoozeDateTime': snoozeDateTime,
        'hideKot': hideKot,
        'isUndoKot': isUndoKot,
        'tableMatch': tableNameMatch,
        'eyeColor' : eyeColor,
        'singleCategory': singleCategory
      };

  Future<void> showKot() async {
      Timer.periodic(const Duration(seconds: 2), (timer) async {
        if (hideKot==true && DateTime.parse(snoozeDateTime).isBefore(DateTime.now())==true) {
          var result = await KitchenModeApi.getInstance.showKotAfterSnoozeTimeIsOver([hashMD5!]);
          if(result.code==ResCode().failed) {
            return;
          }
          hideKot = false;
          await SnoozeTimeService.getInstance.updateHideKot(id!, false);
          if(Get.find<KOTController>().showSnoozeList.value==true){
            DataService.getInstance.removeFromSummationList(id!);
          } else {
            if(AppConstants.isAutoSum){
              inSum = true;
              DataService.getInstance.addAggregateItems(id!,isAutoSum: true);
            }
          }
          SnoozeTimeService.getInstance.updateHideKot(id!, false);
          Get.find<KOTController>().kotList.refresh();
          timer.cancel();
        }
      });
  }

  factory Kot.fromJson(Map<String, dynamic> json) {
    return Kot(
        id: json['id'] as int,
        kotDismissed: json['kotDismissed'] as int,
        receivedTime: json['receivedTime'].toString(),
        items: json['items'] as List<Item>,
        hashMD5: json['hashMD5'].toString(),
        fKotWithSeparator: json['fKotWithSeparator'].toString(),
        inSum: json['inSum'] as bool,
        tableName: json['tableName'].toString(),
        userName: json['userName'].toString(),
        kitchenMessage: json['kitchenMessage'].toString(),
        snoozeDateTime: json['snoozeDateTime'].toString(),
        hideKot: json['hideKot'] as bool,
        isUndoKot: json['isUndoKot'] as bool,
        tableNameMatch: json['tableNameMatch'] as bool,
        //eyeColor: (json['eyeColor'] as bool).obs,
        singleCategory: json['singleCategory'] as int,);
  }
}
