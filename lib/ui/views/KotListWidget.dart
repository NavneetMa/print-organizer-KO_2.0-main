import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/data/ResCode.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/interfaces/ILoadingDialog.dart';
import 'package:kwantapo/ui/interfaces/IMessageDialog.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/ui/views/MyActionButtons.dart';
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
  int currentPage = 0;
  int totalItemCount = 0;

  @override
  void initState() {
    _systemService.setLoadingDialog(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //return Obx(() {
      // if (_controller.isLoading.value) {
      //   return const LoadingIndicator();
      // } else if (_controller.kotList.isEmpty) {
      //   return const NoData();
      // } else if(_controller.showSnoozeList.value==true){
      //   if(_controller.kotList.where((p0) => p0?.hideKot==true).toList().isEmpty){
      //     return const NoData();
      //   }
      // }
      return LayoutBuilder(
        builder: (context, constraints) {
          double parentWidth = constraints.maxWidth;
          double buttonContainerWidth = parentWidth/1.5;
          double mybuttonWidth = parentWidth - buttonContainerWidth;
          return Column(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // if (AppConstants.noOfKot < 8) Expanded(
                    //   flex: 10,
                    //   child: ListView.builder(
                    //     shrinkWrap: true,
                    //     itemCount: _controller.kotList.length,
                    //     scrollDirection: Axis.horizontal,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       return KotCardAndHeadView(
                    //         kotWidth: widget.kotWidth,
                    //         containerWidth: widget.containerWidth,
                    //         kot: _controller.kotList[index]!,
                    //         onDismissed: (DismissDirection direction) => _swipeUpToRemoveKot(index, context),
                    //         onKotSum: KotListWidgetModel.getInstance.onKotSum,
                    //         onKotFinished: KotListWidgetModel.getInstance.onKotFinished,
                    //         onKotPrinterPressed: onKotPrinterPressed,
                    //         kotIndex: index + 1,
                    //         showSnoozeList: _controller.showSnoozeList.value,
                    //         tableMatch:_controller.kotList[index]!.tableNameMatch,
                    //       );
                    //     },
                    //   ),
                    // ) else
                      Flexible(
                       flex: 10,
                      child: _buildKotList(),
                    ),
                    //Kot Sum Panel UI
                    const SummationPanelView()
                  ],
                ),
              ),
              //Navigation Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: buttonContainerWidth,
                    child: Row(
                      children: [
                        Container(
                          width: parentWidth<420?buttonContainerWidth/3.1:null,
                          padding: EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              if (currentPage > 0) {
                                setState(() {
                                  currentPage--;
                                });
                              }
                            },
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text("Previous")),
                          ),
                        ),
                        Spacer(),
                        // Added Container to display total number of KOTs
                        Obx(() {
                            return Container(
                              width: parentWidth<420?buttonContainerWidth/3.1:null,
                              height: 35,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppTheme.colorPrimary, // Assuming the Next button uses the primaryColor
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  "Total number of KOT: ${_controller.kotList.length}", // Displaying total KOTs
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                        Spacer(),
                        Container(
                          width: parentWidth<420?buttonContainerWidth/3.1:null,
                          padding: EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              if (currentPage * totalItemCount + totalItemCount < _controller.kotList.length) {
                                setState(() {
                                  currentPage++;
                                });
                              }
                            },
                            child: Text("Next"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      MyActionButtons(containerWidth: mybuttonWidth),
                    ],
                  )
                ],
              ),
            ],
          );
        }
      );
    //});
  }


  Widget _buildKotList() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double gridWidth = constraints.maxWidth;
        double gridHeight = constraints.maxHeight; // The available height for the GridView.builder
         double kotHeight = gridHeight / 2.1; // Height for each KOT
        int crossAxisCount = (gridWidth / widget.kotWidth).floor();
        if (crossAxisCount <= 0) {
          crossAxisCount = 1;  // Set a default value or handle this case as you see fit
        }
        totalItemCount = (gridHeight / kotHeight).floor() * crossAxisCount;
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
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:crossAxisCount,
                //AppConstants.noOfKot~/2,
                childAspectRatio: 2/3,
                mainAxisSpacing: 10,
                mainAxisExtent: kotHeight,
                crossAxisSpacing: 10,
              ),
              shrinkWrap: true,
              itemCount: totalItemCount,
              itemBuilder: (BuildContext context, int index) {
                final actualIndex = currentPage * totalItemCount + index;
                if (actualIndex < _controller.kotList.length){
                  return KotCardAndHeadView(
                    kotWidth: widget.kotWidth,
                    containerWidth: widget.containerWidth,
                    kot: _controller.kotList[actualIndex]!,
                    onDismissed: (DismissDirection direction) => _swipeUpToRemoveKot(index,context),
                    onKotSum: KotListWidgetModel.getInstance.onKotSum,
                    onKotFinished: KotListWidgetModel.getInstance.onKotFinished,
                    onKotPrinterPressed: onKotPrinterPressed,
                    kotIndex: actualIndex + 1,
                    showSnoozeList: _controller.showSnoozeList.value,
                    tableMatch: _controller.kotList[index]!.tableNameMatch,
                  );
                } else {
                  return SizedBox.shrink(); // Return an empty widget if the index exceeds the total KOTs
                }
              },
            );

        });
      }
    );
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
