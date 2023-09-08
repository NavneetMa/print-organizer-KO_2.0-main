import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class KotCardAndHeadView extends StatefulWidget {

  final Kot kot;
  final void Function(DismissDirection) onDismissed;
  final void Function(int) onKotSum;
  final void Function(Kot) onKotFinished;
  final void Function(int, EPrinter, BuildContext) onKotPrinterPressed;
  final int kotIndex;
  final double kotWidth;
  final double containerWidth;
  final bool showSnoozeList;
  final bool tableMatch;

  const KotCardAndHeadView({
    Key? key,
    required this.kot,
    required this.onDismissed,
    required this.onKotSum,
    required this.onKotFinished,
    required this.onKotPrinterPressed,
    required this.kotIndex,
    required this.kotWidth,
    required this.containerWidth,
    required this.showSnoozeList,
    required this.tableMatch,
  }) : super(key: key);

  @override
  _KotCardAndHeadView createState() => _KotCardAndHeadView();

}

class _KotCardAndHeadView extends State<KotCardAndHeadView> {

  double _height = 0;
  bool _addScroll = false;

  @override
  void initState() {
    if (widget.kot.hideKot){
      widget.kot.showKot();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = ScreenUtils.getInstance.screenHeightDp;
    return widget.showSnoozeList && widget.kot.hideKot ? WidgetSize(onChange: onChange, child: Container(
        width: widget.containerWidth,
        alignment: Alignment.topCenter,
        child: SizedBox(
            width: widget.kotWidth,
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.up,
              onDismissed: (DismissDirection dismiss) => {
                widget.onDismissed(dismiss),
                widget.onKotFinished(widget.kot)
              },
              child: Flex(
                direction: Axis.vertical,
                children: [
                  KotHead(
                    kot: widget.kot,
                    onKotSum: widget.onKotSum,
                    onKotPrinterPressed: widget.onKotPrinterPressed,
                    kotIndex: widget.kotIndex,
                    tableMatch: widget.tableMatch,
                    containerWidth: widget.containerWidth,
                  ),
                  Flexible(
                      child: KotCard(
                        kot: widget.kot,
                        kotIndex: widget.kotIndex,
                        addScroll: _addScroll,
                      ),
                  )
                ],
              ),
            ),
        ),
    ),) : widget.showSnoozeList && widget.kot.hideKot == false ? Container() :
    widget.showSnoozeList == false && widget.kot.hideKot == true ? Container() :
    WidgetSize(onChange: onChange, child: Container(
        width: widget.containerWidth,
        alignment: Alignment.topCenter,
        child: SizedBox(
            width: widget.kotWidth,
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.up,
              onDismissed: (DismissDirection dismiss) => {
                widget.onDismissed(dismiss),
                widget.onKotFinished(widget.kot)
              },
              child: Flex(
                direction: Axis.vertical,
                children: [
                  KotHead(
                    kot: widget.kot,
                    onKotSum: widget.onKotSum,
                    onKotPrinterPressed: widget.onKotPrinterPressed,
                    kotIndex: widget.kotIndex,
                    tableMatch: widget.tableMatch,
                    containerWidth: widget.containerWidth,
                  ),
                  Flexible(
                      child: KotCard(
                        kot: widget.kot,
                        kotIndex: widget.kotIndex,
                        addScroll: _addScroll,
                      ),
                  )
                ],
              ),
            ),
        ),
    ),);
  }

  void onChange(Size size) {
    if (size.height < _height - 200) {
      setState(() {
        _addScroll = false;
      });
    } else {
      setState(() {
        _addScroll = true;
      });
    }
  }
}
