import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/data/podos/ChildItem.dart';
import 'package:kwantapo/data/podos/Item.dart';

class ItemData {
  final String userName;
  final String tableName;
  final Item item;
  final Item categoryItem;
  final List<ChildItem?> childItems;
  final List<EItemAddition?> itemAdditions;

  ItemData(this.userName, this.tableName, this.item, this.categoryItem, this.childItems, this.itemAdditions);
}
