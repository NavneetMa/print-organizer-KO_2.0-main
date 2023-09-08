import 'package:flutter/cupertino.dart';
import 'package:kwantapo/utils/AppTheme.dart';

class ColorMap {

  String name = "red";
  Color color = AppTheme.red;
  ColorMap({required this.name, required this.color}) : super();

  Map<String, dynamic> toJson() => {
    'name': name,
    'color': color,
  };

  factory ColorMap.fromJson(Map<String, dynamic> json) {
    return ColorMap(
        name: json['name'].toString(),
        color: json['color'] as Color,
    );
  }
}
