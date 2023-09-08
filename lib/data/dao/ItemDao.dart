import 'package:floor/floor.dart';
import 'package:kwantapo/data/entities/EItem.dart';
import 'package:kwantapo/db/TableNames.dart';

@dao
abstract class ItemDao {

  @Query('SELECT * FROM ${TableNames.ITEM} WHERE isPrinted = 0')
  Future<List<EItem?>> getAll();

  @Query('SELECT * FROM ${TableNames.ITEM} WHERE groupName IS NOT NULL AND groupName != "" ORDER BY groupName')
  Future<List<EItem?>> getGroupByAll();

  @Query('SELECT DISTINCT groupName FROM ${TableNames.ITEM} WHERE groupName IS NOT NULL AND groupName != "" AND isPrinted = 0')
  Future<List<String>> getUniqueGroupNames();

  @Query('SELECT * FROM ${TableNames.ITEM} WHERE fKotId = :fKotId and isPrinted = 0')
  Future<List<EItem?>> getItems(int fKotId);

  @Query('SELECT * FROM ${TableNames.ITEM}  WHERE isPrinted= 0 ORDER BY id DESC LIMIT 1')
  Future<List<EItem?>> getLatest();

  @Query('SELECT count(*) as itemCount FROM ${TableNames.ITEM} WHERE fKotId = :fKotId and checked = false')
  Future<int?> getUnCheckedItem(int fKotId);

  @Query('SELECT itemHash FROM ${TableNames.ITEM} WHERE isPrinted = 0 and id = :id')
  Future<String?> getItemHash(int id);

  @Query('SELECT id FROM ${TableNames.ITEM} WHERE isPrinted = 0 and itemHash = :itemHash')
  Future<int?> getItemIdByHash(String itemHash);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insert(EItem item);

  @Query('DELETE FROM ${TableNames.ITEM} WHERE fKotId = :fKotId')
  Future<void> deleteItem(int fKotId);

  @Query('UPDATE ${TableNames.ITEM} set hasChild=:hasChild WHERE id = :id')
  Future<void> updateItemHasChild(int id, bool hasChild);

  @Query('UPDATE ${TableNames.ITEM} set checked=:checked WHERE id = :id')
  Future<void> updateItemChecked(int id, bool checked);

  @Query('UPDATE ${TableNames.ITEM} SET isPrinted = 1 WHERE id = :id')
  Future<void> updateIsPrinted(int id);

  @Query('UPDATE ${TableNames.ITEM} SET isPrinted = 1 WHERE itemHash = :itemHash')
  Future<void> updateIsPrintedByItemHash(String itemHash);

  @Query('UPDATE ${TableNames.ITEM} set checked=:checked WHERE categoryId = :categoryId')
  Future<void> updateItemCheckedByCategory(int categoryId, bool checked);

  @Query('UPDATE ${TableNames.ITEM} set isPrinted=:isPrinted WHERE categoryId = :categoryId')
  Future<void> updateItemIsPrintedByCategoryId(int categoryId, bool isPrinted);

  @Query('UPDATE ${TableNames.ITEM} set isPrinted=:isPrinted WHERE id = :id')
  Future<void> updateItemIsPrinted(int id, bool isPrinted);

  @Query('UPDATE ${TableNames.ITEM} set isPrinted=:isPrinted WHERE itemHash = :itemHash')
  Future<void> updateItemIsPrintedByItemHash(String itemHash, bool isPrinted);

  @Query('DELETE FROM ${TableNames.ITEM}')
  Future<void> delete();

  @Query('DELETE FROM ${TableNames.ITEM} WHERE fKotId = :fKotId')
  Future<void> deleteById(int fKotId);
}
