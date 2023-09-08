import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenUtils {

  int? width;
  int? height;
  bool? allowFontScaling;
  static MediaQueryData? _mediaQueryData;
  late double? _screenWidth;
  late double? _screenHeight;
  late double? _pixelRatio;
  late double? _statusBarHeight;
  late double? _topBarHeight;
  late double? _bottomBarHeight;
  late double? _textScaleFactor;

  static ScreenUtils? _instance;
  factory ScreenUtils() => getInstance;
  ScreenUtils._();

  static ScreenUtils get getInstance {
    _instance ??= ScreenUtils._();
    return _instance!;
  }

  void init(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    _mediaQueryData = mediaQuery;
    _pixelRatio = mediaQuery.devicePixelRatio;
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = _mediaQueryData?.padding.bottom;
    _topBarHeight = _mediaQueryData?.padding.top;
    _textScaleFactor = mediaQuery.textScaleFactor;
  }

   MediaQueryData get mediaQueryData => _mediaQueryData!;

   double get textScaleFactory => _textScaleFactor!;

   double get pixelRatio => _pixelRatio!;

   double get screenWidthDp => _screenWidth!;

   double get screenHeightDp => _screenHeight!;

   double get screenWidth => _screenWidth! * _pixelRatio!;

   double get screenHeight => _screenHeight! * _pixelRatio!;

   double get statusBarHeight => _statusBarHeight! * _pixelRatio!;

   double get bottomBarHeight => _bottomBarHeight! * _pixelRatio!;

   double get topBarHeight => _topBarHeight! * _pixelRatio!;

  double get scaleWidth => _screenWidth! / getInstance.width!;

  double get scaleHeight => _screenHeight! / getInstance.height!;

}
