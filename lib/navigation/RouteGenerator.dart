import 'package:get/get.dart';
import 'package:kwantapo/bloc/KitchenSMDashboardBinding.dart';
import 'package:kwantapo/bloc/lib.dart';
import 'package:kwantapo/ui/activities/ModeSelectionScreen.dart';
import 'package:kwantapo/ui/activities/kitchen_sum_mode/KitchenSMDashboardActivity.dart';
import 'package:kwantapo/ui/lib.dart';

class RouteGenerator {

  final routes = [
    GetPage(name: '/splashActivity', page: () => SplashActivity()),
    GetPage(name: '/modeSelectionScreen', page: () => ModeSelectionScreen()),
    GetPage(name: '/dashboardActivity', page: () => DashboardActivity(), bindings: [DashboardBinding()]),
    GetPage(name: '/settingsActivity', page: () => const SettingsActivity()),
    GetPage(name: '/logsActivity', page: () => const LogsActivity()),
    GetPage(name: '/configurationActivity', page: () => const ConfigurationActivity()),
    GetPage(name: '/configurationActivitySumMode', page: () => const ConfigurationSumModeActivity()),
    GetPage(name: '/kitchenSMDashboardActivity', page: () => KitchenSMDashboardActivity(), bindings: [KitchenSMDashboardBinding()]),
  ];

}
