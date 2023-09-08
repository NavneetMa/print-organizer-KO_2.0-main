import 'package:get/get.dart';

class NavigationService {

  static NavigationService? _instance;
  factory NavigationService() => getInstance;
  NavigationService._();

  static NavigationService get getInstance {
    if (_instance == null) {
      _instance =  NavigationService._();
    }
    return _instance!;
  }
  void dashboardActivityFromAll() => Get.offAllNamed('/dashboardActivity');

  void kitchenSMDashboardActivityFromAll() => Get.offAllNamed('/kitchenSMDashboardActivity');

  void dashboardActivity() => Get.toNamed('/dashboardActivity');

  void logsActivity() => Get.toNamed("/logsActivity");

  void settingsActivity() => Get.toNamed('/settingsActivity');

  void configurationActivity() => Get.toNamed('/configurationActivity');

  void configurationActivitySumMode() => Get.toNamed('/configurationActivitySumMode');

  void goBack() => Get.back();

  void settingsOff() => Get.offNamedUntil('/settingsActivity', (route) => false);

  void modeSelectionScreen() => Get.offAllNamed('/modeSelectionScreen');

}
