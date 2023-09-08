import 'package:floor/floor.dart';
import 'package:kwantapo/db/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class DatabaseHelper {

  static DatabaseManager? _manager;

  DatabaseHelper._();

  static Future<DatabaseManager> get getInstance async {
    _manager ??= await $FloorDatabaseManager
          .databaseBuilder(DBConstants.dbName)
          .addCallback(_callback)
          .addMigrations([migrate1To2, migrate2To3, migrate3To4, migrate4To5, migrate5To6,migrate6To7,migrate7To8,migrate8To9])
          .build();
    return _manager!;
  }

  //Upgrade database call
  static final _callback = Callback(
    onCreate: (database, version) {
      Logger.getInstance.d("DatabaseHelper", "onCreate()");
      database.execute(
          'CREATE TABLE IF NOT EXISTS `Kot` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `kot` TEXT, `kotDismissed` INTEGER, `receivedTime` TEXT NOT NULL, `fKotWithSeparator` TEXT NOT NULL, `hashMD5` TEXT NOT NULL, `isUndoKot` INTEGER NOT NULL, `snoozeDateTime` TEXT NOT NULL, `hideKot` INTEGER NOT NULL, `singleCategory` INTEGER NOT NULL, `tableNameMatch` INTEGER NOT NULL, `inSum` INTEGER NOT NULL)');
      database.execute(
          'CREATE TABLE IF NOT EXISTS `FKot` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `kotId` INTEGER, `tableName` TEXT, `userName` TEXT, `total` REAL, `kotDismissed` INTEGER, `receivedTime` TEXT, `kitchenMessage` TEXT)');
      database.execute(
          'CREATE TABLE IF NOT EXISTS `Item` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `fKotId` INTEGER, `item` TEXT, `quantity` INTEGER, `unit` TEXT, `hasChild` INTEGER NOT NULL, `itemCategory` INTEGER NOT NULL, `groupName` TEXT, `categoryId` INTEGER NOT NULL, `checked` INTEGER NOT NULL, `isPrinted` INTEGER NOT NULL, `itemHash` TEXT NOT NULL)');
      database.execute(
          'CREATE TABLE IF NOT EXISTS `MT` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `kotId` INTEGER NOT NULL, `receivedTime` TEXT NOT NULL, `currentTime` TEXT, `finishedTime` TEXT, `kotLiveDuration` TEXT, `tableName` TEXT, `userName` TEXT, `numOfItems` INTEGER NOT NULL, `poIp` TEXT, `mtIp` TEXT, `category` TEXT)');
      database.execute(
          'CREATE TABLE IF NOT EXISTS `Printer` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `name` TEXT NOT NULL, `ipAddress` TEXT NOT NULL, `port` TEXT NOT NULL, `color` TEXT NOT NULL, `isSend` INTEGER NOT NULL, `isRemove` INTEGER NOT NULL)');
      database.execute(
          'CREATE TABLE IF NOT EXISTS `KotFooter` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `fKotId` INTEGER, `kotFooterText` TEXT NOT NULL)');
      database.execute(
          'CREATE TABLE IF NOT EXISTS `KotHeader` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `fKotId` INTEGER, `kotHeaderText` TEXT NOT NULL)');
      database.execute(
          'CREATE TABLE IF NOT EXISTS `ChildItem` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `parentId` INTEGER, `item` TEXT, `quantity` INTEGER, `unit` TEXT, `itemCategory` INTEGER NOT NULL)');
      database.execute(
          'CREATE TABLE IF NOT EXISTS `ItemAddition` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `parentId` INTEGER, `childItemId` INTEGER, `itemAddition` TEXT NOT NULL)');

    },
    onOpen: (database) { 
      Logger.getInstance.d("DatabaseHelper", "onOpen()"); 
    },
    onUpgrade: (database, startVersion, endVersion) async {
      Logger.getInstance.d("DatabaseHelper", "onUpgrade()", message: "startVersion: $startVersion endVersion: $endVersion");
      await MigrationAdapter.runMigrations(database, 1, 2, [migrate1To2]);
      await MigrationAdapter.runMigrations(database, 2, 3, [migrate2To3]);
      await MigrationAdapter.runMigrations(database, 3, 4, [migrate3To4]);
      await MigrationAdapter.runMigrations(database, 4, 5, [migrate4To5]);
      await MigrationAdapter.runMigrations(database, 5, 6, [migrate5To6]);
      await MigrationAdapter.runMigrations(database, 6, 7, [migrate6To7]);
      await MigrationAdapter.runMigrations(database, 7, 8, [migrate7To8]);
      await MigrationAdapter.runMigrations(database, 8, 9, [migrate8To9]);
    },
  );

  static final migrate1To2 = Migration(1, 2, (database) async {
    Logger.getInstance.d("DatabaseHelper", "migrate1To2()", message: "Migrating database version from 1 to 2.");
    await database.transaction((txn) async {
      txn.rawQuery('SELECT categoryId from `${TableNames.ITEM}`').catchError((error) {
        txn.execute('ALTER TABLE ${TableNames.ITEM} ADD COLUMN categoryId INTEGER DEFAULT 0').then((_) {
          Logger.getInstance.d("DatabaseHelper", "migrate1To2()", message: "Added column categoryId to table ${TableNames.ITEM}.");
        });
      });
    });
  });

  static final migrate2To3 = Migration(2, 3, (database) async {
    Logger.getInstance.d("DatabaseHelper", "migrate2To3()", message: "Migrating database version from 2 to 3.");
    await database.transaction((txn) async {
      txn.rawQuery('SELECT snoozeDateTime from `${TableNames.KOT}`').catchError((error) {
        txn.execute('ALTER TABLE `${TableNames.KOT}` ADD COLUMN snoozeDateTime TEXT').then((_) {
          Logger.getInstance.d("DatabaseHelper", "migrate2To3()", message: "Added column snoozeDateTime to table ${TableNames.KOT}.");
        });
      });
    });
    await database.transaction((txn) async {
      txn.rawQuery('SELECT isUndoKot from `${TableNames.KOT}`').catchError((error) {
        txn.execute('ALTER TABLE `${TableNames.KOT}` ADD COLUMN isUndoKot INTEGER').then((_) {
          Logger.getInstance.d("DatabaseHelper", "migrate2To3()", message: "Added column isUndoKot to table ${TableNames.KOT}.");
        });
      });
    });
    await database.transaction((txn) async {
      txn.rawQuery('SELECT hideKot from `${TableNames.KOT}`').catchError((error) {
        txn.execute('ALTER TABLE `${TableNames.KOT}` ADD COLUMN hideKot INTEGER').then((_) {
          Logger.getInstance.d("DatabaseHelper", "migrate2To3()", message: "Added column hideKot to table ${TableNames.KOT}.");
        });
      });
    });
  });

  static final migrate3To4 = Migration(3, 4, (database) async {
    Logger.getInstance.d("DatabaseHelper", "migrate3To4()", message: "Migrating database version from 3 to 4.");
    await database.transaction((txn) async {
      txn.rawQuery('SELECT childItemId from `${TableNames.ITEM_ADDITION}`').catchError((error) {
        txn.execute('ALTER TABLE ${TableNames.ITEM_ADDITION} ADD COLUMN childItemId INTEGER DEFAULT 0').then((_) {
          Logger.getInstance.d("DatabaseHelper", "migrate3To4()", message: "Added column childItemId to table ${TableNames.ITEM_ADDITION}.");
        });
      });
    });
  });

  static final migrate4To5 = Migration(4, 5, (database) async {
    Logger.getInstance.d("DatabaseHelper", "migrate4To5()", message: "Migrating database version from 4 to 5.");
    await database.transaction((txn) async {
      txn.rawQuery('SELECT singleCategory from `${TableNames.KOT}`').catchError((error) {
        txn.execute('ALTER TABLE ${TableNames.KOT} ADD COLUMN singleCategory INTEGER DEFAULT 1').then((_) {
          Logger.getInstance.d("DatabaseHelper", "migrate4To5()", message: "Added column singleCategory to table ${TableNames.KOT}.");
        });
      });
    });
  });

  static final migrate5To6 = Migration(5, 6, (database) async {
    Logger.getInstance.d("DatabaseHelper", "migrate5To6()", message: "Migrating database version from 5 to 6.");
    await database.transaction((txn) async {
      txn.rawQuery('SELECT itemHash from `${TableNames.ITEM}`').catchError((error) {
        txn.execute('ALTER TABLE ${TableNames.ITEM} ADD COLUMN itemHash TEXT DEFAULT ""').then((_) {
          Logger.getInstance.d("DatabaseHelper", "migrate5To6()", message: "Added column itemHash to table ${TableNames.ITEM}.");
        });
      });
    });
    await database.transaction((txn) async {
      txn.rawQuery('SELECT inSum from `${TableNames.KOT}`').catchError((error) {
        txn.execute('ALTER TABLE ${TableNames.KOT} ADD COLUMN inSum INTEGER 0').then((_) {
          Logger.getInstance.d("DatabaseHelper", "migrate5To6()", message: "Added column inSum to table ${TableNames.KOT}.");
        });
      });
    });
  });

  static final migrate6To7 = Migration(6, 7, (database) async {
    Logger.getInstance.d("DatabaseHelper", "migrate6To7()", message: "Migrating database version from 6 to 7.");
    await database.transaction((txn) async {
      txn.rawQuery('SELECT groupName from `${TableNames.ITEM}`').catchError((error) {
        txn.execute('ALTER TABLE ${TableNames.ITEM} ADD COLUMN groupName TEXT DEFAULT ""').then((_) {
          Logger.getInstance.d("DatabaseHelper", "migrate6To7()", message: "Added column groupName to table ${TableNames.ITEM}.");
        });
      });
    });
  });

  static final migrate7To8 = Migration(7, 8, (database) async {
    Logger.getInstance.d("DatabaseHelper", "migrate7To8()", message: "Migrating database version from 7 to 8.");
    await database.transaction((txn) async {
      txn.rawQuery('SELECT tableNameMatch from `${TableNames.KOT}`').catchError((error) {
        txn.execute('ALTER TABLE ${TableNames.KOT} ADD COLUMN tableNameMatch INTEGER').then((_) {
          Logger.getInstance.d("DatabaseHelper", "migrate7To8()", message: "Added column groupName to table ${TableNames.KOT}.");
        });
      });
    });
  });

  static final migrate8To9 = Migration(8, 9, (database) async {
    Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Migrating database version from 8 to 9.");

    List<Map> columns = await database.rawQuery('PRAGMA table_info(`${TableNames.KOT}`)');
    List<Map> columnsFKOT = await database.rawQuery('PRAGMA table_info(`${TableNames.FKOT}`)');

    // Column: kot
    if (!columns.any((column) => column['name'] == 'kot')) {
      await database.execute('ALTER TABLE `${TableNames.KOT}` ADD COLUMN kot TEXT');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column kot to table ${TableNames.KOT}.");
    }

    // Column: kotDismissed
    if (!columns.any((column) => column['name'] == 'kotDismissed')) {
      await database.execute('ALTER TABLE `${TableNames.KOT}` ADD COLUMN kotDismissed INTEGER');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column kotDismissed to table ${TableNames.KOT}.");
    }

    // Column: receivedTime
    if (!columns.any((column) => column['name'] == 'receivedTime')) {
      await database.execute('ALTER TABLE `${TableNames.KOT}` ADD COLUMN receivedTime TEXT NOT NULL DEFAULT ""');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column receivedTime to table ${TableNames.KOT}.");
    }

    // Column: fKotWithSeparator
    if (!columns.any((column) => column['name'] == 'fKotWithSeparator')) {
      await database.execute('ALTER TABLE `${TableNames.KOT}` ADD COLUMN fKotWithSeparator TEXT NOT NULL DEFAULT ""');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column fKotWithSeparator to table ${TableNames.KOT}.");
    }


    // Column: hashMD5
    if (!columns.any((column) => column['name'] == 'hashMD5')) {
      await database.execute('ALTER TABLE `${TableNames.KOT}` ADD COLUMN hashMD5 TEXT NOT NULL DEFAULT ""');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column hashMD5 to table ${TableNames.KOT}.");
    }

    // Column: snoozeDateTime
    if (!columns.any((column) => column['name'] == 'snoozeDateTime')) {
      await database.execute('ALTER TABLE `${TableNames.KOT}` ADD COLUMN snoozeDateTime TEXT NOT NULL DEFAULT ""');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column snoozeDateTime to table ${TableNames.KOT}.");
    }

    // Column: isUndoKot
    if (!columns.any((column) => column['name'] == 'isUndoKot')) {
      await database.execute('ALTER TABLE `${TableNames.KOT}` ADD COLUMN isUndoKot INTEGER NOT NULL DEFAULT 0');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column isUndoKot to table ${TableNames.KOT}.");
    }

    // Column: hideKot
    if (!columns.any((column) => column['name'] == 'hideKot')) {
      await database.execute('ALTER TABLE `${TableNames.KOT}` ADD COLUMN hideKot INTEGER NOT NULL DEFAULT 0');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column hideKot to table ${TableNames.KOT}.");
    }

    // Column: singleCategory
    if (!columns.any((column) => column['name'] == 'singleCategory')) {
      await database.execute('ALTER TABLE `${TableNames.KOT}` ADD COLUMN singleCategory INTEGER NOT NULL DEFAULT 1');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column singleCategory to table ${TableNames.KOT}.");
    }

    // Column: tableNameMatch
    if (!columns.any((column) => column['name'] == 'tableNameMatch')) {
      await database.execute('ALTER TABLE `${TableNames.KOT}` ADD COLUMN tableNameMatch INTEGER NOT NULL DEFAULT 0');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column tableNameMatch to table ${TableNames.KOT}.");
    }

    // Column: inSum
    if (!columns.any((column) => column['name'] == 'inSum')) {
      await database.execute('ALTER TABLE `${TableNames.KOT}` ADD COLUMN inSum INTEGER NOT NULL DEFAULT 0');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column inSum to table ${TableNames.KOT}.");
    }


    // Column: FKOT tableName
    if (!columnsFKOT.any((column) => column['name'] == 'tableName')) {
      await database.execute('ALTER TABLE `${TableNames.FKOT}` ADD COLUMN tableName TEXT DEFAULT ""');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column tableName to table ${TableNames.FKOT}.");
    }

    // Column: FKOT userName
    if (!columnsFKOT.any((column) => column['name'] == 'userName')) {
      await database.execute('ALTER TABLE `${TableNames.FKOT}` ADD COLUMN userName TEXT DEFAULT ""');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column userName to table ${TableNames.FKOT}.");
    }

    // Column: FKOT total
    if (!columnsFKOT.any((column) => column['name'] == 'total')) {
      await database.execute('ALTER TABLE `${TableNames.FKOT}` ADD COLUMN total REAL DEFAULT 0');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column total to table ${TableNames.FKOT}.");
    }

    // Column: FKOT kotDismissed
    if (!columnsFKOT.any((column) => column['name'] == 'kotDismissed')) {
      await database.execute('ALTER TABLE `${TableNames.FKOT}` ADD COLUMN kotDismissed INTEGER DEFAULT 0');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column kotDismissed to table ${TableNames.FKOT}.");
    }

    // Column: FKOT receivedTime
    if (!columnsFKOT.any((column) => column['name'] == 'receivedTime')) {
      await database.execute('ALTER TABLE `${TableNames.FKOT}` ADD COLUMN receivedTime TEXT DEFAULT ""');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column receivedTime to table ${TableNames.FKOT}.");
    }

    // Column: FKOT kitchenMessage
    if (!columnsFKOT.any((column) => column['name'] == 'kitchenMessage')) {
      await database.execute('ALTER TABLE `${TableNames.FKOT}` ADD COLUMN kitchenMessage TEXT DEFAULT ""');
      Logger.getInstance.d("DatabaseHelper", "migrate8To9()", message: "Added column kitchenMessage to table ${TableNames.FKOT}.");
    }

  });
}
