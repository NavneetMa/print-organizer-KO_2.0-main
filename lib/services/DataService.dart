import 'dart:collection';
import 'dart:convert';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/data/ResCode.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/data/podos/CMap.dart';
import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/db/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/interfaces/ILoadingDialog.dart';
import 'package:kwantapo/ui/interfaces/IMessageDialog.dart';
import 'package:kwantapo/utils/lib.dart';

class DataService {

  static DataService? _instance;

  factory DataService() => getInstance;

  DataService._();
  final List<Item?> _summationItems = [];
  List<AggregatedItem> _aggregateItems = [];

  static DataService get getInstance {
    _instance ??= DataService._();
    return _instance!;
  }

  late IMessageDialog iMessageDialog;
  late ILoadingDialog iLoadingDialog;

  void setMessageDialog(IMessageDialog iMessageDialog){
    this.iMessageDialog = iMessageDialog;
  }

  void setLoadingDialog(ILoadingDialog iLoadingDialog){
    this.iLoadingDialog = iLoadingDialog;
  }


  final String _tag = "DataService";
  final Logger _logger = Logger.getInstance;
  int kotCounter = 1;

  Future<KotJsonData> saveKASSAFKot(dynamic jsonData, int kotId) async {
    final EMT emt = EMT(0);
    int itemCounter = 1;
    try {
      if (jsonData != null) {
        final kotJsonData = KotJsonData.fromJson(jsonData as Map<String, dynamic>);
        final eFKot = EFKot(
          kitchenMessage: kotJsonData.kitchenMessage,
          kotId: kotId,
          receivedTime: DateTime.now().toString(),
          userName: kotJsonData.userName,
          tableName: kotJsonData.tableName,
        );
        if(await addFKot(eFKot)) {
          emt.kotId = kotId;
          emt.receivedTime = eFKot.receivedTime!;
          emt.currentTime = eFKot.receivedTime;
          emt.tableName = eFKot.tableName;
          emt.userName = eFKot.userName;

          int categoryId = 0;
          int categoryCount = 0;
          for (int j = 0; j < kotJsonData.itemList.length; j++) {
            final itemObj = kotJsonData.itemList[j];
            final cName = itemObj.item;
            var eItem = EItem();
            if (cName!.trim().startsWith("--") && cName.trim().endsWith("--")) {
              eItem = EItem(
                fKotId: eFKot.kotId,
                item: cName,
                itemCategory: true,
                groupName: itemObj.groupName.toString(),
              );
              categoryCount++;
              if (categoryCount == 2) {
                await updateSingleCategory(kotId, 0);
              }
            } else {
              emt.numOfItems += 1;
              eItem = EItem(
                fKotId: eFKot.kotId,
                item: cName,
                quantity: int.parse(itemObj.quantity!.replaceAll('x', '')),
                unit: itemObj.unit,
                categoryId: categoryId,
                groupName: itemObj.groupName.toString(),
              );
            }
            final DatabaseManager dbManager = await DatabaseHelper.getInstance;
            if (itemObj.itemAddition.isNotEmpty || itemObj.childItemList.isNotEmpty) {
              eItem.hasChild = true;
            }
            eItem.itemHash = itemCounter.toString()+"-"+DateTime.now().millisecondsSinceEpoch.toString();
            itemCounter++;
            kotJsonData.itemList[j].itemHash = eItem.itemHash;
            await dbManager.itemDao.insert(eItem).then((parentId) async {
              if(cName.trim().startsWith("--") && cName.trim().endsWith("--")){
                categoryId = parentId;
              }
              if (itemObj.itemAddition.isNotEmpty) {
                for (int k = 0; k < itemObj.itemAddition.length; k++) {
                  final EItemAddition itemAdditionItem = EItemAddition(
                    parentId: parentId,
                    itemAddition: itemObj.itemAddition[k],
                  );
                  await dbManager.itemAdditionDao.insert(itemAdditionItem);
                }
              }

              if (itemObj.childItemList.isNotEmpty) {
                for (int k = 0; k < itemObj.childItemList.length; k++) {
                  emt.numOfItems += 1;
                  final EChildItem eChildItem = EChildItem(
                    parentId: parentId,
                    item: itemObj.childItemList[k].item,
                    quantity: int.parse(itemObj.childItemList[k].quantity!.replaceAll('x', ''),),
                    unit: itemObj.childItemList[k].unit,
                  );
                  await dbManager.childItemDao.insert(eChildItem).then((value) async{
                    if (itemObj.childItemList[k].itemAddition.isNotEmpty) {
                      for (int c = 0; c < itemObj.childItemList[k].itemAddition.length; c++) {
                        final EItemAddition itemAdditionItem = EItemAddition(
                          parentId: parentId,
                          itemAddition: itemObj.childItemList[k].itemAddition[c],
                          childItemId: value,
                        );
                        await dbManager.itemAdditionDao.insert(itemAdditionItem);
                      }
                    }
                  });
                }
              }
            });
          }
        }

        return kotJsonData;
      }
    } catch (error) {
      _logger.e(_tag, "saveKASSAFKot", message: error.toString());
    } finally {
      MasterTerminalService.getInstance.addReceivedKot(emt);
    }
    return KotJsonData();
  }

  Future<void> interpretRawData(List<int> finalData) async {
    try {
      final hashMD5 = kotCounter.toString()+"-"+DateTime.now().millisecondsSinceEpoch.toString();
      kotCounter++;
      final jsonData = json.decode(getJsonDataFromDecimalCommands(finalData));
      final dataType = jsonData['dataType'];
      if (dataType == "PoKot") {
        await addKot(EKot(
            kot: finalData.toString(),
            receivedTime: DateTime.now().toString(),
            hashMD5: hashMD5,
            snoozeDateTime: DateTime.now().toString(),
        ), jsonData['data'],
        );
      }
      else {
        final tableName = jsonData['data']['tableName'].toString();
        final dateTime = jsonData['data']['dateTime'].toString();
        filterKOTbyTableName(tableName, dateTime);
      }
    } catch (e) {
      _logger.e(_tag, "interpretRawData()", message: e.toString());
    }
  }

  Future<bool> addKot(EKot eKot, dynamic data) async {
    try {
      eKot.fKotWithSeparator = jsonEncode(data);
      final DatabaseManager dbManager = await DatabaseHelper.getInstance;
      final int kotId = await dbManager.kotDao.insert(eKot);
      final kotJsonData = await saveKASSAFKot(data, kotId);
      isKitchenSumModeIpExist().then((value) async {
          if(value) {
            eKot.fKotWithSeparator = jsonEncode(kotJsonData);
            var result = await KitchenModeApi.getInstance.sendKotToKitchenSumMode(eKot);
            if(result.code==ResCode().failed) {
              Get.snackbar("Alert", "Failed to send data to Kitchen Sum Mode",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppTheme.nearlyBlack,
                colorText: AppTheme.nearlyWhite,);
            }
          }
      });
      updateKotList();
      if (AppConstants.notificationSound) FlutterRingtonePlayer.playNotification();
      return true;
    } catch (error) {
      _logger.e(_tag, "addKot()", message: error.toString());
      return false;
    }
  }

  Future<bool> isKitchenSumModeIpExist() async {
    try {
      String ipAddress = "";
      String port = "";
      await PrefUtils().getKitchenSumModeIpAddress().then((kSumModeIpAddress) {
        ipAddress = kSumModeIpAddress;
      });
      await PrefUtils().getKitchenSumModePort().then((kSumModePort) {
        port = kSumModePort;
      });
      if(ipAddress.isNotEmpty && ipAddress!="0.0.0.0" && port.isNotEmpty && port.length==4) {
        return true;
      }
    } catch (e) {
      _logger.e(_tag, "_setIpAndPortOfKitchenSumMode()", message: e.toString());
    }
    return false;
  }

  Future<int> addKotInKitchenSumMode(EKot eKot, Map<String, dynamic> data) async {
    try {
      eKot.fKotWithSeparator = data.toString();
      final DatabaseManager dbManager = await DatabaseHelper.getInstance;
      final int kotId = await dbManager.kotDao.insert(eKot);
      await saveKitchenSumModeKot(data, kotId);
      if(!AppConstants.clickOfClock && eKot.hideKot==false) {
        await autoSumAggregatedList(kotId);
      }
      if (AppConstants.notificationSound) FlutterRingtonePlayer.playNotification();
      return kotId;
    } catch (error) {
      _logger.e(_tag, "addKotInKitchenSumMode()", message: error.toString());
      return 0;
    }
  }

  Future<int> addKotInKitchenSumModeForClickOfClock(EKot eKot, Map<String, dynamic> data) async {
    try {
      eKot.fKotWithSeparator = data.toString();
      final DatabaseManager dbManager = await DatabaseHelper.getInstance;
      final int kotId = await dbManager.kotDao.insert(eKot);
      await saveKitchenSumModeKot(data, kotId);
      await autoSumAggregatedList(kotId);
      if (AppConstants.notificationSound) FlutterRingtonePlayer.playNotification();
      return kotId;
    } catch (error) {
      _logger.e(_tag, "addKotInKitchenSumModeForClickOfClock()", message: error.toString());
      return 0;
    }
  }

  Future<void> saveKitchenSumModeKot(dynamic jsonData, int kotId) async {
    try {
      if (jsonData != null) {
        final kotJsonData = KotJsonData.fromJson(jsonData as Map<String, dynamic>);
        final eFKot = EFKot(
          kitchenMessage: kotJsonData.kitchenMessage,
          kotId: kotId,
          receivedTime: DateTime.now().toString(),
          userName: kotJsonData.userName,
          tableName: kotJsonData.tableName,
        );
        await addFKot(eFKot);

        int categoryId = 0;
        int categoryCount = 0;
        for (int j = 0; j < kotJsonData.itemList.length; j++) {
          final itemObj = kotJsonData.itemList[j];
          final cName = itemObj.item;
          var eItem = EItem();
          if (cName!.trim().startsWith("--") && cName.trim().endsWith("--")) {
            eItem = EItem(
                fKotId: eFKot.kotId,
                item: cName,
                itemCategory: true,
                groupName: itemObj.groupName.toString(),
            );
            categoryCount++;
            if (categoryCount == 2) {
              await updateSingleCategory(kotId, 0);
            }
          } else {
            eItem = EItem(
                fKotId: eFKot.kotId,
                item: cName,
                quantity: int.parse(itemObj.quantity!.replaceAll('x', '')),
                unit: itemObj.unit,
                categoryId: categoryId,
                groupName: itemObj.groupName.toString(),
            );
          }
          final DatabaseManager dbManager = await DatabaseHelper.getInstance;
          if (itemObj.itemAddition.isNotEmpty || itemObj.childItemList.isNotEmpty) {
            eItem.hasChild = true;
          }
          eItem.itemHash = itemObj.itemHash;
          await dbManager.itemDao.insert(eItem).then((parentId) async {
            if(cName.trim().startsWith("--") && cName.trim().endsWith("--")){
              categoryId = parentId;
            }
            if (itemObj.itemAddition.isNotEmpty) {
              for (int k = 0; k < itemObj.itemAddition.length; k++) {
                final EItemAddition itemAdditionItem = EItemAddition(
                  parentId: parentId,
                  itemAddition: itemObj.itemAddition[k],
                );
                await dbManager.itemAdditionDao.insert(itemAdditionItem);
              }
            }

            if (itemObj.childItemList.isNotEmpty) {
              for (int k = 0; k < itemObj.childItemList.length; k++) {
                final EChildItem eChildItem = EChildItem(
                  parentId: parentId,
                  item: itemObj.childItemList[k].item,
                  quantity: int.parse(itemObj.childItemList[k].quantity!.replaceAll('x', ''),),
                  unit: itemObj.childItemList[k].unit,
                );
                await dbManager.childItemDao.insert(eChildItem).then((value) async{
                  if (itemObj.childItemList[k].itemAddition.isNotEmpty) {
                    for (int c = 0; c < itemObj.childItemList[k].itemAddition.length; c++) {
                      final EItemAddition itemAdditionItem = EItemAddition(
                          parentId: parentId,
                          itemAddition: itemObj.childItemList[k].itemAddition[c],
                          childItemId: value,
                      );
                      await dbManager.itemAdditionDao.insert(itemAdditionItem);
                    }
                  }
                });
              }
            }
          });
        }
      }
    } catch (error) {
      _logger.e(_tag, "saveKitchenSumModeKot", message: error.toString());
    }
  }

  //Kot is getting formatted
  String getJsonDataFromDecimalCommands(List<int> finalData) {
    final stringJson = StringBuffer();
    try {
      int i = 0;
      const int offset = 7;
      while (i<finalData.length) {
        if (offset<finalData.length-i) {
          stringJson.write(latin1.decode(finalData.getRange(i, i + offset).toList()));
        } else {
          stringJson.write(latin1.decode(finalData.getRange(i, i + (finalData.length-i)).toList()));
        }
        i+= offset;
      }
    } catch (error) {
      _logger.e(_tag, "getJsonDataFromDecimalCommands()", message: error.toString());
    }
    return stringJson.toString();
  }

  Future<void> updateIsDismissed(int? kotId) async {
    try {
      final DatabaseManager dbManager = await DatabaseHelper.getInstance;
      await dbManager.kotDao.updateIsDismissed(kotId!, 1);
      await dbManager.fkotDao.updateIsDismissed(kotId, 1);
    } catch (error) {
      _logger.e(_tag, "updateIsDismissed()", message: error.toString());
    }
  }

  Future<List<EKot?>> _getKotList() async {
    final List<EKot?> eKot = [];
    try {
      final db = await DatabaseHelper.getInstance;
      return db.kotDao.getAll();
    } catch (error) {
      _logger.e(_tag, "getKotList()", message: error.toString());
      return eKot;
    }
  }

  Future<List<EKot?>> _getUnHiddenKot() async {
    final List<EKot?> eKot = [];
    try {
      final db = await DatabaseHelper.getInstance;
      return db.kotDao.getUnHiddenKot();
    } catch (error) {
      _logger.e(_tag, "getUnHiddenKot()", message: error.toString());
      return eKot;
    }
  }

  Future<List<EKot?>> _getHideKotList() async {
    final List<EKot?> eKot = [];
    try {
      return DatabaseHelper.getInstance.then((db) => db.kotDao.getHideKotList().then((value) => value));
    } catch (error) {
      _logger.e(_tag, "getHideKotList()", message: error.toString());
      return eKot;
    }
  }

  Future<List<EKot?>> _getLatestKot() async {
    try {
      final db = await DatabaseHelper.getInstance;
      return await db.kotDao.getLatest();
    } catch (error) {
      _logger.e(_tag, "getLatestKot()", message: error.toString());
      return [];  // Returning an empty list in case of an error
    }
  }


  Future<List<Item?>> getItems(int fKotId) async {
    final List<Item?> itemList = [];
    try {
      final dbManager = await DatabaseHelper.getInstance;
      final eItemList = await dbManager.itemDao.getItems(fKotId);
      if(eItemList.isEmpty){
        _logger.e(_tag, "getItems()", message: "Empty Item List");
        return itemList;
      }
      for (int i = 0; i < eItemList.length; i++) {
        final item = Item();
        item.childItems = await _getChildItems(eItemList[i]!.id!);
        item.eItemAddition = await _getItemAdditions(eItemList[i]!.id!);
        item.item = eItemList[i]!.item;
        item.quantity = eItemList[i]!.quantity;
        item.fKotId = eItemList[i]!.fKotId;
        item.unit = eItemList[i]!.unit;
        item.hasChild = eItemList[i]!.hasChild;
        item.itemCategory = eItemList[i]!.itemCategory;
        item.categoryId = eItemList[i]!.categoryId;
        item.itemId = eItemList[i]!.id!;
        item.checkbox = eItemList[i]!.checked;
        item.isPrinted = eItemList[i]!.isPrinted;
        item.itemHash = eItemList[i]!.itemHash;
        item.groupName = eItemList[i]!.groupName;
        itemList.add(item);
      }
    } catch (error) {
      _logger.e(_tag, "getItems()", message: error.toString());
      return [];
    }
    return itemList;
  }

  Future<List<EItemAddition?>> _getItemAdditions(int parentId) async {
    try {
      var db = await DatabaseHelper.getInstance;
      return await db.itemAdditionDao.getItemAddition(parentId);
    } catch (error) {
      _logger.e(_tag, "_getItemAdditions()", message: error.toString());
      return [];
    }
  }

  Future<List<EKot?>> getUnDismissedKot() async {
    try{
     return await getKotForKitchenSumMode();
    } catch (error) {
      _logger.e(_tag, "getUnDismissedKot()", message: error.toString());
      return [];
    }
  }

  Future<List<EItemAddition?>> _getItemAdditionsByChildItemId(int childItemId) async {
    try {
      return DatabaseHelper.getInstance.then((db) => db.itemAdditionDao.getItemAdditionByChildItemId(childItemId));
    } catch (error) {
      _logger.e(_tag, "_getItemAdditionsByChildItemId()", message: error.toString());
      return [];
    }
  }

  Future<List<EKot?>> getKotForKitchenSumMode() async {
    try {
      List<EKot?> eKotList = await _getKotList();
      if(eKotList.isEmpty){
        _logger.e(_tag, "getKotForKitchenSumMode()", message: "Empty KOT List");
        return eKotList;
      }
      for (int i = 0; i < eKotList.length; i++) {
        List<Map<String,dynamic>> jsonItemList = [];
        final eKot = eKotList[i];
        final EFKot? efKot = await getFKot(eKot!.id!);
        if(efKot != null) {
          var itemHashList= await getItems(eKot.id!);
          for (int i = 0; i < itemHashList.length; i++) {
            Map<String,dynamic> mapItem = {};
            Map<String,dynamic> childItem = {};
            List<String> itemAddition = [];
            mapItem["item"] = itemHashList[i]?.item;
            mapItem["quantity"] = itemHashList[i]?.quantity;
            mapItem["unit"] = itemHashList[i]?.unit;
            mapItem["itemHash"] = itemHashList[i]?.itemHash;
            mapItem["isCategory"] = itemHashList[i]?.itemCategory;
            mapItem["groupName"] = itemHashList[i]?.groupName;
            mapItem["childItemList"] = itemHashList[i]?.childItems;
            itemHashList[i]?.childItems.forEach((element) {
              childItem["item"] = element?.item;
              childItem["quantity"] = element?.quantity;
              childItem["unit"] = element?.unit;
              childItem["itemAddition"] = element?.eItemAddition;
            });
             itemHashList[i]?.eItemAddition.forEach((element) {
               itemAddition.add(element!.itemAddition);
             });
             mapItem["itemAddition"] = itemAddition;

             jsonItemList.add(mapItem);
          }
          Map<String, dynamic> mapKot = {};
          mapKot['tableName'] = efKot.tableName;
          mapKot['userName'] = efKot.userName;
          mapKot['itemList'] = jsonItemList;
          eKot.fKotWithSeparator=jsonEncode(mapKot);
        }
      }
      return eKotList;
    } catch (error) {
      _logger.e(_tag, "getKotForKitchenSumMode", message: error.toString());
      return [];
    }
  }

  Future<List<EKot?>> getSnoozedKotForKitchenSumMode() async {
    try {
      List<EKot?> eKotList = await _getHideKotList();
      if(eKotList.isEmpty){
        _logger.e(_tag, "getSnoozedKotForKitchenSumMode()", message: "Empty KOT List");
        return eKotList;
      }
      for (int i = 0; i < eKotList.length; i++) {
        List<Map<String,dynamic>> jsonItemList = [];
        final eKot = eKotList[i];
        final EFKot? efKot = await getFKot(eKot!.id!);
        if(efKot != null) {
          var itemHashList= await getItems(eKot.id!);
          for (int i = 0; i < itemHashList.length; i++) {
            Map<String,dynamic> mapItem = {};
            Map<String,dynamic> childItem = {};
            List<String> itemAddition = [];
            mapItem["item"] = itemHashList[i]?.item;
            mapItem["quantity"] = itemHashList[i]?.quantity;
            mapItem["unit"] = itemHashList[i]?.unit;
            mapItem["itemHash"] = itemHashList[i]?.itemHash;
            mapItem["isCategory"] = itemHashList[i]?.itemCategory;
            mapItem["groupName"] = itemHashList[i]?.groupName;
            mapItem["childItemList"] = itemHashList[i]?.childItems;
            itemHashList[i]?.childItems.forEach((element) {
              childItem["item"] = element?.item;
              childItem["quantity"] = element?.quantity;
              childItem["unit"] = element?.unit;
              childItem["itemAddition"] = element?.eItemAddition;
            });
            itemHashList[i]?.eItemAddition.forEach((element) {
              itemAddition.add(element!.itemAddition);
            });
            mapItem["itemAddition"] = itemAddition;

            jsonItemList.add(mapItem);
          }
          Map<String, dynamic> mapKot = {};
          mapKot['tableName'] = efKot.tableName;
          mapKot['userName'] = efKot.userName;
          mapKot['itemList'] = jsonItemList;
          eKot.fKotWithSeparator=jsonEncode(mapKot);
        }
      }
      return eKotList;
    } catch (error) {
      _logger.e(_tag, "getSnoozedKotForKitchenSumMode()", message: error.toString());
      return [];
    }
  }


  Future<List<Kot?>> getFormattedKot({bool isSingle = false}) async {
    try {
      final List<Kot?> kotCmdList = [];
      List<EKot?>? eKotList = [];

      if (AppConstants.selectedMode == AppConstants.KITCHEN_SUM_MODE) {
        eKotList = await _getUnHiddenKot();
      } else {
        eKotList = isSingle ? await _getLatestKot() : await _getKotList();
      }
      if (eKotList.isEmpty) {
        _logger.e(_tag, "getFormattedKot()", message: "Empty KOT List");
        return kotCmdList;  // Return an empty list
      }
      for (int i = 0; i < eKotList.length; i++) {
        final eKot = eKotList[i];
        final EFKot? efKot = await getFKot(eKot!.id!);
        if (efKot != null) {
          kotCmdList.add(
              Kot(
                  id: eKot.id,
                  items: await getItems(eKot.id!),
                  receivedTime: eKot.receivedTime,
                  kotDismissed: eKot.kotDismissed,
                  hashMD5: eKot.hashMD5,
                  inSum: AppConstants.selectedMode == AppConstants.KITCHEN_SUM_MODE ? eKot.inSum : AppConstants.isAutoSum,
                  tableName: efKot.tableName == null ? "" : efKot.tableName!,
                  userName: efKot.userName!,
                  kitchenMessage: efKot.kitchenMessage.toString(),
                  isUndoKot: eKot.isUndoKot,
                  snoozeDateTime: eKot.snoozeDateTime,
                  hideKot: eKot.hideKot,
                  singleCategory: eKot.singleCategory,
                  tableNameMatch: eKot.tableNameMatch,
              ),
          );
        }
      }
      return kotCmdList;
    } catch (error) {
      _logger.e(_tag, "getFormattedKot()", message: error.toString());
      return [];
    }
  }

  Future<void> getKOTListForSummation() async {
    try {
     AppConstants.isProcessing=true;
      clearSummationList();
      final response = AppConstants.clickOfClock ? await getHideKot(): await getFormattedKot();
      if (response.isNotEmpty) {
        for (final element in response) {
         await autoSumAggregatedList(element!.id!);
        }
      }
      AppConstants.isProcessing=false;
    } catch (error) {
      _logger.e(_tag, "getKOTListForSummation()", message: error.toString());
    }
  }

  Future<List<Kot?>> getHideKot() async {
    try {
      final List<Kot?> kotCmdList = [];
      final List<EKot?> eKotList = await _getHideKotList();
      if (eKotList.isEmpty) {
        _logger.e(_tag, "getHideKot()", message: "Empty Hide KOT List");
        return kotCmdList;  // Return an empty list
      }
      for (int i = 0; i< eKotList.length; i++) {
        final eKot = eKotList[i];
        final EFKot? efKot = await getFKot(eKot!.id!);
        if(efKot != null){
          kotCmdList.add(
              Kot(
                  id: eKot.id,
                  items: await getItems(eKot.id!),
                  receivedTime: eKot.receivedTime,
                  kotDismissed: eKot.kotDismissed,
                  hashMD5: eKot.hashMD5,
                  inSum: AppConstants.isAutoSum,
                  tableName: efKot.tableName == null ? "" : efKot.tableName!,
                  userName: efKot.userName!,
                  kitchenMessage: efKot.kitchenMessage.toString(),
                  isUndoKot: eKot.isUndoKot,
                  snoozeDateTime: eKot.snoozeDateTime,
                  hideKot: eKot.hideKot,
              ),
          );
        }
      }
      return kotCmdList;
    } catch (error) {
      _logger.e(_tag, "getHideKot()", message: error.toString());
      return [];
    }
  }

  bool getHideKotFlag(EKot eKot) {
    if (eKot.snoozeDateTime.isEmpty) {
      return false;
    } else {
      return DateTime.parse(eKot.snoozeDateTime).isAfter(DateTime.now());
    }
  }

  Future<void> updateKotList() async {
    try {
      final List<Kot?> eKotList = await getFormattedKot(isSingle: true);
      if (eKotList.isNotEmpty) {
        final kot = eKotList.first;
        await Get.find<KOTController>().addToList(kot);
      }
    } catch (error) {
      _logger.e(_tag, "updateKotList() - ", message: error.toString());
    }
  }

  Future<EFKot?> getFKot(int kotId) async {
    try {
      final DatabaseManager dbManager = await DatabaseHelper.getInstance;
      return await dbManager.fkotDao.getSingle(kotId);
    } catch (error) {
      _logger.e(_tag, "getFKot()", message: error.toString());
      return null;
    }
  }

  Future<bool> addFKot(EFKot fKot) async {
    try {
      final DatabaseManager dbManager = await DatabaseHelper.getInstance;
      await dbManager.fkotDao.insert(fKot);
      return true;
    } catch (error) {
      _logger.e(_tag, "addFKot()", message: error.toString());
      return false;
    }
  }

  Future<int> addFItem(EItem item) async {
    try {
      final DatabaseManager dbManager = await DatabaseHelper.getInstance;
      return await dbManager.itemDao.insert(item);
    } catch (error) {
      _logger.e(_tag, "addFItem()", message: error.toString());
      return 0;
    }
  }

  Future<void> updateSingleCategory(int kotId, int singleCategory) async {
    try {
      final DatabaseManager dbManager = await DatabaseHelper.getInstance;
      await dbManager.kotDao.updateSingleCategory(kotId, singleCategory);
    } catch (error) {
      _logger.e(_tag, "updateSingleCategory()", message: error.toString());
    }
  }

  Future<List<ChildItem?>> _getChildItems(int parentId) async {
    try {
      final DatabaseManager dbManager = await DatabaseHelper.getInstance;
      final List<EChildItem?> eChildItems = await dbManager.childItemDao.getChildItems(parentId);
      if(eChildItems.isEmpty){
        return [];
      }
      final List<ChildItem?> childItems = [];
      for (int i = 0; i < eChildItems.length; i++) {
        final element = eChildItems[i];
        final childItem = ChildItem(
            item: element?.item,
            quantity: element?.quantity,
            unit: element?.unit,
            id: element?.id,
            parentId: parentId,
        );
        childItems.add(childItem);
      }
      for (int i = 0; i < childItems.length; i++) {
        childItems[i]?.eItemAddition =
        await _getItemAdditionsByChildItemId(childItems[i]!.id!);
      }
      return childItems;
    } catch (error) {
      _logger.e(_tag, "getChildItems()", message: error.toString());
      return [];
    }
  }

  Future<void> filterKOTbyTableName(String tableName, String dateTime) async {
    final DatabaseManager dbManager = await DatabaseHelper.getInstance;
    final controller = Get.find<KOTController>();
    for (final element in controller.kotList) {
      if (element!.tableName.trim() == tableName.trim()) {
        if (element.items.any((e) => e!.categoryId != 0)) {
          await dbManager.kotDao.updateTableNameMatch(element.id!,true);
          element.tableNameMatch = true;
        }
      }
    }
    controller.kotList.refresh();
  }




  //Get Aggregated Items
  Future<void> addAggregateItems(int id, {bool isAutoSum = false, bool hideKot = false,EKot? kot}) async {
    try {
      final List<Item?> list = await getItems(id);
      list.removeWhere((element) => element!.item!.trim().startsWith("--"));
      _aggregateItems = [];
      bool addToSum = true;
      final aggregateItemController = Get.find<AggregatedItemController>();

      if (!isAutoSum) {
        final controller = Get.find<KOTController>();
        for (int i = 0; i < controller.kotList.length; i++) {
          final element = controller.kotList[i];
          if (element!.id == id) {
            if (element.inSum == true) {
              addToSum = false;
              _summationItems.removeWhere((element) => element?.fKotId == id);
              aggregateItemController.aggregatedList.removeWhere((element) => element.id == id);
              controller.kotList[i]!.inSum = false;
              controller.kotList.refresh();
              break;
            } else {
              controller.kotList[i]!.inSum = true;
              controller.kotList.refresh();
            }
          }
        }
      } else {
        for (final element in _summationItems) {
          if (element?.fKotId == id) {
            addToSum = false;
          }
        }
      }

      if (addToSum) _summationItems.addAll(list);

      var itemFound = false;
      for (final e in _summationItems) {
        for (int i = 0; i < _aggregateItems.length; i++) {
          if (e?.hasChild == _aggregateItems[i].hasChild &&
              e?.itemCategory == false &&
              e?.item == _aggregateItems[i].item &&
              e?.unit == _aggregateItems[i].unit
          ) {
            itemFound = true;
            if (e?.childItems.length == _aggregateItems[i].childItems.length) {
              for (int j = 0; j < e!.childItems.length; j++) {
                itemFound = false;
                for (final childItem in _aggregateItems[i].childItems) {
                  if (e.childItems[j]?.item == childItem?.item &&
                      e.childItems[j]?.quantity == childItem?.quantity &&
                      e.childItems[j]?.unit == childItem?.unit) {
                    itemFound = true;
                    if (e.childItems[j]?.eItemAddition.length ==
                        childItem?.eItemAddition.length) {
                      for (int k = 0; k <
                          e.childItems[j]!.eItemAddition.length; k++) {
                        itemFound = false;
                        for (final eAdd in childItem!.eItemAddition) {
                          if (e.childItems[j]?.eItemAddition[k]?.itemAddition == eAdd?.itemAddition) {
                            itemFound = true;
                          }
                        }
                        if (!itemFound) {
                          break;
                        }
                      }
                    } else if (e.childItems[j]?.eItemAddition.length !=
                        childItem?.eItemAddition.length) {
                      itemFound = false;
                    }
                  }
                }
                if (!itemFound) {
                  break;
                }
              }
            } else {
              itemFound = false;
            }
            bool itemAdditionMatched = true;
            if (e?.eItemAddition.length == _aggregateItems[i].eItemAddition.length) {
              for (int j = 0; j < e!.eItemAddition.length; j++) {
                itemAdditionMatched = false;
                for (final eAdd in _aggregateItems[i].eItemAddition) {
                  if (e.eItemAddition[j]?.itemAddition == eAdd?.itemAddition) {
                    itemAdditionMatched = true;
                  }
                }
                if (itemAdditionMatched == false) {
                  break;
                }
              }
            } else if (e?.eItemAddition.length !=
                _aggregateItems[i].eItemAddition.length) {
              itemAdditionMatched = false;
            }
            if (itemFound && itemAdditionMatched) {
              int count = _aggregateItems[i].count!;
              count += e!.quantity!;
              _aggregateItems[i].count = count;
              _aggregateItems[i].idList?.addAll({id: [e.itemId]});
              if (_aggregateItems[i].idList!.containsKey(e.fKotId)) {
                // Key already exists, add e.itemId to existing list
                final List<int>? itemIdLst = _aggregateItems[i].idList![e.fKotId];
                itemIdLst?.add(e.itemId);
                _aggregateItems[i].idList![e.fKotId!] = itemIdLst!;
              } else {
                // Key does not exist, create new list with e.itemId
                final List<int> itemIdLst = [e.itemId];
                _aggregateItems[i].idList!.putIfAbsent(e.fKotId!, () => itemIdLst);
              }
              break;
            } else {
              itemFound = false;
            }
          }
        }

        if (!itemFound) {
          final HashMap<int, List<int>> map = HashMap<int, List<int>>();
          final int? fKotId = e?.fKotId;
          final int? itemId = e?.itemId;

          if (map.containsKey(fKotId)) {
            // Key already exists, add itemId to existing list
            final List<int>? itemIdList = map[fKotId!];
            itemIdList?.add(itemId!);
            map[fKotId] = itemIdList!;
          } else {
            // Key does not exist, create new list with itemId
            final List<int> itemIdList = [itemId!];
            map.putIfAbsent(fKotId!, () => itemIdList);
          }
          final agrItem = AggregatedItem(
              item: e?.item,
              count: e?.quantity,
              unit: e?.unit,
              id: e?.fKotId,
              hasChild: e?.hasChild,
              childItems: e!.childItems,
              eItemAddition: e.eItemAddition,
              groupName: e.groupName!,
              idList: map,
              hideKot: hideKot,
          );
          _aggregateItems.add(agrItem);
        }
        itemFound = false;
      }
      if(kot != null){
        if(kot.hideKot==false && AppConstants.clickOfClock){
          return;
        } else if(kot.hideKot==true && !AppConstants.clickOfClock){
          return;
        }
      }
      aggregateItemController.aggregatedList.assignAll(_aggregateItems);
    } catch (e) {
      _logger.e(_tag, "addAggregateItems()", message: e.toString());
    }
  }

  Future<void> autoSumAggregatedList(int id) async {
    try {
      final List<Item?> list = await getItems(id);
      list.removeWhere((element) => element!.item!.trim().startsWith("--"));
      _aggregateItems = [];
      _summationItems.addAll(list);
      final aggregateItemController = Get.put(AggregatedItemController());
      var itemFound = false;
      for (final e in _summationItems) {
        for (int i = 0; i < _aggregateItems.length; i++) {
          if (e?.hasChild == _aggregateItems[i].hasChild &&
              e?.itemCategory == false &&
              e?.item == _aggregateItems[i].item &&
              e?.unit == _aggregateItems[i].unit
          ) {
            itemFound = true;
            if (e?.childItems.length == _aggregateItems[i].childItems.length) {
              for (int j = 0; j < e!.childItems.length; j++) {
                itemFound = false;
                for (final childItem in _aggregateItems[i].childItems) {
                  if (e.childItems[j]?.item == childItem?.item &&
                      e.childItems[j]?.quantity == childItem?.quantity &&
                      e.childItems[j]?.unit == childItem?.unit) {
                    itemFound = true;
                    if (e.childItems[j]?.eItemAddition.length ==
                        childItem?.eItemAddition.length) {
                      for (int k = 0; k < e.childItems[j]!.eItemAddition.length; k++) {
                        itemFound = false;
                        for (final eAdd in childItem!.eItemAddition) {
                          if (e.childItems[j]?.eItemAddition[k]?.itemAddition == eAdd?.itemAddition) {
                            itemFound = true;
                          }
                        }
                        if (!itemFound) {
                          break;
                        }
                      }
                    } else if (e.childItems[j]?.eItemAddition.length !=
                        childItem?.eItemAddition.length) {
                      itemFound = false;
                    }
                  }
                }
                if (!itemFound) {
                  break;
                }
              }
            } else {
              itemFound = false;
            }
            bool itemAdditionMatched = true;
            if (e?.eItemAddition.length ==
                _aggregateItems[i].eItemAddition.length) {
              for (int j = 0; j < e!.eItemAddition.length; j++) {
                itemAdditionMatched = false;
                for (final eAdd in _aggregateItems[i].eItemAddition) {
                  if (e.eItemAddition[j]?.itemAddition == eAdd?.itemAddition) {
                    itemAdditionMatched = true;
                  }
                }
                if (itemAdditionMatched == false) {
                  break;
                }
              }
            } else if (e?.eItemAddition.length !=
                _aggregateItems[i].eItemAddition.length) {
              itemAdditionMatched = false;
            }
            if (itemFound && itemAdditionMatched) {
              int count = _aggregateItems[i].count!;
              count += e!.quantity!;
              _aggregateItems[i].count = count;
              if (_aggregateItems[i].idList!.containsKey(e.fKotId)) {
                // Key already exists, add e.itemId to existing list
                final List<int>? itemIdLst = _aggregateItems[i].idList![e.fKotId];
                itemIdLst?.add(e.itemId);
                _aggregateItems[i].idList![e.fKotId!] = itemIdLst!;
              } else {
                // Key does not exist, create new list with e.itemId
                final List<int> itemIdLst = [e.itemId];
                _aggregateItems[i].idList!.putIfAbsent(e.fKotId!, () => itemIdLst);
              }
              break;
            } else {
              itemFound = false;
            }
          }
        }

        if (!itemFound) {
          final HashMap<int, List<int>> map = HashMap<int, List<int>>();
          final int? fKotId = e?.fKotId;
          final int? itemId = e?.itemId;

          if (map.containsKey(fKotId)) {
            // Key already exists, add itemId to existing list
            final List<int>? itemIdList = map[fKotId!];
            itemIdList?.add(itemId!);
            map[fKotId] = itemIdList!;
          } else {
            // Key does not exist, create new list with itemId
            final List<int> itemIdList = [itemId!];
            map.putIfAbsent(fKotId!, () => itemIdList);
          }
          final agrItem = AggregatedItem(
              item: e?.item,
              count: e?.quantity,
              unit: e?.unit,
              id: e?.fKotId,
              hasChild: e?.hasChild,
              childItems: e!.childItems,
              eItemAddition: e.eItemAddition,
              groupName: e.groupName!,
              idList: map,
          );
          _aggregateItems.add(agrItem);
        }
        itemFound = false;
      }
      aggregateItemController.aggregatedList.assignAll(_aggregateItems);
    } catch (e) {
      _logger.e(_tag, "autoSumAggregatedList()", message: e.toString());
    }
  }

  Future<bool> removeFromSummationList(int id) async {
    try {
      _summationItems.removeWhere((element) => element?.fKotId == id);
      _removeFromSummation();
    } catch (e) {
      _logger.e(_tag, "removeFromSummationList()", message: e.toString());
    }
    return true;
  }

  Future<bool> removeFromSummationListByItemId(int itemId) async {
    try {
      _summationItems.removeWhere((element) => element?.itemId == itemId);
      _removeFromSummation();
    } catch (e) {
      _logger.d(_tag, "removeFromSummationListByItemId()", message: e.toString());
    }
    return true;
  }

  void _removeFromSummation() {
    _aggregateItems = [];
    var itemFound = false;
    for (final e in _summationItems) {
      for (int i = 0; i < _aggregateItems.length; i++) {
        if (e?.hasChild == _aggregateItems[i].hasChild &&
            e?.itemCategory == false &&
            e?.item == _aggregateItems[i].item &&
            e?.unit == _aggregateItems[i].unit
        ) {
          itemFound = true;
          if (e?.childItems.length == _aggregateItems[i].childItems.length) {
            for (int j = 0; j < e!.childItems.length; j++) {
              itemFound = false;
              for (final childItem in _aggregateItems[i].childItems) {
                if (e.childItems[j]?.item == childItem?.item &&
                    e.childItems[j]?.quantity == childItem?.quantity &&
                    e.childItems[j]?.unit == childItem?.unit) {
                  itemFound = true;
                  if (e.childItems[j]?.eItemAddition.length == childItem?.eItemAddition.length) {
                    for (int k = 0; k < e.childItems[j]!.eItemAddition.length; k++) {
                      itemFound = false;
                      for (final eAdd in childItem!.eItemAddition) {
                        if (e.childItems[j]?.eItemAddition[k]?.itemAddition == eAdd?.itemAddition) {
                          itemFound = true;
                        }
                      }
                      if (!itemFound) {
                        break;
                      }
                    }
                  } else if (e.childItems[j]?.eItemAddition.length !=
                      childItem?.eItemAddition.length) {
                    itemFound = false;
                  }
                }
              }
              if (!itemFound) {
                break;
              }
            }
          } else {
            itemFound = false;
          }
          bool itemAdditionMatched = true;
          if (e?.eItemAddition.length ==
              _aggregateItems[i].eItemAddition.length) {
            for (int j = 0; j < e!.eItemAddition.length; j++) {
              itemAdditionMatched = false;
              for (final eAdd in _aggregateItems[i].eItemAddition) {
                if (e.eItemAddition[j]?.itemAddition == eAdd?.itemAddition) {
                  itemAdditionMatched = true;
                }
              }
              if (itemAdditionMatched == false) {
                break;
              }
            }
          } else if (e?.eItemAddition.length !=
              _aggregateItems[i].eItemAddition.length) {
            itemAdditionMatched = false;
          }
          if (itemFound && itemAdditionMatched) {
            int count = _aggregateItems[i].count!;
            count += e!.quantity!;
            _aggregateItems[i].count = count;
            if (_aggregateItems[i].idList!.containsKey(e.fKotId)) {
              // Key already exists, add e.itemId to existing list
              final List<int>? itemIdLst = _aggregateItems[i].idList![e.fKotId];
              itemIdLst?.add(e.itemId);
              _aggregateItems[i].idList![e.fKotId!] = itemIdLst!;
            } else {
              // Key does not exist, create new list with e.itemId
              final List<int> itemIdLst = [e.itemId];
              _aggregateItems[i].idList!.putIfAbsent(e.fKotId!, () => itemIdLst);
            }
            break;
          } else {
            itemFound = false;
          }
        }
      }

      if (!itemFound) {
        final HashMap<int, List<int>> map = HashMap<int, List<int>>();
        final int? fKotId = e?.fKotId;
        final int? itemId = e?.itemId;

        if (map.containsKey(fKotId)) {
          // Key already exists, add itemId to existing list
          final List<int>? itemIdList = map[fKotId!];
          itemIdList?.add(itemId!);
          map[fKotId] = itemIdList!;
        } else {
          // Key does not exist, create new list with itemId
          final List<int> itemIdList = [itemId!];
          map.putIfAbsent(fKotId!, () => itemIdList);
        }
        final agrItem = AggregatedItem(
            item: e?.item,
            count: e?.quantity,
            unit: e?.unit,
            id: e?.fKotId,
            hasChild: e?.hasChild,
            childItems: e!.childItems,
            eItemAddition: e.eItemAddition,
            groupName: e.groupName!,
            idList: map,
        );
        _aggregateItems.add(agrItem);
      }
      itemFound = false;
    }
    Get.find<AggregatedItemController>().aggregatedList.assignAll(_aggregateItems);
  }

  void removeFromSummationListOnMinusPressed(int id) {
    removeFromSummationList(id);
    final int index = Get
        .find<KeyboardInputController>()
        .indexInput
        .value;
    if (index >= 0) {
      addAggregateItems(id);
    } else {
      _logger.e(_tag, "removeFromSummationListOnMinusPressed()", message: index.toString());
    }
  }

  List<AggregatedItem> getAggregatedList() => _aggregateItems;

  void clearSummationList() {
    try {
      Get.find<AggregatedItemController>().aggregatedList.clear();
      Get.find<AggregatedItemController>().hasAggregatedList(false);
    } catch (e) {
      Get.put(AggregatedItemController());
      _logger.d(_tag, "clearSummationList()", message: e.toString());
    }
    _summationItems.clear();
  }

  Future<List<EPrinter>> getPrinterList() async {
    final DatabaseManager dbManager = await DatabaseHelper.getInstance;
    return dbManager.printerDao.getAll();
  }

  Future<void> addPrinter(EPrinter ePrinter) async {
    final DatabaseManager dbManager = await DatabaseHelper.getInstance;
    final int id = await dbManager.printerDao.insert(ePrinter);
    ePrinter.id = id;
    Get.find<PrinterController>().addPrinter(ePrinter);
  }

  Future<void> deletePrinter(int id) async {
    final DatabaseManager dbManager = await DatabaseHelper.getInstance;
    await dbManager.printerDao.delete(id);
    Get.find<PrinterController>().removePrinter(id);
  }

  Future<void> updatePrinterIsSend(int id, bool isSend) async {
    final DatabaseManager dbManager = await DatabaseHelper.getInstance;
    await dbManager.printerDao.updateIsSelected(id, isSend);
  }

  Future<void> updatePrinterIsRemove(int id, bool isRemove) async {
    final DatabaseManager dbManager = await DatabaseHelper.getInstance;
    await dbManager.printerDao.updateIsRemoved(id, isRemove);
  }

  Future<List<EPrinter?>> getSelectedPrinterList() async {
    final DatabaseManager dbManager = await DatabaseHelper.getInstance;
    return dbManager.printerDao.getSelectedPrinter(true);
  }


  Future<void> addDismissedKotOnUndo() async {
    final Kot? testKot = Get.find<KOTController>().removeDismissedKotOnUndoKitchenSumMode();
    if(testKot != null){
      var result = await KitchenModeApi.getInstance.addUndoKotItem([testKot.hashMD5!]);
      if(result.code==ResCode().failed) {
        iMessageDialog.showMessageDialog("Alert", "Failed to send data to Kitchen Sum Mode");
        return;
      }
    }
    final Kot? kot = Get.find<KOTController>().removeDismissedKotOnUndo();
    if (kot != null) {

        final DatabaseManager dbManager = await DatabaseHelper.getInstance;
        await dbManager.kotDao.updateIsDismissed(kot.id!, 0);
        await dbManager.fkotDao.updateIsDismissed(kot.id!, 0);
        if (AppConstants.isAutoSum == true) {
          kot.inSum = true;
        }
    } else {
      Get.snackbar("Undo", "Dismissed kot history is not available",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.nearlyBlack,
          colorText: AppTheme.nearlyWhite,);
      }
  }

  Future<void> updateItem(int index, List<AggregatedItem> aggregatedItems, AggregatedItemController aggregateItemController) async {
    final List<ItemData> list = [];
    // Make sure the aggregated items list is not null or empty
    final List<int> itemIds = [];
    final controller = Get.find<KOTController>();
    if (aggregatedItems.isNotEmpty) {
      bool isLoadingDismissed = false;
      iLoadingDialog.showLoadingDialog("Loading");
      var kotId = 0;
      List<CMap> mapList = [];
      aggregatedItems[index].idList?.forEach((key, value) async {
        // Make sure the id list is not null
        final cMap = CMap();
        cMap.itemIds = value.toList();
        cMap.kotId = key;
        mapList.add(cMap);
      });
      for (int  j = 0; j < mapList.length; j++) {
        kotId = mapList[j].kotId;
        for (int i = 0;i < mapList[j].itemIds.length; i++) {
          final itemId = mapList[j].itemIds[i];
          var temp = await ItemService.getInstance.getItemHash(itemId);
          var result = await KitchenModeApi.getInstance.removeItemFromSum([temp]);
          if(result.code==ResCode().failed) {
            isLoadingDismissed = true;
            NavigationService.getInstance.goBack();
            iMessageDialog.showMessageDialog("Alert", "Unable to connect to KitchenSumMode");
            break;
          }
          await ItemService.getInstance.updateIsPrinted(itemId);
          // Make sure the kotList is not null or empty
          if (controller.kotList.isNotEmpty) {
            // Find the Kot object in the kotList
            final kot = controller.kotList.firstWhere((p0) => p0?.id == kotId, orElse: () => null);
            // Make sure the Kot object was found
            if (kot != null) {
              // Make sure the Kot object's items list is not null or empty
              if (kot.items.isNotEmpty) {
                final item = kot.items.firstWhere((p0) => p0?.itemId == itemId, orElse: () => null,);
                // Make sure the item was found
                if (item != null) {
                  Item? categoryItem;
                  try {
                    categoryItem = kot.items.where((element) => element?.itemId == item.categoryId).first;
                  } catch (e) {
                    _logger.e(_tag, "updateItem()", message: "Category Item not found");
                    categoryItem = Item(itemId: 0, categoryId: 0);
                  }
                  final childItems = item.childItems;
                  final itemAddition = item.eItemAddition;
                  list.add(ItemData(
                    kot.userName, kot.tableName, item, categoryItem!,
                    childItems, itemAddition,),);
                  itemIds.add(item.itemId);
                }
                kot.items.removeWhere((item) => item?.itemId == itemId);
                final List<int> temp = [];
                for (final element in kot.items) {
                  if (element!.itemCategory) {
                    final categoryId = element.itemId;
                    var categoryHasItems = false;
                    // Check if there are any other items in the Kot object's items list with the same category id
                    for (int k = 0; k < kot.items.length; k++) {
                      if (kot.items[k]?.categoryId == categoryId) {
                        categoryHasItems = true;
                        break;
                      }
                    }
                    if (!categoryHasItems) {
                      temp.add(categoryId);
                    }
                  }
                }
                // Remove all items in the Kot object's items list with the same category id
                for (final categoryId in temp) {
                  kot.items.removeWhere((item) => item?.itemId == categoryId);
                  await ItemService.getInstance.updateIsPrinted(categoryId);
                }
                // Check if the Kot object's items list is now empty
                if (kot.items.isEmpty) {
                  // Remove the Kot object from the kotList
                  controller.kotList.removeWhere((p0) => p0?.id == kotId);
                  controller.removeFromSearchList(kotId);
                  await DataService.getInstance.updateIsDismissed(kotId);
                }
                controller.kotList.refresh();
              }
            }
          }
        }
        if (isLoadingDismissed) {
          break;
        }
      }
      PrinterService.getInstance.printItems(list);
      for (final element in itemIds) {
        DataService.getInstance.removeFromSummationListByItemId(element);
      }
      if (!isLoadingDismissed) {
        NavigationService.getInstance.goBack();
      }
    }
  }

  Future<List<Kot?>> getFormattedDismissedKot(int id) async {
    try {
      final List<Kot> kotCmdList = [];
      final DatabaseManager dbManager = await DatabaseHelper.getInstance;
      final EKot? eKot = await dbManager.kotDao.getSingle(id);
      if(eKot == null){
        _logger.e(_tag, "getFormattedDismissedKot()", message: "Getting empty DismissedKot");
        return kotCmdList;
      }
      kotCmdList.add(
          Kot(
            id: eKot.id,
            items: await getItems(eKot.id!),
            receivedTime: eKot.receivedTime,
            kotDismissed: eKot.kotDismissed,
            hashMD5: eKot.hashMD5,
            inSum: AppConstants.isAutoSum,
          ),
      );
      return kotCmdList;
    } catch (error) {
      _logger.e(_tag, "getFormattedDismissedKot()", message: error.toString());
      return [];
    }
  }

  Future<List<Filter>?> getUserNames() async {
    final List<Filter> filterList = [];
    List<EFKot?> list = [];
    final DatabaseManager dbManager = await DatabaseHelper.getInstance;
    list = await dbManager.fkotDao.getUserNames();
    for (final element in list) {
      filterList.add(Filter(name: element!.userName!, isSelected: false));
    }
    return filterList;
  }

  Future<List<EFKot>?> addUserNameToList(List<Kot?> kotList) async {
    final List<EFKot> list = [];
    final DatabaseManager dbManager = await DatabaseHelper.getInstance;
    for (int i = 0; i < kotList.length; i++) {
      final EFKot? eFKot = await dbManager.fkotDao.getUserNameById(kotList[i]!.id!);
      var add = true;
      for (int i = 0; i < list.length; i++) {
        if (list[i].userName == eFKot?.userName) {
          add = false;
        }
      }
      if (add) {
        list.add(eFKot!);
      }
    }
    return list;
  }

  Future<List<Filter>?> getTableNames() async {
    final List<Filter> filterList = [];
    List<EFKot?> list = [];
    final DatabaseManager dbManager = await DatabaseHelper.getInstance;
    list = await dbManager.fkotDao.getTableNames();
    for (final element in list) {
      filterList.add(Filter(name: element!.tableName!, isSelected: false));
    }
    return filterList;
  }

  Future<List<EFKot>?> addTableNameToList(List<Kot?> kotList) async {
    final List<EFKot> list = [];
    final DatabaseManager dbManager = await DatabaseHelper.getInstance;
    for (int i = 0; i < kotList.length; i++) {
      final EFKot? eFKot = await dbManager.fkotDao.getTableNameById(kotList[i]!.id!);
      var add = true;
      for (int i = 0; i < list.length; i++) {
        if (list[i].tableName == eFKot?.tableName) {
          add = false;
        }
      }
      if (add) {
        list.add(eFKot!);
      }
    }
    return list;
  }

  void filterKot() {
    Get.find<KOTController>().filterKotList();
  }

  Future<bool> removeKot(int id) async {
    try {
      final DatabaseManager dbManager = await DatabaseHelper.getInstance;
      await dbManager.kotDao.deleteById(id);
      await dbManager.fkotDao.deleteById(id);
      await dbManager.itemDao.deleteById(id);
      return true;
    } catch (e) {
      _logger.e(_tag, "removeKot", message: e.toString());
    }
    return false;
  }
}
