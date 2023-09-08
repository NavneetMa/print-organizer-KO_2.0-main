import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class PrintKotFinished extends StatefulWidget {

  final BuildContext? context;
  final String? title;
  final bool? value;
  final bool? isShortSlip;
  final void Function(bool?) printKotFinished;
  final void Function(bool?) shortSlip;

  const PrintKotFinished({
    Key? key,
    @required this.context,
    @required this.title,
    @required this.value,
    required this.printKotFinished,
    required this.shortSlip,
    required this.isShortSlip,
  }) : super(key: key);

  @override
  _PrintKotFinished createState() => _PrintKotFinished();

}

class _PrintKotFinished extends State<PrintKotFinished> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextLabel(title: AppLocalization.instance.translate(widget.title!)),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      AppLocalization.instance.translate("no"),
                      style: TextStyles().hintStyle(),
                  ),
                  CupertinoSwitch(
                    value: widget.value!,
                    onChanged: widget.printKotFinished,
                    activeColor: AppTheme.colorAccent,
                  ),
                  Text(
                      AppLocalization.instance.translate("yes"),
                      style: TextStyles().hintStyle(),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          width: 140,
          margin: AppSpaces().smallRightTop,
          child: CheckboxListTile(
            contentPadding: EdgeInsets.zero,
              activeColor: AppTheme.nearlyBlack,
              dense: true,
              title: Text(AppLocalization.instance.translate("short_slip")),
              value: widget.isShortSlip, onChanged: widget.shortSlip,),
        )
      ],
    );
  }
}
