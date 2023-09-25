import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/KOTController.dart';
import 'package:kwantapo/data/podos/Kot.dart';
import 'package:kwantapo/ui/views/SnoozeTimeSelector.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/AppTheme.dart';
import 'package:kwantapo/utils/Assets.dart';

class HeaderButtons extends StatelessWidget{

   HeaderButtons({
    required this.kot,
    required this.kotIndex,
    required this.onKotSum,
    required this.containerWidth
  }): super();

  final Kot kot;
  final int kotIndex;
  final void Function(int) onKotSum;
  final double containerWidth;

  final _controller = Get.find<KOTController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
      //AppSpaces().smallVerticalHorizontal,
      decoration: BoxDecoration(
          border: Border.all(
              color: AppTheme.greyBorder,
          ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: Wrap(
          spacing: 5,
          runSpacing: 10,
          children: [
            Container(
              width: containerWidth/15,
              height: containerWidth/15,
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
              width: containerWidth/15,
              height: containerWidth/15,
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
                    Icons.access_alarms_outlined),
                iconSize: (containerWidth / 20) * 0.7,
              ),
            ),
            Container(
              width: containerWidth/15,
              height: containerWidth/15,
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
                iconSize: (containerWidth / 20) * 0.7,
                onPressed: () => {},
                //widget.kot!.summation ? Snack.show(context, AppLocalization.instance.translate("kot_already_added_to_total")) : widget.onKotSum!(widget.kot!.id!),
              ),
            ),
        // Obx(() {
        //     return
              Container(
              width: containerWidth/15,
              height: containerWidth/15,
              alignment: Alignment.center,
              decoration:  BoxDecoration(
                color: kot.eyeColor?AppTheme.red:AppTheme.yellow,
                //widget.kot.eyeColor.value ?AppTheme.red:AppTheme.yellow,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              child: IconButton(
                icon: const Icon(Icons.remove_red_eye_outlined),
                iconSize: (containerWidth / 20) * 0.7,
                onPressed: () async => {
                await _controller.toggleEyeColor(kot),
                },
              ),
            ),
        //   }
        // ),
            // Container(
            //   width: 36,
            //   height: 36,
            //   decoration: BoxDecoration(
            //     color: kot.inSum
            //         ? AppTheme.mediumRed
            //         : AppTheme.colorAccentLight,
            //     borderRadius: const BorderRadius.all(Radius.circular(2)),
            //   ),
            //   child: IconButton(
            //     icon: Image.asset(Assets.summation),
            //     iconSize: 24,
            //     onPressed: () => onKotSum(kot.id!),
            //   ),
            // ),

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
