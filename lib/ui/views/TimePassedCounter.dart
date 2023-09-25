import 'package:flutter/material.dart';
import 'package:kwantapo/bloc/TimerProvider.dart';
import 'package:kwantapo/lang/AppLocalization.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class TimePassedCounter extends StatefulWidget {

  final String receivedTime;
  final double containerWidth;
  const TimePassedCounter({
    Key? key,
    required this.receivedTime,
    required this.containerWidth
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TimePassedCounter();
}

class _TimePassedCounter extends State<TimePassedCounter> {
  late final String receivedTime;
  late TimerProvider timerProvider;

  @override
  void initState() {
    receivedTime = widget.receivedTime;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(mounted) {
      timerProvider = TimerProvider(receivedTime);
      timerProvider.start();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(left: 2, bottom: 4,top: 2),
      //AppSpaces().smallLeftBottom,
      width: 190,
      child: ValueListenableBuilder<String>(
        valueListenable: timerProvider,
        builder: (context, unit, _) {
          return Text("${AppLocalization.instance.translate("time_passed")} ${timerProvider.passedTime}",
            style: TextStyles().titleStyleColored(
              color: AppTheme.lightRed,
              textSize: (widget.containerWidth/20)*0.6,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    timerProvider.stop();
    timerProvider.dispose();
    super.dispose();
  }
}
