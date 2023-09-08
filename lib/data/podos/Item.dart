import 'package:kwantapo/data/entities/EItemAddition.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/data/podos/lib.dart';

class Item {

  int itemId = 0;
  String? item = "";
  int? fKotId = 0;
  int? quantity = 0;
  String? unit = "";
  bool? hasChild = false;
  bool itemCategory = false;
  bool checkbox = false;
  int categoryId = -1;
  bool  isPrinted = false;
  String itemHash = "";
  String? groupName = "";
  List<EItemAddition?> eItemAddition = [];
  List<ChildItem?> childItems = [];

  Item({
    this.item = "",
    this.fKotId = 0,
    this.quantity = 0,
    this.unit,
    this.hasChild = false,
    this.eItemAddition = const [],
    this.childItems = const [],
    this.itemCategory = false,
    this.checkbox = false,
    this.categoryId = -1,
    this.itemId = 0,
    this.isPrinted=false,
    this.itemHash="",
    this.groupName = "",
  }) : super();

  Map<String, dynamic> toJson() => {
    'item': item,
    'fKotId': fKotId,
    'quantity': quantity,
    'unit': unit,
    'eItemAddition': eItemAddition,
    'childItems': childItems,
    'hasChild': hasChild,
    'itemCategory': itemCategory,
    'categoryId': categoryId,
    'itemId': itemId,
    'isPrinted':isPrinted,
    'itemHash':itemHash,
    'groupName':groupName
  };

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      item: json['item'].toString(),
      fKotId: json['fKotId'] as int,
      quantity: json['quantity'] as int,
      unit: json['unit'].toString(),
      eItemAddition: json['eItemAddition'] as List<EItemAddition>,
      childItems: json['childItems'] as List<ChildItem>,
      hasChild: json['hasChild'] as bool,
      itemCategory: json['itemCategory'] as bool,
      categoryId: json['categoryId'] as int,
      itemId: json['itemId'] as int,
      isPrinted: json['isPrinted'] as bool,
      itemHash: json['itemHash'].toString(),
      groupName: json['groupName'].toString(),
    );
  }
}
