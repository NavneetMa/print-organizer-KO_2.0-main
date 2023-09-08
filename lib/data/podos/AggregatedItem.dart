import 'dart:collection';

import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/data/podos/lib.dart';

class AggregatedItem {
  int? parentId = 0;
  int? count = 0;
  String? item = "";
  String? addOrMinus = "";
  String? unit = "";
  int? id = 0;
  List<EItemAddition?> eItemAddition = [];
  List<ChildItem?> childItems = [];
  bool? hasChild = false;
  bool checkbox;
  bool hideKot = false;
  String groupName = "";
  HashMap<int,List<int>>? idList;

  AggregatedItem(
      {this.parentId = 0,
      this.count = 1,
      this.item = "",
      this.addOrMinus = "",
      this.unit = "",
      this.id = 0,
      this.hasChild = false,
      this.eItemAddition = const [],
      this.childItems = const [],
      this.checkbox = false,
      this.hideKot = false,
      this.groupName = "",
      // this.idList,
      this.idList,
      })
      : super();

  Map<String, dynamic> toJson() => {
    'parentId': parentId,
    'count': count,
     'item': item,
     'addOrMinus': addOrMinus,
     'unit': unit,
     'id': id,
    'eItemAddition': eItemAddition,
    'childItems': childItems,
    'hasChild': hasChild,
    'checkbox':checkbox,
    'hideKot':hideKot,
    'groupName':groupName,
    // 'idList':idList,
    'idList':idList
      };

  factory AggregatedItem.fromJson(Map<String, dynamic> json) {
    return AggregatedItem(
      parentId: json['parentId'] as int,
      count: json['count'] as int,
      item: json['item'].toString(),
      addOrMinus: json['addOrMinus'].toString(),
      unit: json['unit'].toString(),
      id: json['id'] as int,
      eItemAddition: json['eItemAddition'] as List<EItemAddition>,
      childItems: json['childItems'] as List<ChildItem>,
      hasChild: json['hasChild'] as bool,
      checkbox: json['checkbox'] as bool,
      hideKot: json['hideKot'] as bool,
      groupName: json['groupName'].toString(),
      idList: json['idList'] as HashMap<int, List<int>>,
    );
  }
}
