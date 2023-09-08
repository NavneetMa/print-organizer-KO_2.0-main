import 'dart:convert';
import "dart:ui";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import 'package:kwantapo/services/lib.dart';

class AppLocalization {

  static final AppLocalization _singleton = AppLocalization._internal();
  AppLocalization._internal();
  static AppLocalization get instance => _singleton;
  late Map<String, dynamic>? _localisedValues;

  Future<AppLocalization> load(Locale locale) async {
    final String jsonContent = await LocaleService.getInstance.getLocaleAsset(locale.languageCode);
    _localisedValues = json.decode(jsonContent) as Map<String, dynamic>;
    return this;
  }

  String translate(String key) {
    if(_localisedValues![key]!=null) {
      return _localisedValues![key].toString();
    }
    return key;
  }

}
