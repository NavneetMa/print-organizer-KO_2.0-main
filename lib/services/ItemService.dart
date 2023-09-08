import 'package:kwantapo/db/DatabaseHelper.dart';
import 'package:kwantapo/db/DatabaseManager.dart';

class ItemService{
  static ItemService? _instance;
  factory ItemService() => getInstance;
  ItemService._();

  static ItemService get getInstance {
    if (_instance == null) {
      _instance =  ItemService._();
    }
    return _instance!;
  }

  void selectItem() {

  }

  Future<void> updateItemChecked(int itemId, bool checked) async {
    final DatabaseManager db = await DatabaseHelper.getInstance;
    db.itemDao.updateItemChecked(itemId, checked);
  }

  Future<void> updateIsPrinted(int itemId) async{
    final DatabaseManager db = await DatabaseHelper.getInstance;
    db.itemDao.updateIsPrinted(itemId);
  }

  Future<void> updateCategoryItems(int categoryId, bool checked) async {
    final DatabaseManager db = await DatabaseHelper.getInstance;
    await db.itemDao.updateItemCheckedByCategory(categoryId, checked);
  }

  Future<int> isAllItemsChecked(int kotId) async{
    final DatabaseManager db = await DatabaseHelper.getInstance;
    return await db.itemDao.getUnCheckedItem(kotId) ?? 0;
  }

  Future<String> getItemHash(int itemId) async{
    final DatabaseManager db = await DatabaseHelper.getInstance;
    return await db.itemDao.getItemHash(itemId) ?? "";
  }

  Future<void> updateItemIsPrintedByCategoryId(int categoryId, bool isPrinted) async {
    final DatabaseManager db = await DatabaseHelper.getInstance;
    await db.itemDao.updateItemIsPrintedByCategoryId(categoryId, isPrinted);
  }

  Future<void> updateItemIsPrinted(int itemId, bool isPrinted) async{
    final DatabaseManager db = await DatabaseHelper.getInstance;
    return db.itemDao.updateItemIsPrinted(itemId, isPrinted);
  }
}