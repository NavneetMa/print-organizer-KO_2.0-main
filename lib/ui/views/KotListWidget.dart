import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/data/ResCode.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/interfaces/ILoadingDialog.dart';
import 'package:kwantapo/ui/interfaces/IMessageDialog.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/ui/views/model/KotListWidgetModel.dart';
import 'package:kwantapo/utils/lib.dart';

class KotListWidget extends StatefulWidget {

  final double kotWidth;
  final double containerWidth;

  const KotListWidget({
    Key? key,
    required this.kotWidth,
    required this.containerWidth,
  }) : super(key: key);

  @override
  State<KotListWidget> createState() => _KotListWidgetState();
}

class _KotListWidgetState extends State<KotListWidget> implements ILoadingDialog,IMessageDialog {

  final KOTController _controller = Get.find<KOTController>();
  final _systemService = SystemService.getInstance;

  @override
  void initState() {
    _systemService.setLoadingDialog(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const LoadingIndicator();
      } else if (_controller.kotList.isEmpty) {
        return const NoData();
      } else if(_controller.showSnoozeList.value==true){
        if(_controller.kotList.where((p0) => p0?.hideKot==true).toList().isEmpty){
          return const NoData();
        }
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (AppConstants.noOfKot < 8) Expanded(
            flex: 10,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _controller.kotList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return KotCardAndHeadView(
                  kotWidth: widget.kotWidth,
                  containerWidth: widget.containerWidth,
                  kot: _controller.kotList[index]!,
                  onDismissed: (DismissDirection direction) => _swipeUpToRemoveKot(index, context),
                  onKotSum: KotListWidgetModel.getInstance.onKotSum,
                  onKotFinished: KotListWidgetModel.getInstance.onKotFinished,
                  onKotPrinterPressed: onKotPrinterPressed,
                  kotIndex: index + 1,
                  showSnoozeList: _controller.showSnoozeList.value,
                  tableMatch:_controller.kotList[index]!.tableNameMatch,
                );
              },
            ),
          ) else Expanded(
            flex: 10,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:AppConstants.noOfKot~/2,
                  childAspectRatio: 2/3,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 450,
                  crossAxisSpacing: 10,
              ),
              shrinkWrap: true,
              itemCount: _controller.kotList.length,
              itemBuilder: (BuildContext context, int index) => KotCardAndHeadView(
                kotWidth: widget.kotWidth,
                containerWidth: widget.containerWidth,
                kot: _controller.kotList[index]!,
                onDismissed: (DismissDirection direction) => _swipeUpToRemoveKot(index,context),
                onKotSum: KotListWidgetModel.getInstance.onKotSum,
                onKotFinished: KotListWidgetModel.getInstance.onKotFinished,
                onKotPrinterPressed: onKotPrinterPressed,
                kotIndex: index + 1,
                showSnoozeList: _controller.showSnoozeList.value,
                tableMatch: _controller.kotList[index]!.tableNameMatch,
              ),
            ),
          ),
          //Kot Sum Panel UI
          const SummationPanelView()
        ],
      );
    });
  }

  Future<void> _swipeUpToRemoveKot(int index,BuildContext context) async {
    showLoadingDialog('Printing KOT');
    final kotId = _controller.kotList[index]!.id!;
    var result = await KitchenModeApi.getInstance.dismissKot([_controller.kotList[index]!.hashMD5!]);
    if(result.code==ResCode().failed) {
      Navigator.pop(context);
      showMessageDialog("Alert", "Failed to send data to Kitchen Sum Mode");
      _controller.getKOTList();
      return;
    }
    try {
      await DataService.getInstance.updateIsDismissed(kotId);
      await _controller.addDismissedKot(_controller.kotList[index]);
      await _controller.removeFromList(index);
      await DataService.getInstance.removeFromSummationList(kotId);
      _resetFilter();
    } finally{
      Navigator.pop(context);
      PrinterService.getInstance.printKOT(kotId, isMSwip: true);
    }
  }
//
//   void onKotSum(int id) {
//     final kot = _controller.kotList.firstWhere((kot) => kot!.id! == id);
//     DataService.getInstance.addAggregateItems(id,hideKot: kot!.hideKot);
//   }
// //
//   void onKotFinished(Kot kot) {
//     final duration = DateTimeUtils.getInstance.getTimePassed(DateTime.parse(kot.receivedTime!));
//     MasterTerminalService.getInstance.sendFinishedKot(kot.id!, duration);
//   }

  Future<bool> _resetFilter() async {
      return Get.find<FilterController>().resetFilter();
  }

  Future<void> onKotPrinterPressed(int kotIndex, EPrinter ePrinter,BuildContext context) async{
    showLoadingDialog('Printing KOT');
    final kotId = _controller.kotList[kotIndex]!.id!;
    var result= await KitchenModeApi.getInstance.dismissKot([_controller.kotList[kotIndex]!.hashMD5!]);
    if(result.code==ResCode().failed) {
      Navigator.pop(context);
      showMessageDialog("Alert", "Failed to send data to Kitchen Sum Mode");
      _controller.getKOTList();
      return;
    }
      DataService.getInstance.updateIsDismissed(kotId);
      await DataService.getInstance.removeFromSummationList(kotId);
      _controller.removeFromList(kotIndex);
      DataService.getInstance.removeKot(kotId);
      NavigationService.getInstance.goBack();
      PrinterService.getInstance.printKOTFromSinglePrinter(kotId,ePrinter);
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
