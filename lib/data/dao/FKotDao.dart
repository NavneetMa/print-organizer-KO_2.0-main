import 'package:floor/floor.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/db/lib.dart';

@dao
abstract class FKotDao {

  @Query('SELECT * FROM ${TableNames.FKOT} WHERE kotDismissed = 0')
  Future<List<EFKot?>> getAll();

  @Query('SELECT DISTINCT userName FROM ${TableNames.FKOT} WHERE kotDismissed = 0')
  Future<List<EFKot?>> getUserNames();

  @Query('SELECT DISTINCT userName FROM ${TableNames.FKOT} WHERE kotDismissed = 0 AND kotId = :kotId')
  Future<EFKot?> getUserNameById(int kotId);

  @Query('SELECT DISTINCT tableName FROM ${TableNames.FKOT} WHERE kotDismissed = 0')
  Future<List<EFKot?>> getTableNames();

  @Query('SELECT DISTINCT tableName FROM ${TableNames.FKOT} WHERE kotDismissed = 0 AND kotId = :kotId')
  Future<EFKot?> getTableNameById(int kotId);

  @Query('SELECT * FROM ${TableNames.FKOT} WHERE kotId = :kotId')
  Future<EFKot?> getSingle(int kotId);

  @Query('SELECT * FROM ${TableNames.FKOT} ORDER BY id DESC LIMIT 1')
  Future<List<EFKot?>> getLatest();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(EFKot fKot);

  @Query('UPDATE ${TableNames.FKOT} SET kotDismissed = :kotDismissed WHERE kotId = :kotId')
  Future<void> updateIsDismissed(int kotId, int kotDismissed);

  @Query('DELETE FROM ${TableNames.FKOT}')
  Future<void> delete();

  @Query('DELETE FROM ${TableNames.FKOT} WHERE kotId = :kotId')
  Future<void> deleteById(int kotId);
}
