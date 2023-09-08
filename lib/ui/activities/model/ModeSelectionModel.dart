import 'package:kwantapo/services/NavigationService.dart';
import 'package:kwantapo/services/SystemService.dart';
import 'package:kwantapo/utils/AppConstants.dart';
import 'package:kwantapo/utils/PrefUtils.dart';

class ModeSelectionModel{
  static ModeSelectionModel? _instance;
  factory ModeSelectionModel() => getInstance;
  ModeSelectionModel._();

  static ModeSelectionModel get getInstance {
    _instance ??= ModeSelectionModel._();
    return _instance!;
  }
  Future<void> saveSelectedMode() async {
    await PrefUtils().setSaveSelectedMode(AppConstants.selectedMode);
    if(AppConstants.selectedMode == AppConstants.KITCHEN_SUM_MODE){
      AppConstants.sumMode=true;
      await PrefUtils().setSumMode(true);
      NavigationService.getInstance.kitchenSMDashboardActivityFromAll();
    } else {
      await SystemService.getInstance.initializeServer();
      NavigationService.getInstance.dashboardActivityFromAll();
    }
  }

  Future<void> updateFirstLaunchFlag() async {
    await PrefUtils().setUpdateFirstFlag(false);
  }
}