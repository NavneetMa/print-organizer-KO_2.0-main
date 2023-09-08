import 'dart:async';

import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class FilterController extends GetxController {

  final Logger _logger = Logger.getInstance;
  final String _tag = "FilterController";
  RxList<Filter> userNames = <Filter>[].obs;
  RxList<Filter> tableNames = <Filter>[].obs;

  FilterController();

  @override
  void onInit() {
    getFilter();
    super.onInit();
  }

  Future<void> getFilter() async {
    if(userNames.isNotEmpty) {
      await DataService.getInstance.getUserNames().then((value){
        userNames.retainWhere((element) => element.isSelected == true);
        for (final element in userNames) {
          value?.map((e){
            if(e.name==element.name){
              e.isSelected = element.isSelected;
            }
          }).toList();
        }
        userNames(value);
      });
    }else{
      userNames(await DataService.getInstance.getUserNames());
    }
    if(tableNames.isNotEmpty) {
      await DataService.getInstance.getTableNames().then((value){
        tableNames.retainWhere((element) => element.isSelected == true);
        for (final element in tableNames) {
          value?.map((e){
            if(e.name==element.name){
              e.isSelected = element.isSelected;
            }
          }).toList();
        }
        tableNames(value);
      });
    }else{
      tableNames(await DataService.getInstance.getTableNames());
    }
  }

  void addUserNames(Filter filter) {
    var hasUserName=false;
    for(int i=0;i<userNames.length;i++){
      if(userNames[i].name==filter.name){
        hasUserName=true;
        break;
      }
    }
    if(!hasUserName){
      userNames.add(filter);
    }
  }

  void addTableNames(Filter filter) {
    var hasTableName=false;
    for(int i=0;i<tableNames.length;i++){
      if(tableNames[i].name==filter.name){
        hasTableName=true;
        break;
      }
    }
    if(!hasTableName){
      tableNames.add(filter);
    }
  }

  Future<bool> resetFilter() async {
    try{
      if(Get.find<KOTController>().kotList.isNotEmpty){
        final List<Filter>? userNamesF = await DataService.getInstance.getUserNames();
        for(int j = 0; j < userNames.length; j++){
          bool found = false;
          for(int i = 0; i < userNamesF!.length; i++){
            if(userNamesF[i].name==userNames[j].name){
              found = true;
              break;
            }
          }
          if (!found) {
            userNames.removeAt(j);
          }
        }

        final List<Filter>? tableNamesF = await DataService.getInstance.getTableNames();
        for (int j = 0; j < tableNames.length; j++) {
          bool found = false;
          for (int i = 0; i < tableNamesF!.length; i++) {
            if (tableNamesF[i].name == tableNames[j].name) {
              found = true;
            }
          }
          if (!found) {
            tableNames.removeAt(j);
          }
        }

        Timer(const Duration(seconds: 5), () async {
          userNames(await DataService.getInstance.getUserNames());
          tableNames(await DataService.getInstance.getTableNames());
          //Get.find<KOTController>().getKOTList();
        });
      } else {
        userNames.clear();
        tableNames.clear();
        userNames(await DataService.getInstance.getUserNames());
        tableNames(await DataService.getInstance.getTableNames());
        //Get.find<KOTController>().getKOTList();
      }
    }catch(e){
      _logger.e(_tag, "resetFilter()", message: e.toString());
    }
    return true;
  }


}
