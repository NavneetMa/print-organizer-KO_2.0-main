import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/interfaces/IMessageDialog.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class AggregatedItemWidget extends StatefulWidget {

  const AggregatedItemWidget({
    Key? key,
  }) : super(key: key);

  @override
  _AggregatedItemWidgetState createState() => _AggregatedItemWidgetState();

}

class _AggregatedItemWidgetState extends State<AggregatedItemWidget> implements IMessageDialog{

  AggregatedItemController aggregateItemController = Get.find<AggregatedItemController>();
  final AggregatedItemController _controller = Get.find<AggregatedItemController>();
  final _dataService = DataService.getInstance;

  @override
  void initState() {
    super.initState();
    _dataService.setMessageDialog(this);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _controller.aggregatedList.length,
      itemBuilder: (BuildContext context, int index) {
        final aggr = _controller.aggregatedList[index];
        return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SummationItem(aggrItem: aggr, updateItemChecked: updateItemChecked,index: index),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...aggr.eItemAddition.map((e) => Padding(padding: AppSpaces().smallLeft, child: Text(e!.itemAddition.trim(), style: TextStyles().kotTextNormal()),))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...aggr.childItems.map((e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: AppSpaces().smallLeft, child: Text(getChildItemLine(e!), style: TextStyles().kotTextMedium()),),
                              ...e.eItemAddition.map((e) => Container(
                                margin: const EdgeInsets.only(left: 30), child: Text(e!.itemAddition.trim(), style: TextStyles().kotTextNormal()),),)
                            ],
                          ),),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
        );
      },
    );
  }

  String getChildItemLine(ChildItem e){
    if(e.item!.trim().startsWith("+")){
      return "+ ${e.quantity}x ${e.item!.replaceFirst("+", "").trim()} ${e.unit!}";
    } else {
      return "- ${e.quantity}x ${e.item!.replaceFirst("-", "").trim()} ${e.unit!}";
    }
  }



  void updateItemChecked(bool checked, int index) async {
    Future.delayed(const Duration(milliseconds: 500), () async {
      await DataService.getInstance.updateItem(index,aggregateItemController.aggregatedList,aggregateItemController);
      _resetFilter();
    });

  }

  Future<bool> _resetFilter() async {
    return Get.find<FilterController>().resetFilter();
  }

  @override
  void showMessageDialog(String? title, String message) {
    showDialog(context: context, builder: (BuildContext context) {
      return MessageDialog(title: title,message: message);
    },);
  }

}