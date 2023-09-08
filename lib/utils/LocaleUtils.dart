import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class LocaleUtils {

  final String _tag = "LocaleUtils";

  static Iterable<Locale> supportedLocales = [
    const Locale('de', ''),
    const Locale('en', ''),
  ];

  static Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates = [
    const AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  Locale? localeResolutionCallback(Locale? locale, Iterable<Locale> supportedLocales) {
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale!.languageCode) {
        Logger.getInstance.d(_tag, "localeResolutionCallback()", message: "Selected locale is : ${supportedLocale.toString()}.");
        return Locale(supportedLocale.languageCode, '');
      }
    }
    Logger.getInstance.d(_tag, "localeResolutionCallback()", message: "Default Locale is de if supported locale is not found.");
    return const Locale('de', '');
  }

}
