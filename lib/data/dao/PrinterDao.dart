import 'package:floor/floor.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/db/lib.dart';

@dao
abstract class PrinterDao {

  @Query('SELECT * FROM ${TableNames.PRINTER}')
  Future<List<EPrinter>> getAll();

  @Query('SELECT * FROM ${TableNames.PRINTER} WHERE id = :id')
  Future<EPrinter?> getSingle(int id);

  @Query('SELECT * FROM ${TableNames.PRINTER} WHERE isSend =:isSend')
  Future<List<EPrinter>> getSelectedPrinter(bool isSend);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insert(EPrinter fKot);

  @Query('UPDATE ${TableNames.PRINTER} SET isSend =:isSend WHERE id = :id')
  Future<void> updateIsSelected(int id, bool isSend);

  @Query('UPDATE ${TableNames.PRINTER} SET isRemove =:isRemove WHERE id = :id')
  Future<void> updateIsRemoved(int id, bool isRemove);

  @Query('DELETE FROM ${TableNames.PRINTER} WHERE id =:id')
  Future<void> delete(int id);

}