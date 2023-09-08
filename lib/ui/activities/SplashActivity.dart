import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class SplashActivity extends StatefulWidget {

  @override
  _SplashActivityState createState() => _SplashActivityState();

}

class _SplashActivityState extends State<SplashActivity> {

  final String _tag = "SplashActivity";
  Logger? _logger;

  @override
  void initState() {
    super.initState();
    try {
      _logger = Logger.getInstance;
      _preInit();
      _postInit();
    } catch (error) {
      _logger?.e(_tag, "initState()", message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.getInstance.init(context);
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        alignment: Alignment.center,
        child: const SizedBox(
          width: 350,
          child: Image(
            image: AssetImage(Assets.appLogo),
          ),
        ),
      ),
    );
  }

  Future<void> _preInit() async {
    _logger?.d(_tag, "preInit()");
    PrefUtils().getAscendingKot().then((value) => AppConstants.ascendingKot = value!);
    PrefUtils().getSound().then((value) => AppConstants.notificationSound = value!);
    PrefUtils().getAutoSum().then((value) => AppConstants.isAutoSum = value);
    PrefUtils().getNoOfKOT().then((value) => AppConstants.noOfKot = value);
    PrefUtils().getSumMode().then((value) => AppConstants.sumMode = value!);
  }

  Future<void> _postInit() async {
    _logger?.d(_tag, "postInit()");
    AppConstants.selectedMode = (await PrefUtils().getSaveSelectedMode())!;
    Timer(const Duration(seconds: 2), () async {
      if(AppConstants.selectedMode==AppConstants.SELECT_MODE) {
        NavigationService.getInstance.modeSelectionScreen();
      } else {
        if (AppConstants.selectedMode==AppConstants.KITCHEN_SUM_MODE) {
          AppConstants.sumMode = true;
          NavigationService.getInstance.kitchenSMDashboardActivityFromAll();
        } else {
          await SystemService.getInstance.initializeServer();
          NavigationService.getInstance.dashboardActivityFromAll();
        }
      }
    });
  }

}
