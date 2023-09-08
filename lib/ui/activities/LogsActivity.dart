import 'package:flutter/material.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class LogsActivity extends StatelessWidget {

  final BuildContext? context;

  const LogsActivity({
    Key? key,
    this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActivityContainer(
      context: context,
      onBackPressed: onBackPressed,
      onBackPressedVoid: () => _goBackVoid(context),
      title: AppLocalization.instance.translate("logs"),
      actions: _getActions(context),
      child: FutureBuilder<String>(
        future: Logger.getInstance.readData(),
        builder: (context, snapshot) => SingleChildScrollView(
          child: Text(
            snapshot.data ?? "",
            softWrap: true,
            style: TextStyles().logsFileStyle(),
          ),
        ),
      ),
    );
  }

  Widget _getActions(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.clear_all),
        color: AppTheme.nearlyWhite,
        onPressed: () => _clearData(context),
      ),
      IconButton(
        icon: const Icon(Icons.share_rounded),
        color: AppTheme.nearlyWhite,
        onPressed: () => _shareLogs(context),
      ),
    ],
  );

  void _shareLogs(BuildContext context) => SystemService.getInstance.shareLogs(context);

  void _goBackVoid(BuildContext context) => NavigationService.getInstance.settingsOff();

  void _clearData(BuildContext context) {
    Logger.getInstance.clearData();
    NavigationService.getInstance.settingsActivity();
  }

  Future<bool> onBackPressed() async {
    NavigationService.getInstance.settingsOff();
    return true;
  }
}
