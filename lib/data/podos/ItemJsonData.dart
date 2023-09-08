class ItemData {
  List<ItemList>? itemList;

  ItemData({this.itemList});

  ItemData.fromJson(Map<String, dynamic> json) {
    json['itemList'] as List<ItemList>;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemList'] = data;
    return data;
  }
}

class ItemList {
  List<ChildItemList>? childItemList;
  bool? isCategory;
  String? item;
  List<String>? itemAddition;
  String? quantity;
  String? unit;

  ItemList(
      {this.childItemList,
        this.isCategory,
        this.item,
        this.itemAddition,
        this.quantity,
        this.unit,});

  ItemList.fromJson(Map<String, dynamic> json) {
    childItemList = json['childItemList'] as List<ChildItemList>;
    isCategory = json['isCategory'] as bool;
    item = json['item'].toString();
    itemAddition = json['itemAddition'] as List<String>;
    quantity = json['quantity'].toString();
    unit = json['unit'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['childItemList'] = childItemList;
    data['isCategory'] = isCategory;
    data['item'] = item;
    data['itemAddition'] = itemAddition;
    data['quantity'] = quantity;
    data['unit'] = unit;
    return data;
  }
}
class ChildItemList {
  bool? isCategory;
  String? item;
  List<String>? itemAddition;
  String? quantity;
  String? unit;

  ChildItemList(
      {this.isCategory,
        this.item,
        this.itemAddition,
        this.quantity,
        this.unit,});

  ChildItemList.fromJson(Map<String, dynamic> json) {
    isCategory = json['isCategory'] as bool;
    item = json['item'].toString();
    itemAddition = json['itemAddition'] as List<String>;
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
