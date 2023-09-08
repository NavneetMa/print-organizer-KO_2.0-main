import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kwantapo/services/kitchen_mode_api/KitchenModeApi.dart';
import 'package:kwantapo/services/kitchen_sum_mode_api/KitchenSumModeAPI.dart';
import 'package:kwantapo/utils/lib.dart';
import 'package:kwantapo/App.dart';
import 'package:wakelock/wakelock.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppTheme.colorPrimary,
      statusBarBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(Material(child: App()));
  KitchenSumModeAPI.getInstance.configureChannel();
  KitchenModeApi.getInstance.configureChannel();
}
