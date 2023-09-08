import 'package:floor/floor.dart';
import 'package:kwantapo/db/lib.dart';

@Entity(tableName: TableNames.ITEM_ADDITION)
class EItemAddition {

  @PrimaryKey(autoGenerate: true)
  int? id;
  int? parentId;
  int? childItemId;
  String itemAddition = "";

  EItemAddition({
    this.parentId = 0,
    this.childItemId = 0,
    this.itemAddition = "",
  });

  Map<String, dynamic> toJson() => {
    'parentId': parentId,
    'childItemId': childItemId,
    'itemAddition': itemAddition,
  };
}
