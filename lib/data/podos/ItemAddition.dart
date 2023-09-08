
import 'package:kwantapo/utils/lib.dart';

class ItemAddition {

  String? item = "";
  int? parentId = 0;
  double? textSize = AppConstants.textSize;
  double? fontWeight = AppConstants.fontWeight;

  ItemAddition({this.item = "",this.textSize = AppConstants.textSize, this.fontWeight = AppConstants.fontWeight, this.parentId}) : super();

  Map<String, dynamic> toJson() => {
    'item': item,
    'textSize': textSize,
    'fontWeight': fontWeight,
    'parentId': parentId,
  };

  factory ItemAddition.fromJson(Map<String, dynamic> json) {
    return ItemAddition(
      item: json['item'].toString(),
      textSize: json['textSize'] as double,
      fontWeight: json['fontWeight'] as double,
      parentId: json['parentId'] as int,
    );
  }
}
