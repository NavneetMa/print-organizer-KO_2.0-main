import 'package:floor/floor.dart';
import 'package:kwantapo/db/lib.dart';

@Entity(tableName: TableNames.ITEM)
class EItem {

  @PrimaryKey(autoGenerate: true)
  int? id;
  int? fKotId;
  String? item = "";
  int? quantity = 0;
  String? unit = "";
  bool hasChild = false;
  bool itemCategory = false;
  String? groupName="";
  int categoryId = 0;
  bool checked = false;
  bool isPrinted = false;
  String itemHash = "";

  EItem({
    this.id,
    this.fKotId = 0,
    this.item = "",
    this.quantity = 0,
    this.unit = "",
    this.hasChild = false,
    this.itemCategory = false,
    this.groupName = "",
    this.categoryId = 0,
    this.checked = false,
    this.isPrinted = false,
    this.itemHash = "",
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fKotId': fKotId,
    'item': item,
    'quantity': quantity,
    'unit': unit,
    'hasChild': hasChild,
    'itemCategory': itemCategory,
    'groupName' : groupName,
    'categoryId': 0,
    'checked': false,
    'isPrinted': false,
    'itemHash': "",
  };
}
