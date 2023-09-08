import 'package:floor/floor.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/db/lib.dart';

@dao
abstract class MTDao {

  @Query('SELECT * FROM ${TableNames.MT}')
  Future<List<EMT?>> getAll();

  @Query('SELECT * FROM ${TableNames.MT} WHERE kotId = :kotId')
  Future<EMT?> getById(int kotId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(EMT emt);

  @Query('DELETE FROM ${TableNames.MT} WHERE id = :id')
  Future<void> delete(int id);

  @Query('UPDATE ${TableNames.MT} SET finishedTime = :finishedTime, kotLiveDuration = :kotLiveDuration WHERE id = :id')
  Future<void> updateFinishedTime(int id, String finishedTime, String kotLiveDuration);
}
