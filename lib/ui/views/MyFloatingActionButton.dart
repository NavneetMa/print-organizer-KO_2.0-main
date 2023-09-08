import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/views/FilterView.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class MyFloatingActionButtons extends StatelessWidget {
  final _dataService = DataService.getInstance;
  final _controller = Get.find<KOTController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: AppSpaces().smallBottom,
          child: FloatingActionButton(
            heroTag: 1,
            onPressed: () => _dataService.addDismissedKotOnUndo(),
            backgroundColor: AppTheme.colorPrimary,
            child: const Icon(Icons.undo_outlined),
          ),
        ),
        Container(
          margin: AppSpaces().smallBottom,
          child: Obx(
                () => FloatingActionButton(
              heroTag: 2,
              backgroundColor: _controller.showSnoozeList.value ? AppTheme.colorAccentLight : AppTheme.colorPrimary,
              onPressed: () async {
                AppConstants.clickOfClock = true;
                _controller.showSnoozeList.value = !_controller.showSnoozeList.value;
                _controller.getKOTList();
              },
              child: const Icon(Icons.alarm),
            ),
          ),
        ),
        FloatingActionButton(
          heroTag: 3,
          backgroundColor: AppTheme.colorPrimary,
          onPressed: () => showFilter(context),
          child: const Icon(Icons.filter_list_alt),
        ),
      ],
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
