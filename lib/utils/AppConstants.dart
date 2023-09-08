import 'package:flutter/cupertino.dart';

class AppConstants {

  final String APP_NAME = "KWANTA P.O.";
  final String appVersion = "v0.0.55";
  static bool isStartup = false;
  static bool isServerInitialized = false;
  static bool ascendingKot = true;
  static bool printCategorySlip = true;
  static bool isAutoSum = false;
  static bool sumMode = false;
  static bool isProcessing = false;
  static String ipAddress="";
  static String port ="";
  static int noOfKot = 2;
  static bool fromSettings = false;
  static bool clickOfClock = false;
  static const String SELECT_MODE = "SELECT_MODE";
  static const String KITCHEN_MODE = "KITCHEN_MODE";
  static const String KITCHEN_SUM_MODE = "KITCHEN_SUM_MODE";
  static const String WAITER_MODE = "WAITER_MODE";
  static String selectedMode = "";
  static bool notificationSound = true;
  static const double textSize = 14;
  static const double fontWeight = 300;
  static BuildContext? context = null;
  final double mobileDevice = 420;
  final minutes = [0,1,2,3,4,5,6,7,8,9, 10, 11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59];
  final minuteNumber = [2,5,10,15,20,25,30,40,50,60,90];
  final hours = [0,1,2,3,4,5,6,7,8,9, 10, 11];
  final twentyFourHourFormat = [12,13,14,15,16,17,18,19,20,21,22,23];
  final twelveHourFormat=['0 AM','1 AM','2 AM','3 AM','4 AM','5 AM','6 AM','7 AM','8 AM','9 AM','10 AM','11 AM','0 PM','1 PM','2 PM','3 PM','4 PM','5 PM','6 PM','7 PM','8 PM','9 PM','10 PM','11 PM'];

}

