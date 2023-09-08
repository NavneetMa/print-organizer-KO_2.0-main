import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwantapo/utils/lib.dart';

class ActivityContainer extends StatelessWidget {

  final BuildContext? context;
  final Future<bool> Function() onBackPressed;
  final VoidCallback onBackPressedVoid;
  final Widget? actions;
  final String? title;
  final Widget? child;

  const ActivityContainer({
    Key? key,
    @required this.context,
    required this.onBackPressed,
    required this.onBackPressedVoid,
    this.actions,
    @required this.title,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPressed(),
      child: Scaffold(
        backgroundColor: AppTheme.background,
        resizeToAvoidBottomInset: true,
        appBar: CupertinoNavigationBar(
          backgroundColor: AppTheme.colorPrimary,
          leading: InkWell(
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppTheme.nearlyWhite,
            ),
            onTap: () => onBackPressedVoid(),
          ),
          middle: Text(
            title!,
            style: TextStyles().titleStyleLarge(),
          ),
          trailing: actions,
        ),
        body: child,
      ),
    );
  }

}
