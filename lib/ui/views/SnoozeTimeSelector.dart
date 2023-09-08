import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/KOTController.dart';
import 'package:kwantapo/data/ResCode.dart';
import 'package:kwantapo/data/podos/Kot.dart';
import 'package:kwantapo/lang/AppLocalization.dart';
import 'package:kwantapo/services/DataService.dart';
import 'package:kwantapo/services/kitchen_mode_api/KitchenModeApi.dart';
import 'package:kwantapo/services/snooze_time/SnoozeTimeService.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/utils/AppConstants.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/AppTheme.dart';
import 'package:kwantapo/utils/TextStyles.dart';

class SnoozeTimeSelector extends StatefulWidget {
  final int kotIndex;
  final Kot kot;

  const SnoozeTimeSelector({
    required this.kot,
    required this.kotIndex,
  });

  @override
  _SnoozeTimeSelector createState() => _SnoozeTimeSelector();
}

class _SnoozeTimeSelector extends State<SnoozeTimeSelector> {
  FixedExtentScrollController hourController = FixedExtentScrollController(initialItem: SnoozeTimeService.getInstance.getHour());
  FixedExtentScrollController minuteController = FixedExtentScrollController(initialItem: DateTime.now().minute);
  final kotController = Get.find<KOTController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
   hourController.dispose();
   minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: AppSpaces().mediumAll,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: AppSpaces().largeVerticalHorizontal,
                  child:   Text(
                    AppLocalization.instance.translate("snooze_time_of_KOT"),
                    style: const TextStyle(
                      wordSpacing: 0.2,
                      letterSpacing: 0.4,
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.colorPrimary,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 60,
                      decoration: const BoxDecoration(
                          color: AppTheme.greyBack,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: ListWheelScrollView(
                          itemExtent: 48,
                          perspective: 0.005,
                          diameterRatio: 1.2,
                          controller: hourController,
                          onSelectedItemChanged: (value) {
                            print(value.toString());
                          },
                          children: [
                            ...AppConstants().hours.map((e) => getNumber(e))
                          ],
                      ),
                    ),
                    const Text(":",
                        style: TextStyle(
                          wordSpacing: 1,
                          fontSize: 50,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.colorPrimary,
                        ),
                    ),
                    Container(
                      height: 100,
                      width: 60,
                      decoration: const BoxDecoration(
                          color: AppTheme.greyBack,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: ListWheelScrollView(
                          itemExtent: 48,
                          perspective: 0.005,
                          diameterRatio: 1.2,
                          controller: minuteController,
                          onSelectedItemChanged: (value) {
                            print(value.toString());
                          },
                          children: [
                            ...AppConstants().minutes.map((e) => getNumber(e))
                          ],
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 70,
                      width: 60,
                      child:Text("h",
                          style: TextStyles().snoozeTextLarge(),
                      ),
                    ),
                    Container(
                      margin: AppSpaces().smallRight,
                      alignment: Alignment.center,
                      child:  Text(":",
                          style: TextStyles().snoozeTextLarge(),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 70,
                      child:Text("min",
                          style: TextStyles().snoozeTextLarge(),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (kotController.showSnoozeList.value) GestureDetector(
                      onTap: () {
                        resetSnoozeKot(widget.kotIndex-1);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: AppSpaces().largeVerticalHorizontal,
                        child: Text(AppLocalization.instance.translate("reset_kot"),
                            style: TextStyles().snoozeTextMedium(),
                        ),
                      ),
                    ) else Container(),
                    //end Navneet
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding:AppSpaces().largeVerticalHorizontal,
                            child: Text(AppLocalization.instance.translate("cancel"),
                                style: TextStyles().snoozeTextMedium(),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {_setSnoozeTime();},
                          child: Container(
                              padding: AppSpaces().largeVerticalHorizontal,
                              child: Text(AppLocalization.instance.translate("ok"),
                                  style: TextStyles().snoozeTextMedium(),
                              ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 12,
                    children: [
                      ...AppConstants().minuteNumber
                          .map((e) => NumberButton(e, _setMinutes))
                    ],
                  ),
                )
              ],
          ),
        ),
      ),
    );
  }

  Widget getNumber(int number) {
    return Text(number.toString(),
        style: const TextStyle(
          wordSpacing: 1,
          fontSize: 40,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600,
          color: AppTheme.colorPrimary,
        ),
    );
  }

  Future<void> _setMinutes(int minute) async {
    Navigator.of(context).pop();
    // Create a Duration object with the specified number of minutes
    final duration = Duration(minutes: minute);
    // Add the duration to the current date and time
    final dateTime = DateTime.now().add(duration);
    // Print the resulting DateTime object
    var result = await KitchenModeApi.getInstance.hideKotOnKOTSnoozeTimeAdded([kotController.kotList[widget.kotIndex-1]!.hashMD5!]);
    if(result.code==ResCode().failed) {
      SnoozeTimeService.getInstance.iMessageDialog.showMessageDialog("Alert", "Unable to connect to KitchenSumMode");
      return;
    }
      SnoozeTimeService.getInstance.updateDateTime(kotController.kotList[widget.kotIndex-1]!.id!, dateTime.toString());
      kotController.kotList[widget.kotIndex-1]?.hideKot=true;
      kotController.kotList[widget.kotIndex-1]?.snoozeDateTime=dateTime.toString();
      kotController.kotList[widget.kotIndex-1]?.showKot();
      kotController.kotList.refresh();
      if(kotController.showSnoozeList.value==false){
        DataService.getInstance.removeFromSummationList(kotController.kotList[widget.kotIndex-1]!.id!);
      }
      SnoozeTimeService.getInstance.updateHideKot(kotController.kotList[widget.kotIndex-1]!.id!, true);

  }

  Future<void> _setSnoozeTime() async {
    final hour = hourController.initialItem;
    final minute = minuteController.initialItem;
    final h = hourController.selectedItem;
    final m = minuteController.selectedItem;
    // Calculate the difference between the initial and selected values.
    final difference = Duration(hours: h - hour, minutes: m - minute);
    // Calculate the final time by adding the difference to the current time.
    final finalTime = DateTime.now().add(difference);
    if(h < SnoozeTimeService.getInstance.getHour()){
      Get.showSnackbar(const GetSnackBar(
        message: "Invalid time is selected",
        duration: Duration(seconds: 2),
      ),);
      return;
    } else if(m < DateTime.now().minute && h==SnoozeTimeService.getInstance.getHour()){
      Get.showSnackbar(const GetSnackBar(
        message: "Invalid time is selected",
        duration: Duration(seconds: 2),
      ),);
      return;
    }
    Navigator.of(context).pop();
    var result = await KitchenModeApi.getInstance.hideKotOnKOTSnoozeTimeAdded([kotController.kotList[widget.kotIndex-1]!.hashMD5!]);
    if(result.code==ResCode().failed) {
      SnoozeTimeService.getInstance.iMessageDialog.showMessageDialog("Alert", "Unable to connect to KitchenSumMode");
      return;
    }
      SnoozeTimeService.getInstance.updateDateTime(kotController.kotList[widget.kotIndex-1]!.id!, finalTime.toString());
      kotController.kotList[widget.kotIndex-1]?.hideKot=true;
      kotController.kotList[widget.kotIndex-1]?.snoozeDateTime=finalTime.toString();
      kotController.kotList[widget.kotIndex-1]?.showKot();
      //KitchenModeEvents().setEvent(KitchenModeEvents.CLOCK_HIDE_KOT, [kotController.kotList[widget.kotIndex-1]!.hashMD5!]);
      await SnoozeTimeService.getInstance.updateHideKot(kotController.kotList[widget.kotIndex-1]!.id!, true);
      kotController.kotList[widget.kotIndex-1]?.showKot();
      kotController.kotList.refresh();
      if(kotController.showSnoozeList.value==false){
        DataService.getInstance.removeFromSummationList(kotController.kotList[widget.kotIndex-1]!.id!);
      }
  }


  Future<void> resetSnoozeKot(int index) async {
    var result = await KitchenModeApi.getInstance.resetHiddenKot([kotController.kotList[index]!.hashMD5!]);
    if(result.code==ResCode().failed) {
        SnoozeTimeService.getInstance.iMessageDialog.showMessageDialog("Alert", "Unable to connect to KitchenSumMode");
      return;
    }
      kotController.kotList[index]?.hideKot = false;
      kotController.kotList[index]?.snoozeDateTime = DateTime.now().toString();
      SnoozeTimeService.getInstance.updateDateTime(kotController.kotList[index]!.id!, DateTime.now().toString());
      SnoozeTimeService.getInstance.updateHideKot(kotController.kotList[index]!.id!, false);
      kotController.kotList.refresh();
      DataService.getInstance.removeFromSummationList(kotController.kotList[index]!.id!);
  }
}
