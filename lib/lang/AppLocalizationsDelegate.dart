import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwantapo/lang/lib.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalization> {

  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', ''].contains(locale.languageCode) || ['de', ''].contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) => AppLocalization.instance.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;

}
