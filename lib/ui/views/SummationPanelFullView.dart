import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/data/ResCode.dart';
import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/interfaces/ILoadingDialog.dart';
import 'package:kwantapo/ui/interfaces/IMessageDialog.dart';
import 'package:kwantapo/ui/lib.dart';

class SummationPanelFullView extends StatefulWidget {

  const SummationPanelFullView({
    Key? key,
  }) : super(key: key);

  @override
  _SummationPanelFullView createState() => _SummationPanelFullView();

}

class _SummationPanelFullView extends State<SummationPanelFullView> implements ILoadingDialog,IMessageDialog{
  late DismissibleCard? _dismissibleCard;
  final _systemService = SystemService.getInstance;
  @override
  void initState() {
    setState(() {
      _dismissibleCard = DismissibleCard(swipeUpToRemoveKotSummation: _swipeUpToRemoveKotSummation,);
    });
    _systemService.setLoadingDialog(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _dismissibleCard!;
  }

  Future<void> _swipeUpToRemoveKotSummation(BuildContext context) async {
    showLoadingDialog('Printing KOT');
    final List<Kot> list=[];
    final List<String> kotHash=[];
    Get.find<KOTController>().kotList.forEach((element) {
      if (element!.inSum == true) {
        list.add(element);
        kotHash.add(element.hashMD5!);
      }
    });
    var result = await KitchenModeApi.getInstance.dismissKot(kotHash);
    if(result.code==ResCode().failed) {
      Navigator.pop(context);
      setState(() {
        _dismissibleCard = DismissibleCard(swipeUpToRemoveKotSummation: _swipeUpToRemoveKotSummation,);
      });
      showMessageDialog("Alert", "Failed to send data to Kitchen Sum Mode");
      return;
    }
      for (final element in list) {
        removeKot(element);
      }
      await _resetFilter();
      NavigationService.getInstance.goBack();
      initState();
  }

  Future<void> removeKot(Kot element) async {
    PrinterService.getInstance.printKOT(element.id, isMSwip: true);
    await DataService.getInstance.updateIsDismissed(element.id);
    Get.find<KOTController>().addDismissedKot(element);
    Get.find<KOTController>().kotList.removeWhere((kot) => kot!.id! == element.id);
    DataService.getInstance.clearSummationList();
  }
  
  Future<bool> _resetFilter() async {
    return Get.find<FilterController>().resetFilter();
  }

  @override
  void showLoadingDialog(String message) {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(message: message);
        },);
  }

  @override
  void showMessageDialog(String? title, String message) {
    showDialog(context: context, builder: (BuildContext context) {
      return MessageDialog(title: title,message: message);
    },);
  }
}