import 'package:floor/floor.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/db/lib.dart';

@dao
abstract class ItemAdditionDao {

  @Query('SELECT * FROM ${TableNames.ITEM_ADDITION} WHERE parentId = :parentId')
  Future<List<EItemAddition?>> getItemAddition(int parentId);

  @Query('SELECT * FROM ${TableNames.ITEM_ADDITION} WHERE childItemId = :childItemId')
  Future<List<EItemAddition?>> getItemAdditionByChildItemId(int childItemId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insert(EItemAddition eItemAddition);

  @Query('DELETE FROM ${TableNames.ITEM_ADDITION} WHERE parentId = :parentId')
  Future<void> deleteItemAddition(int parentId);

  @Query('DELETE FROM ${TableNames.ITEM_ADDITION}')
  Future<void> delete();

  @Query('DELETE FROM ${TableNames.ITEM_ADDITION} WHERE parentId = :parentId')
  Future<void> deleteById(int parentId);
}
