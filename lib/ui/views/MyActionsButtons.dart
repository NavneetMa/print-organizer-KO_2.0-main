import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/views/FilterView.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class MyActionButtons extends StatelessWidget {
  final double containerWidth;
   MyActionButtons({required this.containerWidth});

  final _dataService = DataService.getInstance;

  final _controller = Get.find<KOTController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth,
      padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
      child: Wrap(
        spacing: 15,
        runSpacing: 10,
        children: [
          Container(
            width: containerWidth/5,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppTheme.colorPrimary,
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
            child: IconButton(
              onPressed: () => _dataService.addDismissedKotOnUndo(),
              icon:  const Icon(Icons.undo_outlined),
              iconSize: containerWidth/8,
              color: AppTheme.nearlyWhite,
            ),
          ),
          Obx(
                () => Container(
                  width: containerWidth/5,
                  alignment: Alignment.center,
                  decoration:  BoxDecoration(
                    color: _controller.showSnoozeList.value
                        ? AppTheme.colorAccentLight
                        : AppTheme.colorPrimary,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  child: IconButton(
              onPressed: () async {
                  AppConstants.clickOfClock = true;
                  _controller.showSnoozeList.value = !_controller.showSnoozeList.value;
                  _controller.getKOTList();
              },
              icon:  const Icon(Icons.alarm),
                    iconSize: containerWidth/8,
                    color: AppTheme.nearlyWhite,
            ),
                ),
          ),
          Container(
            width: containerWidth/5,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppTheme.colorPrimary,
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
            child: IconButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.colorPrimary),
              onPressed: () => showFilter(context),
              icon: Icon(Icons.filter_list_alt),
              iconSize: containerWidth/8,
              color: AppTheme.nearlyWhite,
            ),
          ),
        ],
      ),
    );
  }

  void showFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterView();
      },
    );
  }
}
