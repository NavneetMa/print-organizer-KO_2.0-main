import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/main.dart';
import 'package:kwantapo/navigation/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class App extends StatelessWidget {

  final ThemeData _theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      scrollBehavior: ScrollPhysicsBehaviour(),
      initialRoute: '/splashActivity',
      getPages: RouteGenerator().routes,
      theme: _theme.copyWith(
        colorScheme: _theme.colorScheme.copyWith(
          primary: AppTheme.colorPrimary,
          primaryVariant: AppTheme.colorPrimaryDark,
          secondary: AppTheme.colorAccent,
        ),
      ),
      transitionDuration: const Duration(milliseconds: 500),
      defaultTransition: Transition.cupertino,
      supportedLocales: LocaleUtils.supportedLocales,
      localizationsDelegates: LocaleUtils.localizationsDelegates,
      localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) => LocaleUtils().localeResolutionCallback(locale, supportedLocales),
    );
  }
}
