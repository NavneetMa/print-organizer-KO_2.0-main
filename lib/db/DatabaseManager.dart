import 'dart:async';
import 'package:floor/floor.dart';
import 'package:kwantapo/data/dao/lib.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/db/DBConstants.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'DatabaseManager.g.dart';

@Database(version: DBConstants.dbVersion, entities: [
  EKot,
  EFKot,
  EItem,
  EMT,
  EPrinter,
  EKotFooter,
  EKotHeader,
  EChildItem,
  EItemAddition,
],)

abstract class DatabaseManager extends FloorDatabase {

  KotDao get kotDao;
  FKotDao get fkotDao;
  ItemDao get itemDao;
  MTDao get mtDao;
  PrinterDao get printerDao;
  KotFooterDao get eKotFooterDao;
  KotHeaderDao get eKotHeaderDao;
  ItemAdditionDao get itemAdditionDao;
  ChildItemDao get childItemDao;

  @override
  StreamController<String> get changeListener => super.changeListener;
}
