import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/utils/AppTheme.dart';

class Assets {

  static const String shareIcon = "assets/drawable/share_icon.png";
  static const String appLogo = "assets/drawable/logo.png";
  static const String summation = "assets/drawable/summation.png";

  static final List<ColorMap> colorMapList = [
    ColorMap(name: "red", color: AppTheme.red),
     ColorMap(name: "green", color: AppTheme.green),
     ColorMap(name: "blue", color: AppTheme.blue),
     ColorMap(name: "yellow", color: AppTheme.yellow),
     ColorMap(name: "purple", color: AppTheme.purple),
     ColorMap(name: "indigo", color: AppTheme.indigo),
     ColorMap(name: "pink", color: AppTheme.pink),
  ];

  ColorMap getColor(String colorName){
    return colorMapList.singleWhere((element) => element.name==colorName);
  }

}
