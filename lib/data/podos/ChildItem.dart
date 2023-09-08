import 'package:kwantapo/data/entities/lib.dart';

class ChildItem {

  int? id = 0;
  String? item = "";
  int? quantity = 0;
  String? unit = "";
  int? parentId = 0;
  bool checkbox = false;

  List<EItemAddition?> eItemAddition = [];

  ChildItem({
    this.id = 0,
    this.item = "",
    this.eItemAddition = const [],
    this.quantity = 0,
    this.unit,
    this.checkbox = false,
    this.parentId = 0,
  }) : super();

  Map<String, dynamic> toJson() => {
    'item': item,
    'eItemAddition': eItemAddition,
    'quantity': quantity,
    'unit': unit,
    'id': id,
    'parentId': parentId,
  };

  factory ChildItem.fromJson(Map<String, dynamic> json) {
    return ChildItem(
      item: json['item'].toString(),
      eItemAddition: json['eItemAddition'] as List<EItemAddition>,
      quantity: json['quantity'] as int,
      unit: json['unit'].toString(),
      id: json['id'] as int,
      parentId: json['parentId'] as int,
    );
  }
}