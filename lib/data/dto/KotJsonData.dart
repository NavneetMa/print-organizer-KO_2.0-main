class KotJsonData {
  List<ItemList> itemList = [];
  String? tableName;
  String? userName;
  String? kitchenMessage;

  KotJsonData(
      {this.itemList = const [],
      this.tableName,
      this.userName,
      this.kitchenMessage,}
      );

  KotJsonData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("itemList")) {
      json['itemList'].forEach((v) {
        itemList.add(ItemList.fromJson(v as Map<String, dynamic>));
      });
    }
    tableName = json['tableName'].toString();
    userName = json['userName'].toString();
    kitchenMessage = json['kitchenMessage'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemList'] = itemList.map((v) => v.toJson()).toList();
    data['tableName'] = tableName;
    data['userName'] = userName;
    data['kitchenMessage'] = kitchenMessage;
    return data;
  }
}

class ItemList {
  List<ChildItemList> childItemList = [];
  bool? isCategory;
  String? item;
  List<String> itemAddition = [];
  String? quantity;
  String? unit;
  String? groupName;
  String itemHash = "";


  ItemList({
    this.childItemList = const [],
    this.isCategory,
    this.item,
    this.itemAddition = const [],
    this.quantity,
    this.unit,
    this.groupName,
    this.itemHash = "",

  });

  ItemList.fromJson(Map<String, dynamic> json) {
    if (json['childItemList'] != null) {
      json['childItemList'].forEach((v) {
        childItemList.add(ChildItemList.fromJson(v as Map<String, dynamic>));
      });
    }
    isCategory = json['isCategory'] as bool;
    item = json['item'].toString();
    if (json['itemAddition']!=null) {
      json['itemAddition'].forEach((v) {
        itemAddition.add(v.toString());
      });
    }
    quantity = json['quantity'].toString();
    unit = json['unit'].toString();
    itemHash = json['itemHash'].toString();
    groupName = json['groupName'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['childItemList'] = childItemList.map((v) => v.toJson()).toList();
    data['isCategory'] = isCategory;
    data['item'] = item;
    data['itemAddition'] = itemAddition;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['itemHash'] = itemHash;
    data['groupName'] = groupName;
    return data;
  }
}

class ChildItemList {
  bool? isCategory;
  String? item;
  List<String> itemAddition = [];
  String? quantity;
  String? unit;

  ChildItemList(
      {this.isCategory,
      this.item,
      this.itemAddition = const [],
      this.quantity,
      this.unit,}
      );

  ChildItemList.fromJson(Map<String, dynamic> json) {
    isCategory = json['isCategory'] as bool;
    item = json['item'].toString();
    if (json['itemAddition']!=null) {
      json['itemAddition'].forEach((v) {
        itemAddition.add(v.toString());
      });
    }
    quantity = json['quantity'].toString();
    unit = json['unit'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isCategory'] = isCategory;
    data['item'] = item;
    data['itemAddition'] = itemAddition;
    data['quantity'] = quantity;
    data['unit'] = unit;
    return data;
  }
}
