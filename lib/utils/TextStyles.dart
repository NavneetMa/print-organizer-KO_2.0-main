import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/TextSizeController.dart';
import 'package:kwantapo/utils/lib.dart';

class TextStyles {

  double _sixteen = 16.0;
  double _fifteen = 15.0;
  double _fourteen = 14.0;
  double _twelve = 12.0;

  final double _minusSix = 6;
  final _minusThree = 3;

  final TextSizeController textSizeController = Get.find<TextSizeController>();

  double getTextSize(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    if (width < 320) {
      _sixteen = 16.0 - _minusSix;
      _fifteen = 15.0 - _minusSix;
      _fourteen = 14.0 - _minusSix;
      _twelve = 12.0 - _minusSix;
    } else if (width > 320 && width < 360) {
      _sixteen = 16.0 - _minusThree;
      _fifteen = 15.0 - _minusThree;
      _fourteen = 14.0 - _minusThree;
      _twelve = 12.0 - _minusThree;
    }
    return 20;
  }

  TextStyle titleStyle() => const TextStyle(
    fontSize: 18.0,
    color: AppTheme.nearlyWhite,
    fontWeight: FontWeight.bold,
  );

  TextStyle titleStyleLarge() => const TextStyle(
    fontSize: 20.0,
    color: AppTheme.nearlyWhite,
  );

  TextStyle titleStyleLargeBlack() => const TextStyle(
    fontSize: 22.0,
    color: AppTheme.nearlyBlack,
    fontWeight: FontWeight.w600,
    fontFamily: 'Courier',
    letterSpacing: -1,
  );

  TextStyle titleStyleMedium() => const TextStyle(
    color: AppTheme.nearlyWhite,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  TextStyle titleStyleColored({Color? color, double? textSize}) => TextStyle(
    fontSize: textSize ?? 20.0,
    color: color ?? AppTheme.nearlyBlack,
  );

  TextStyle kotTextStyle({Color? color, double? textSize, double? fontWeight}) => TextStyle(
      fontSize: textSize ?? AppConstants.textSize,
      color: color ?? AppTheme.nearlyBlack,
      fontWeight: _getFontWeight(fontWeight),
      fontFamily: 'Courier',
      letterSpacing: -1,
  );

  TextStyle kotTextLarge({Color? color, double? textSize, double? fontWeight}) => TextStyle(
      fontSize: 20,
      color: AppTheme.nearlyBlack,
      fontWeight: _getFontWeight(500),
      fontFamily: 'Courier',
      letterSpacing: .5,
  );

  TextStyle kotTextLargeSummation({Color? color, double? textSize, double? fontWeight}) => TextStyle(
    fontSize: textSizeController.textSize.value,
    color: AppTheme.nearlyBlack,
    fontWeight: _getFontWeight(500),
    fontFamily: 'Courier',
    letterSpacing: .5,
  );

  TextStyle kotTextLargeCategory({Color? color, double? textSize, double? fontWeight}) => TextStyle(
    fontSize: 20,
    color: AppTheme.red,
    fontWeight: _getFontWeight(500),
    fontFamily: 'Courier',
    letterSpacing: .5,
  );



  TextStyle kotTextMedium({Color? color, double? textSize, double? fontWeight}) => TextStyle(
      fontSize: 18,
      color: AppTheme.nearlyBlack,
      fontWeight: _getFontWeight(500),
      fontFamily: 'Courier',
      letterSpacing: .5,
  );

  TextStyle kotTextMediumSummation({Color? color, double? textSize, double? fontWeight}) => TextStyle(
    fontSize: textSizeController.textSize.value * 0.9,
    color: AppTheme.nearlyBlack,
    fontWeight: _getFontWeight(500),
    fontFamily: 'Courier',
    letterSpacing: .5,
  );

  TextStyle kotTextNormal() => TextStyle(
      fontSize: 16,
      color: AppTheme.nearlyBlack,
      fontWeight: _getFontWeight(500),
      fontFamily: 'Courier',
      letterSpacing: .5,
  );

  TextStyle kotTextNormalSummation() => TextStyle(
    fontSize: textSizeController.textSize.value * 0.8,
    color: AppTheme.nearlyBlack,
    fontWeight: _getFontWeight(500),
    fontFamily: 'Courier',
    letterSpacing: .5,
  );

  TextStyle snoozeTextLarge() =>const TextStyle(
    wordSpacing: 1,
    fontSize: 30,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: AppTheme.colorPrimary,
  );

  TextStyle snoozeTextMedium() =>const TextStyle(
    wordSpacing: 1,
    letterSpacing: 1,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: AppTheme.colorPrimary,
  );

  FontWeight _getFontWeight(double? fontWeight){
    if(fontWeight==300){
      return FontWeight.w300;
    }else if(fontWeight==400){
      return FontWeight.w400;
    }else if(fontWeight==500){
      return FontWeight.w500;
    }else if(fontWeight==600){
      return FontWeight.w600;
    } else {
      return FontWeight.w300;
    }
  }

  TextStyle logsFileStyle() => TextStyle(
    fontSize: _twelve,
    color: AppTheme.nearlyBlack,
  );

  TextStyle settingsStyle() => TextStyle(
    fontSize: _sixteen,
    color: AppTheme.nearlyBlack,
  );

  TextStyle textInputStyle() => TextStyle(
    color: AppTheme.grey,
    fontSize: _fifteen,
    letterSpacing: 1,
  );

  TextStyle textInputStyleLight() => TextStyle(
    color: AppTheme.grey,
    fontSize: _fifteen,
    letterSpacing: 1,
  );

  TextStyle inputValueStyle() => TextStyle(
    fontSize: _sixteen,
    color: AppTheme.nearlyBlack,
  );

  TextStyle inputValueStyleWhite() => TextStyle(
    fontSize: _sixteen,
    color: AppTheme.nearlyWhite,
  );

  TextStyle hintStyle() => TextStyle(
    fontSize: _fourteen,
    color: AppTheme.lightText,
  );

  TextStyle dialogButtonStyle() => TextStyle(
    fontSize: _fourteen,
    color: AppTheme.colorAccent,
  );

  TextStyle groupViewNormal(bool groupView) => TextStyle(
    fontSize: 16,
    color: groupView ? AppTheme.nearlyBlack : AppTheme.green,
    fontWeight: _getFontWeight(500),
    fontFamily: 'Courier',
    letterSpacing: .5,
  );
}
