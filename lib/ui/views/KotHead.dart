import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/ui/views/HeaderRowView.dart';
import 'package:kwantapo/ui/views/HeaderWrapView.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class KotHead extends StatefulWidget {
  final Kot kot;
  final void Function(int) onKotSum;
  final void Function(int, EPrinter, BuildContext) onKotPrinterPressed;
  final int kotIndex;
  final bool tableMatch;
  final double containerWidth;

  const KotHead({
    Key? key,
    required this.kot,
    required this.onKotSum,
    required this.onKotPrinterPressed,
    required this.kotIndex,
    required this.tableMatch,
    required this.containerWidth,
  }) : super(key: key);

  @override
  _KotHead createState() => _KotHead();
}

class _KotHead extends State<KotHead> {

  @override
  void initState() {
    PrefUtils().getNoOfKOT().then((value) {
      AppConstants.noOfKot = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: AppSpaces().smallLeftRightTop,
        decoration: BoxDecoration(
          color: AppTheme.white,
          border: Border.all(color: AppTheme.greyBorder),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Column(
          children: [
            FutureBuilder(
              future: PrefUtils().getNoOfKOT(),
                initialData: AppConstants.noOfKot,
                builder: (context, asyncSnapshot) {
              if(asyncSnapshot.data==1) {
                return HeaderRowView(kot: widget.kot, kotIndex: widget.kotIndex, onKotSum: widget.onKotSum,);
              } else {
                return HeaderWrapView(kot: widget.kot, kotIndex: widget.kotIndex, onKotSum: widget.onKotSum,);
              }
            },),
            const Divider(
              thickness: 1,
              height: 1,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: PrinterController.printers.map((element) {
                    return Container(
                      margin: AppSpaces().smallRight,
                      child: TextButton(
                        onPressed: () => widget.onKotPrinterPressed(
                          widget.kotIndex, element, context,),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Assets().getColor(element.color).color,),
                        ),
                        child: Text(
                          element.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppTheme.nearlyWhite),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
