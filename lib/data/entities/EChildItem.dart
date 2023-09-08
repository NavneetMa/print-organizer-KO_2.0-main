import 'package:floor/floor.dart';
import 'package:kwantapo/db/lib.dart';

@Entity(tableName: TableNames.CHILD_ITEM)
class EChildItem {

  @PrimaryKey(autoGenerate: true)
  int? id;
  int? parentId;
  String? item = "";
  int? quantity = 0;
  String? unit = "";
  bool itemCategory = false;

  EChildItem({
    this.id,
    this.parentId,
    this.item = "",
    this.quantity = 0,
    this.unit = "",
    this.itemCategory = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'parentId': parentId,
    'item': item,
    'quantity': quantity,
    'unit': unit,
    'itemCategory': itemCategory,
  };
}
