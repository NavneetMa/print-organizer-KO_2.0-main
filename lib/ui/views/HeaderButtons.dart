import 'package:flutter/material.dart';
import 'package:kwantapo/data/podos/Kot.dart';
import 'package:kwantapo/ui/views/SnoozeTimeSelector.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/AppTheme.dart';
import 'package:kwantapo/utils/Assets.dart';

class HeaderButtons extends StatelessWidget{

  const HeaderButtons({
    required this.kot,
    required this.kotIndex,
    required this.onKotSum,
  }): super();

  final Kot kot;
  final int kotIndex;
  final void Function(int) onKotSum;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpaces().smallVerticalHorizontal,
      decoration: BoxDecoration(
          border: Border.all(
              color: AppTheme.greyBorder,
          ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppTheme.colorAccentLight,
                borderRadius:
                BorderRadius.all(Radius.circular(2)),
              ),
              child: Text(
                kotIndex.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold,),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: kot.tableNameMatch
                    ? AppTheme.mediumRed
                    : AppTheme.colorAccentLight,
                borderRadius:
                const BorderRadius.all(Radius.circular(2)),
              ),
              child: IconButton(
                icon: const Icon(Icons.fastfood),
                iconSize: 24,
                onPressed: () => {},
                //widget.kot!.summation ? Snack.show(context, AppLocalization.instance.translate("kot_already_added_to_total")) : widget.onKotSum!(widget.kot!.id!),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: kot.inSum
                    ? AppTheme.mediumRed
                    : AppTheme.colorAccentLight,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
              ),
              child: IconButton(
                icon: Image.asset(Assets.summation),
                iconSize: 24,
                onPressed: () => onKotSum(kot.id!),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppTheme.colorAccentLight,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              child: IconButton(
                onPressed: () {
                  showSnoozeDialog(context, kotIndex, kot,);
                },
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.access_alarms_outlined,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSnoozeDialog(BuildContext context, int kotIndex, Kot kot) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: AppSpaces().mediumAll,
          child: SnoozeTimeSelector(kotIndex: kotIndex, kot: kot),
        );
      },
    );
  }
}