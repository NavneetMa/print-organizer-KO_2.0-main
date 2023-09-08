import 'package:floor/floor.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/db/lib.dart';

@dao
abstract class ChildItemDao {

  @Query('SELECT * FROM ${TableNames.CHILD_ITEM}')
  Future<List<EChildItem?>> getAll();

  @Query('SELECT * FROM ${TableNames.CHILD_ITEM} WHERE parentId = :parentId')
  Future<List<EChildItem?>> getChildItems(int parentId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insert(EChildItem eChildItem);

  @Query('DELETE FROM ${TableNames.CHILD_ITEM} WHERE parentId = :parentId')
  Future<void> deleteItem(int parentId);

  @Query('DELETE FROM ${TableNames.CHILD_ITEM}')
  Future<void> delete();

  @Query('DELETE FROM ${TableNames.CHILD_ITEM} WHERE parentId = :parentId')
  Future<void> deleteById(int parentId);
}
