import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:kwantapo/utils/lib.dart';

class TimerProvider extends ValueNotifier<String> {

  String receivedTime = "";
  String passedTime = "--";
  Timer? _passedTime;

  TimerProvider(this.receivedTime) : super('');

  void start() {
    _passedTime = Timer.periodic(
      const Duration(seconds: 1), (Timer t) {
        passedTime = DateTimeUtils.getInstance.getTimePassed(DateTime.parse(receivedTime));
        notifyListeners();
      },
    );
  }

  void stop() {
    _passedTime?.cancel();
  }

}
