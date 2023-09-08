import 'package:floor/floor.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/db/lib.dart';

@dao
abstract class KotHeaderDao {

  @Query('SELECT * FROM ${TableNames.KOTHEADER}')
  Future<List<EKotHeader?>> getAllHeader();

  @Query('SELECT * FROM ${TableNames.KOTHEADER} WHERE fKotId = :fKotId')
  Future<List<EKotHeader?>> getHeader(int fKotId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insert(EKotHeader eKotHeader);

  @Query('DELETE FROM ${TableNames.KOTHEADER} WHERE fKotId = :fKotId')
  Future<void> deleteHeader(int fKotId);

  @Query('DELETE FROM ${TableNames.KOTHEADER}')
  Future<void> delete();

  @Query('DELETE FROM ${TableNames.KOTHEADER} WHERE fKotId = :fKotId')
  Future<void> deleteById(int fKotId);
}
