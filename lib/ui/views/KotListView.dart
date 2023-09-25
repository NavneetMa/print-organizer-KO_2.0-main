import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class KotListView extends StatefulWidget {
  const KotListView({
    Key? key,
  }) : super(key: key);

  @override
  State<KotListView> createState() => _KotListViewState();
}

class _KotListViewState extends State<KotListView> {

  final double _kotWidth = 364;
  double _containerWidth = 364;
  T? _ambiguate<T>(T value) => value;

  @override
  void initState() {
    _ambiguate(SchedulerBinding.instance)!.addPostFrameCallback((_) {
      // PrefUtils().getNoOfKOT().then((value) {
      //   setState(() {
      //     if (value == 1) {
      //       _containerWidth = 364;
      //     } else {
      //       _containerWidth = (ScreenUtils.getInstance.screenWidthDp) / value;
      //     }
      //   });
      // });
    });
    PrefUtils().getPrintCategorySlip().then((value) => AppConstants.printCategorySlip = value!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (AppConstants.sumMode) {
      return const SummationPanelFullView();
    } else {
      return KotListWidget(kotWidth: _kotWidth, containerWidth: _containerWidth);
    }
  }
}
