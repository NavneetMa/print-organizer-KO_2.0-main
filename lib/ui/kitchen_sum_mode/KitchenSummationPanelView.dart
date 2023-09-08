import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kwantapo/lang/AppLocalization.dart';
import 'package:kwantapo/services/DataService.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/Assets.dart';
import 'package:kwantapo/utils/TextStyles.dart';

class KitchenSummationPanelView extends StatefulWidget {

  const KitchenSummationPanelView({
    Key? key,
  }) : super(key: key);

  @override
  _KitchenSummationPanelView createState() => _KitchenSummationPanelView();

}

class _KitchenSummationPanelView extends State<KitchenSummationPanelView> {

  T? _ambiguate<T>(T? value) => value;

  @override
  void initState() {
    super.initState();
    _ambiguate(SchedulerBinding.instance)!.addPostFrameCallback((_) => DataService.getInstance.getKOTListForSummation());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: AppSpaces().mediumLeftBottomTop,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(AppLocalization.instance.translate("total"), style: TextStyles().titleStyleLargeBlack()),
                SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      icon: Image.asset(Assets.summation),
                      onPressed: () => {},
                    ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                alignment:Alignment.topLeft,
                child: const AggregatedItemFullViewWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
