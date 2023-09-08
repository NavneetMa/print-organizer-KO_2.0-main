import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/db/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class KOTController extends GetxController {

  RxBool isLoading = true.obs;
  RxList<Kot?> kotList = RxList<Kot?>();
  RxBool showSnoozeList = false.obs;
  RxList<Kot?> kotDismissedList = <Kot?>[].obs;
  RxInt kotIndex = 0.obs;
  var _searchList = <Kot?>[];
  DateFormat dateFormat = DateFormat("h:mm");

  final Logger _logger = Logger.getInstance;
  final String _tag = "KOTController";
  DataService dataService = DataService.getInstance;

  KOTController();

  @override
  void onInit() {
    if (AppConstants.selectedMode == AppConstants.KITCHEN_SUM_MODE) {
      showSnoozeList.value = AppConstants.clickOfClock;
    }
    super.onInit();
  }

  Future<void> getKOTList({BuildContext? context}) async {
    try {
      isLoading(true);
      if (_searchList.isNotEmpty) _searchList.clear();
      DataService.getInstance.clearSummationList();
      final response = await dataService.getFormattedKot();
      if (response.isNotEmpty) {
        if (AppConstants.ascendingKot) {
          kotList.assignAll(response);
        } else {
          kotList.assignAll(response.reversed);
        }
        if (AppConstants.isAutoSum) {
          if (showSnoozeList.value == true) {
            for (final element in response) {
              if(element!.hideKot){
                element.inSum = true;
                dataService.autoSumAggregatedList(element.id!);
              }
            }
          } else {
            for (final element in response) {
              if (element?.hideKot == false) {
                element?.inSum = true;
                dataService.autoSumAggregatedList(element!.id!);
              }
            }
          }
        } else{
          for (final element in response) {
            element?.inSum = false;
          }
        }
      } else {
        if (showSnoozeList.value) {
          showSnoozeList.value = false;
          Get.showSnackbar(
            const GetSnackBar(
              message: 'Snooze list is empty...',
              duration: Duration(seconds: 2),
            ),
          );
        }
      }

    } catch (error) {
      _logger.e(_tag, "getKOTList()", message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<bool> addToList(Kot? kot) async {
    try {
      if (AppConstants.ascendingKot) {
        kotList.add(kot);
      } else {
        if (Get.find<KeyboardInputController>().indexInput.value != 0) {
          Get.find<KeyboardInputController>().indexInput.value++;
        }
        kotList.insert(0, kot);

      }
      if (AppConstants.isAutoSum) {
        dataService.addAggregateItems(kot!.id!, isAutoSum: AppConstants.isAutoSum, hideKot: kot.hideKot);
      }
    } catch (error) {
      _logger.e(_tag, "addToList()", message: error.toString());
    }
    return kot?.inSum ?? false;
  }

  Future<bool> addToListKitchenSumMode(Kot? kot) async {
    try {
      dataService.addAggregateItems(kot!.id!, isAutoSum: AppConstants.isAutoSum);
    } catch (error) {
      _logger.e(_tag, "addToListKitchenSumMode()", message: error.toString());
    }
    return kot?.inSum ?? false;
  }

  Future<void> removeFromList(int kotIndex) async {
    try {
      kotList.removeAt(kotIndex);
    } catch (error) {
      _logger.e(_tag, "removeFromList()", message: error.toString());
    }
  }

  Future<void> removeItemFromKot(int kotIndex,int itemId) async {
    try {
      final int id=kotList[kotIndex]!.id!;
      final DatabaseManager dbManager = await DatabaseHelper.getInstance;
      final EKot? eKot = await dbManager.kotDao.getSingle(id);
      await dbManager.kotDao.updateTableNameMatch(id,false);
      eKot?.receivedTime = DateTime.now().toString();
      kotList[kotIndex]!.items.removeWhere((element) => element!.itemId == itemId);
      kotList[kotIndex]!.tableNameMatch = false;
      kotList[kotIndex]!.receivedTime=eKot?.receivedTime;
      await dbManager.kotDao.updateReceivedTime(id, eKot!.receivedTime);
      kotList.refresh();
    } catch (error) {
      _logger.e(_tag, "removeItemFromKot()", message: error.toString());
    }
  }

  Future<void> removeCategoryItemFromKot(int kotIndex,int cItemId) async {
    try {
      kotList[kotIndex]!.items.removeWhere((element) => element!.itemId == cItemId);
      kotList.refresh();
    } catch (error) {
      _logger.e(_tag, "removeCategoryItemFromKot()", message: error.toString());
    }
  }

  Future<void> searchFromList(String query) async {
    try {
      if (_searchList.isEmpty) _searchList = kotList.toList();
      if (_searchList.isNotEmpty) {
        isLoading(true);
        kotList.clear();
        for (final kot in _searchList) {
          bool searchItem = false;
          for (int i = 0; i < kot!.items.length; i++) {
            if(kot.items[i]!.item.toString().toLowerCase().contains(query.toLowerCase())
                || kot.userName.toLowerCase().contains(query.toLowerCase()) || kot.tableName.toLowerCase().contains(query.toLowerCase())) {
              searchItem = true;
            }
            if (searchItem) break;
          }
          if (searchItem) kotList.add(kot);
        }
      }
    } catch (error) {
      _logger.e(_tag, "searchFromList()", message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  void removeFromSearchList(int kotId) {
    if (_searchList.isNotEmpty) {
      _searchList.removeWhere((element) => element?.id == kotId);
    }
  }

  void removeItemFromSearchList(int kotId, int itemId) {
    if (_searchList.isNotEmpty) {
      _searchList.where((element) {
        if(element!.id! == kotId) {
          element.items.removeWhere((item) => item!.itemId == itemId);
        }
        return true;
      });
    }
  }

  void removeCategoryItemFromSearchList(int kotId, int itemId) {
    if (_searchList.isNotEmpty) {
      _searchList.where((element) {
        if(element!.id! == kotId) {
          element.items.removeWhere((item) => item!.categoryId == itemId);
        }
        return true;
      });
    }
  }

  Future<void> filterKotList() async {
    try {
      if (_searchList.isEmpty) _searchList = kotList.toList();
      if (_searchList.isNotEmpty) {
        isLoading(true);
        kotList.clear();
        for (final kot in _searchList) {
          final List<String> filterUser = [];
          final List<String> filterTable = [];
          List<String> filterUserAndTable = [];

          Get.find<FilterController>().tableNames.forEach((element) {
            if(element.isSelected){
              filterTable.add(element.name);
            }
          });
          Get.find<FilterController>().userNames.forEach((element) {
            if(element.isSelected) {
              filterUser.add(element.name);
            }
          });

          if(filterUser.isNotEmpty && filterTable.isNotEmpty) {
            for (final element in filterUser) {
              if(kot!.userName==element){
                for (final element in filterTable) {
                  if(kot.tableName==element) {
                    if (!kotList.contains(kot)) {
                      kotList.add(kot);
                    }
                  }
                }
              }
            }
            if (filterUser.isEmpty && filterTable.isEmpty) {
              kotList.clear();
              kotList.assignAll(_searchList);
            }
          } else {
            filterUserAndTable = [...filterUser, ...filterTable];
            for (final element in filterUserAndTable) {
              if(kot!.userName==element || kot.tableName==element){
                if(!kotList.contains(kot)){
                  kotList.add(kot);
                }
              }
            }
            if (filterUserAndTable.isEmpty) {
              kotList.clear();
              kotList.assignAll(_searchList);
            }
          }
        }
      }
    } catch (error) {
      _logger.e(_tag, "filterKotList()", message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> addDismissedKot(Kot? kot) async {
    kot?.inSum = false;
    kotDismissedList.add(kot);
    if (kotDismissedList.length > 5) {
      final Kot? oldKot=kotDismissedList.removeAt(0);
      await KitchenModeApi.getInstance.deleteKot([oldKot!.hashMD5!]);
      DataService.getInstance.removeKot(oldKot.id!);
    }
  }

  Kot? removeDismissedKotOnUndoKitchenSumMode(){
    Kot? kot;
    if(kotDismissedList.isNotEmpty){
      kot= kotDismissedList.removeLast();
      kotDismissedList.add(kot);
      return kot;
    }
     return kot;
  }

  Kot? removeDismissedKotOnUndo(){
    Kot? kot;
    if(kotDismissedList.isNotEmpty) {
      kot = kotDismissedList.removeLast();
      if(kot != null) {
        addToList(kot);
        Get.find<FilterController>().getFilter();
      }
    }
    return kot;
  }

  @override
  void onClose() {
    kotList.clear();
    _searchList.clear();
    super.onClose();
  }
}
