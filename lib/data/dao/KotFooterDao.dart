import 'package:floor/floor.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/db/lib.dart';

@dao
abstract class KotFooterDao {

  @Query('SELECT * FROM ${TableNames.KOTFOOTER} WHERE fKotId = :fKotId')
  Future<List<EKotFooter?>> getFooter(int fKotId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insert(EKotFooter eKotFooter);

  @Query('DELETE FROM ${TableNames.KOTFOOTER} WHERE fKotId = :fKotId')
  Future<void> deleteFooter(int fKotId);

  @Query('DELETE FROM ${TableNames.KOTFOOTER}')
  Future<void> delete();

  @Query('DELETE FROM ${TableNames.KOTFOOTER} WHERE fKotId = :fKotId')
  Future<void> deleteById(int fKotId);
}
