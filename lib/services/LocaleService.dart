import 'package:flutter/services.dart';

class LocaleService {

  static LocaleService? _instance;
  factory LocaleService() => getInstance;
  LocaleService._();

  static LocaleService get getInstance {
    if (_instance == null) {
      _instance =  LocaleService._();
    }
    return _instance!;
  }

  Future<String> getLocaleAsset(String languageCode) async => rootBundle.loadString('assets/lang/$languageCode.json');

}
