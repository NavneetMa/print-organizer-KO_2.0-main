import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

class WidgetSize extends StatefulWidget {

  final Widget? child;
  final Function? onChange;

  const WidgetSize({
    Key? key,
    @required this.onChange,
    @required this.child,
  }) : super(key: key);

  @override
  _WidgetSizeState createState() => _WidgetSizeState();

}

class _WidgetSizeState extends State<WidgetSize> {

  T? _ambiguate<T>(T? value) => value;
  @override
  Widget build(BuildContext context) {
    _ambiguate(SchedulerBinding.instance)!.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  GlobalKey<State<StatefulWidget>> widgetKey = GlobalKey();
  var oldSize;

  void postFrameCallback(_) {
    final context = widgetKey.currentContext;
    if (context == null) return;
    final newSize = context.size;
    if (oldSize == newSize) return;
    oldSize = newSize;
    widget.onChange!(newSize);
  }

}