import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class AggregatedItemFullViewWidget extends StatefulWidget {

  const AggregatedItemFullViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  _AggregatedItemFullViewWidgetState createState() => _AggregatedItemFullViewWidgetState();

}

class _AggregatedItemFullViewWidgetState extends State<AggregatedItemFullViewWidget> {
  final AggregatedItemController _controller = Get.find<AggregatedItemController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        direction: Axis.vertical,
        children: [
          ..._controller.aggregatedList.map((agr) {
            return Container(
              width: 300,
              decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey),
                  ),
              ),
              padding: AppSpaces().smallLeftRight,
              child: Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${agr.count}x ${agr.item!.trim()} ${agr.unit!}", style: TextStyles().kotTextLargeSummation()),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...agr.eItemAddition.map((e) => Padding(padding: AppSpaces().smallLeft, child: Text(e!.itemAddition.trim(), style: TextStyles().kotTextNormalSummation()),))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...agr.childItems.map((e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: AppSpaces().smallLeft, child: Text(getChildItemLine(e!), style: TextStyles().kotTextMediumSummation()),),
                              ...e.eItemAddition.map((e) => Container(
                                margin: const EdgeInsets.only(left: 30), child: Text(e!.itemAddition.trim(), style: TextStyles().kotTextNormalSummation()),),)
                            ],
                          ),),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            );
          })
        ],
      ),
    ),);
  }

  String getChildItemLine(ChildItem e){
    if(e.item!.trim().startsWith("+")){
      return "+ ${e.quantity}x ${e.item!.replaceFirst("+", "").trim()} ${e.unit!}";
    } else {
      return "- ${e.quantity}x ${e.item!.replaceFirst("-", "").trim()} ${e.unit!}";
    }
  }
}
