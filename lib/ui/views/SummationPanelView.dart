import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/data/ResCode.dart';
import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/interfaces/ILoadingDialog.dart';
import 'package:kwantapo/ui/interfaces/IMessageDialog.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class SummationPanelView extends StatefulWidget {

  const SummationPanelView({
    Key? key,
  }) : super(key: key);

  @override
  _SummationPanelView createState() => _SummationPanelView();

}

class _SummationPanelView extends State<SummationPanelView> implements ILoadingDialog,IMessageDialog {

  final AggregatedItemController _controller = Get.find<AggregatedItemController>();
  final KOTController _kotcontroller = Get.find<KOTController>();
  final _systemService = SystemService.getInstance;

  @override
  void initState() {
    _systemService.setLoadingDialog(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.aggregatedList.isNotEmpty){
        return Expanded(
            flex: getMinimumWidth(),
            child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.up,
            onDismissed: (DismissDirection direction) => _swipeUpToRemoveKotSummation(context),
            child: Card(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 15,left: 15, bottom: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(AppLocalization.instance.translate("total"), style: TextStyles().titleStyleLargeBlack()),
                            SizedBox(
                                width: 32,
                                height: 32,
                                child: IconButton(
                                  icon: Image.asset(Assets.summation),
                                  onPressed: () => {},
                                ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment:Alignment.topLeft,
                            child: const AggregatedItemWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TriangleSwipe(),
                ],
              ),
            ),
        ),);
      } else {
        return Container();
      }
    });
  }

  int getMinimumWidth() {
    if ((ScreenUtils.getInstance.screenWidthDp / 2) < 370) {
      return 10;
    } else {
      return 5;
    }
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
    var result =await KitchenModeApi.getInstance.dismissKot(kotHash);
    if(result.code==ResCode().failed) {
      Navigator.pop(context);
      showMessageDialog("Alert", "Failed to send data to Kitchen Sum Mode");
      _kotcontroller.getKOTList();
      return;
    }
      for (final element in list) {
        removeKot(element);
      }
      await _resetFilter();
      NavigationService.getInstance.goBack();

  }

  Future<void> removeKot(Kot element) async {
    PrinterService.getInstance.printKOT(element.id, isMSwip: true);
    await DataService.getInstance.updateIsDismissed(element.id);
    Get.find<KOTController>().addDismissedKot(element);
    Get.find<KOTController>().kotList.removeWhere((kot) => kot!.id! == element.id);
    Get.find<KOTController>().kotList.refresh();
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
