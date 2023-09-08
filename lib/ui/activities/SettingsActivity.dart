import 'package:flutter/material.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class SettingsActivity extends StatelessWidget {

  final BuildContext? context;

  const SettingsActivity({
    Key? key,
    this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActivityContainer(
      context: context,
      onBackPressed: onBackPressed,
      onBackPressedVoid: () => onBackPressedVoid(),
      title: AppLocalization.instance.translate("settings"),
      child: ListView(
        padding: AppSpaces().mediumVerticalHorizontal,
        shrinkWrap: true,
        children: [
          ListTile(
            leading: const Icon(Icons.app_settings_alt_outlined),
            title: Text(
              AppLocalization.instance.translate("configuration"),
              style: TextStyles().settingsStyle(),
            ),
            onTap: () {
              if(AppConstants.selectedMode == AppConstants.KITCHEN_SUM_MODE){
                NavigationService.getInstance.configurationActivitySumMode();
              }else{
                NavigationService.getInstance.configurationActivity();
              }
            },
          ),

          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: Text(
              AppLocalization.instance.translate("logs"),
              style: TextStyles().settingsStyle(),
            ),
            onTap: () => NavigationService.getInstance.logsActivity(),
          ),

          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: Text(
              AppLocalization.instance.translate("about"),
              style: TextStyles().settingsStyle(),
            ),
            onTap: () => {},
          ),

          const Divider(height: 1),
        ],
      ),
    );
  }

  void onBackPressedVoid() {
    if(AppConstants.selectedMode == AppConstants.KITCHEN_SUM_MODE) {
      NavigationService.getInstance.kitchenSMDashboardActivityFromAll();
    } else {
      NavigationService.getInstance.dashboardActivityFromAll();
    }
  }

  Future<bool> onBackPressed() async {
    if(AppConstants.selectedMode == AppConstants.KITCHEN_SUM_MODE) {
      NavigationService.getInstance.kitchenSMDashboardActivityFromAll();
    } else {
      NavigationService.getInstance.dashboardActivityFromAll();
    }
    return true;
  }
}