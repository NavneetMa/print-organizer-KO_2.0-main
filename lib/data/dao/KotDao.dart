import 'package:floor/floor.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/db/lib.dart';

@dao
abstract class KotDao {
  @Query('SELECT * FROM ${TableNames.KOT} WHERE kotDismissed = 0')
  Future<List<EKot?>> getAll();

  @Query('SELECT * FROM ${TableNames.KOT} WHERE kotDismissed = 0 and hideKot = 0')
  Future<List<EKot?>> getUnHiddenKot();

  @Query('SELECT * FROM ${TableNames.KOT} WHERE id = :id')
  Future<EKot?> getSingle(int id);

  @Query('SELECT * FROM ${TableNames.KOT} WHERE hideKot = 0 ORDER BY id DESC LIMIT 1')
  Future<List<EKot?>> getLatest();

  @Query('SELECT * FROM ${TableNames.KOT} WHERE WHERE kotDismissed = 0 and hideKot = 1 ORDER BY id DESC LIMIT 1')
  Future<List<EKot?>> getHiddenKot();

  @Query('SELECT * FROM ${TableNames.KOT} WHERE hashMD5 = :hashMD5')
  Future<EKot?> getKotByHashMD5(String hashMD5);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insert(EKot eKot);

  @Query('UPDATE ${TableNames.KOT} SET kotDismissed = :kotDismissed WHERE id = :id')
  Future<void> updateIsDismissed(int id, int kotDismissed);

  @Query('UPDATE ${TableNames.KOT} SET snoozeIt = :snoozeIt, snoozeTime = :snoozeTime WHERE id = :id')
  Future<void> updateSnoozeTime(int id, int snoozeIt, String snoozeTime);

  @Query('UPDATE ${TableNames.KOT} SET  snoozeDateTime = :snoozeDateTime WHERE id = :id')
  Future<void> updateDateTime(int id, String snoozeDateTime);

  @Query('UPDATE ${TableNames.KOT} SET  snoozeDateTime = :snoozeDateTime WHERE hashMD5 = :hashMD5')
  Future<void> updateSnoozeDateTimeByHash(String hashMD5, String snoozeDateTime);

  @Query('UPDATE ${TableNames.KOT} SET  receivedTime = :receivedTime WHERE id = :id')
  Future<void> updateReceivedTime(int id, String receivedTime);

  @Query('UPDATE ${TableNames.KOT} SET  hideKot = :hideKot WHERE id = :id')
  Future<void> updateHideKot(int id, bool hideKot);

  @Query('UPDATE ${TableNames.KOT} SET  hideKot = :hideKot WHERE hashMD5 = :hashMD5')
  Future<void> updateHideKotByHash(String hashMD5, bool hideKot);

  @Query('UPDATE ${TableNames.KOT} SET  singleCategory = :singleCategory WHERE id = :id')
  Future<void> updateSingleCategory(int id, int singleCategory);

  @Query('UPDATE ${TableNames.KOT} SET kotDismissed = :kotDismissed WHERE hashMD5 = :hashMD5')
  Future<void> updateIsDismissedByHash(String hashMD5, int kotDismissed);

  @Query('DELETE FROM ${TableNames.KOT}')
  Future<void> delete();

  @Query('DELETE FROM ${TableNames.KOT} WHERE id = :id')
  Future<void> deleteById(int id);

  @Query('DELETE FROM ${TableNames.KOT} WHERE hashMD5 = :hashMD5')
  Future<void> deleteByHash(String hashMD5);

  @Query('SELECT id FROM KOT WHERE hashMD5 = :hashMD5')
  Future<int?> getIdByHashMD5(String hashMD5);

  @Query('SELECT * FROM ${TableNames.KOT} WHERE kotDismissed = 0 and hideKot = 1')
  Future<List<EKot?>> getHideKotList();

  @Query('UPDATE ${TableNames.KOT} SET tableNameMatch = :tableNameMatch WHERE id = :id')
  Future<void> updateTableNameMatch(int id, bool tableNameMatch);

  @Query('UPDATE ${TableNames.KOT} SET eyeColor = :eyeColor WHERE id = :id')
  Future<void> updateEyeColor(int id, bool eyeColor);

  @Query('SELECT eyeColor FROM ${TableNames.KOT} WHERE id = :id')
  Future<bool?> getEyeColor(int id);

}
