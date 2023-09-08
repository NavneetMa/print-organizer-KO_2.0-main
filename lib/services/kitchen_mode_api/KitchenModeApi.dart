import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:kwantapo/data/ResCode.dart';
import 'package:kwantapo/data/dto/Res.dart';
import 'package:kwantapo/data/dto/SnoozeKot.dart';
import 'package:kwantapo/data/entities/EKot.dart';
import 'package:kwantapo/db/DatabaseHelper.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/sync/lib.dart';
import 'package:kwantapo/utils/Logger.dart';
import 'package:kwantapo/utils/PrefUtils.dart';

class KitchenModeApi {

  static KitchenModeApi? _instance;

  factory KitchenModeApi() => getInstance;

  KitchenModeApi._();

  static KitchenModeApi get getInstance {
    _instance ??= KitchenModeApi._();
    return _instance!;
  }

  final String _tag = "KitchenModeApi";
  String _ipAddress = "";
  String _port = "";
  final Logger _logger = Logger.getInstance;
  void configureChannel() {
    const MethodChannel('com.kitchen_mode_api').setMethodCallHandler(methodHandler);
  }

  Future<String> methodHandler(MethodCall call) async {
    final res = await receivedData(call.method, call.arguments.toString());
    return res;
  }

  Future<String> receivedData(String methodName, String jsonData) async {
    Res? res;
    try {
      switch (methodName) {
        case "getAllKotData":
          res = await getUnDismissedKot();
          return jsonEncode(res).toString();
        case "getSnoozedKotData":
          res = await getSnoozedKot();
          return jsonEncode(res).toString();
      }
    } catch (e) {
      _logger.e(_tag, "receivedData()", message: e.toString());
    }
    return jsonEncode(res).toString();
  }
  Future<Res> getSnoozedKot() async{
    final Res res = Res(ResCode().failed, "No Response","");
    try{
      var kotList =await  DataService.getInstance.getSnoozedKotForKitchenSumMode();
      return Res(ResCode().success, "",jsonEncode(kotList));
    } catch (error){
      _logger.e(_tag, "getSnoozedKot()", message: error.toString());
    }
    return res;
  }

  Future<Res> getUnDismissedKot() async{
    final Res res = Res(ResCode().failed, "No Response","");
    try{
      var kotList =await  DataService.getInstance.getUnDismissedKot();
      return Res(ResCode().success, "",jsonEncode(kotList));
    } catch (error){
      _logger.e(_tag, "getUnDismissedKot()", message: error.toString());
    }
    return res;
  }


  Future<bool> setIpAndPortOfKitchenSumMode() async {
    try {
      _ipAddress = await PrefUtils().getKitchenSumModeIpAddress();
      _port = await PrefUtils().getKitchenSumModePort();
      if(_port!="" && _ipAddress!="" && _ipAddress!="0.0.0.0"){
        return true;
      }else {
        return false;
      }
    } catch (e) {
      _logger.e(_tag, "_setIpAndPortOfKitchenSumMode()", message: e.toString());
    }
    return false;
  }


  Future<Res> sendKotToKitchenSumMode(EKot eKot) async {
    try {
      if(!await setIpAndPortOfKitchenSumMode()){
        return Res(ResCode().ipNotFound, "IP address not found.","");
      }
      try {
        Map<String, dynamic> map = Map();
        map['methodName'] = "kot";
        map['data'] = jsonEncode(eKot);
        map['ipAddress'] = _ipAddress;
        final result = await SyncCommunication().sendKotToKitchenSumMode(map);
        _logger.e(_tag, "sendKotToKitchenSumMode()", message: "Result:-  ${result.toString()}");
        Res resultCode = Res.fromJson(result as Map<String, dynamic>);
        return resultCode;
      } catch (e) {
        _logger.e(_tag, "sendKotToKitchenSumMode() - platform.invokeMethod()", message: e.toString());
      }
    } catch (e) {
      _logger.e(_tag, "sendKotToKitchenSumMode()", message: e.toString());
    }
    return Res(ResCode().failed, "Something went wrong","");
  }


  Future<Res> hideKotOnKOTSnoozeTimeAdded(List<String> kotHash) async {
    try {
      if(!await setIpAndPortOfKitchenSumMode()){
        return Res(ResCode().ipNotFound, "IP address not found.","");
      }
      try {
        final snoozeKot = await getKotByHash(kotHash[0]);
        Map<String, dynamic> map = Map();
        map['methodName'] = "hideKotOnKOTSnoozeTimeAdded";
        map['data'] = jsonEncode(snoozeKot);
        map['ipAddress'] = _ipAddress;
        SnoozeTimeService.getInstance.iLoadingDialog.showLoadingDialog("Loading");
        final result = await SyncCommunication().hideKotOnKOTSnoozeTimeAdded(map);
        NavigationService.getInstance.goBack();
        _logger.e(_tag, "hideKotOnKOTSnoozeTimeAdded()", message: "Result:-  ${result.toString()}");
        Res resultCode = Res.fromJson(result as Map<String, dynamic>);
        return resultCode;
      } catch (e) {
        _logger.e(_tag, "hideKotOnKOTSnoozeTimeAdded() - platform.invokeMethod()", message: e.toString());
      }
    } catch (e) {
      _logger.e(_tag, "hideKotOnKOTSnoozeTimeAdded()", message: e.toString());
    }
    return Res(ResCode().failed, "Something went wrong","");
  }


  Future<SnoozeKot?> getKotByHash(String hashMD5) async{
    try {
      final dbManager = await DatabaseHelper.getInstance;
      final eKot = await dbManager.kotDao.getKotByHashMD5(hashMD5);
      if(eKot!=null) {
        return SnoozeKot(eKot.snoozeDateTime, eKot.hashMD5);
      }
    } catch (e) {
      _logger.e(_tag, "getKotByHash()", message: e.toString());
    }
    return null;
  }


  Future<Res> resetHiddenKot(List<String> kotHash) async {
    try {
      if(!await setIpAndPortOfKitchenSumMode()){
        return Res(ResCode().ipNotFound, "IP address not found.","");
      }
      try {
        Map<String, dynamic> map = Map();
        map['methodName'] = "resetHiddenKot";
        map['data'] = jsonEncode(kotHash);
        map['ipAddress'] = _ipAddress;
        SnoozeTimeService.getInstance.iLoadingDialog.showLoadingDialog("Loading");
        final result = await SyncCommunication().resetHiddenKot(map);
        NavigationService.getInstance.goBack();
        _logger.e(_tag, "resetHiddenKot()", message: "Result:-  ${result.toString()}");
        Res resultCode = Res.fromJson(result as Map<String, dynamic>);
        return resultCode;
      } catch (e) {
        _logger.e(_tag, "resetHiddenKot() - platform.invokeMethod()", message: e.toString());
      }
    } catch (e) {
      _logger.e(_tag, "resetHiddenKot()", message: e.toString());
    }
    return Res(ResCode().failed, "Something went wrong","");
  }


  Future<Res> showKotAfterSnoozeTimeIsOver(List<String> kotHash) async {
    try {
      if(!await setIpAndPortOfKitchenSumMode()){
        return Res(ResCode().ipNotFound, "IP address not found.","");
      }
      try {
        Map<String, dynamic> map = Map();
        map['methodName'] = "showKotAfterSnoozeTimeIsOver";
        map['data'] = jsonEncode(kotHash);
        map['ipAddress'] = _ipAddress;
        final result = await SyncCommunication().showKotAfterSnoozeTimeIsOver(map);
        _logger.e(_tag, "showKotAfterSnoozeTimeIsOver()", message: "Result:-  ${result.toString()}");
        Res resultCode = Res.fromJson(result as Map<String, dynamic>);
        return resultCode;
      } catch (e) {
        _logger.e(_tag, "showKotAfterSnoozeTimeIsOver() - platform.invokeMethod()", message: e.toString());
      }
    } catch (e) {
      _logger.e(_tag, "showKotAfterSnoozeTimeIsOver()", message: e.toString());
    }
    return Res(ResCode().failed, "Something went wrong","");
  }



  Future<Res> removeItemFromSum(List<String> kotHash) async {
    try {
      if(!await setIpAndPortOfKitchenSumMode()){
        return Res(ResCode().ipNotFound, "IP address not found.","");
      }
      try {
        Map<String, dynamic> map = Map();
        map['methodName'] = "removeItemFromSum";
        map['data'] = jsonEncode(kotHash); 
        map['ipAddress'] = _ipAddress;
        DataService.getInstance.iLoadingDialog.showLoadingDialog("Loading");
        final result = await SyncCommunication().removeItemFromSum(map);
        NavigationService.getInstance.goBack();
        _logger.e(_tag, "removeItemFromSum()", message: "Result:-  ${result.toString()}");
        Res resultCode = Res.fromJson(result as Map<String, dynamic>);
        return resultCode;
      } catch (e) {
        _logger.e(_tag, "removeItemFromSum() - platform.invokeMethod()", message: e.toString());
      }
    } catch (e) {
      _logger.e(_tag, "removeItemFromSum()", message: e.toString());
    }
    return Res(ResCode().failed, "Something went wrong","");
  }

  Future<Res> removeItemFromKot(List<String> kotHash) async {
    try {
      if(!await setIpAndPortOfKitchenSumMode()){
        return Res(ResCode().ipNotFound, "IP address not found.","");
      }
      try {
        Map<String, dynamic> map = Map();
        map['methodName'] = "removeItemFromKot";
        map['data'] = jsonEncode(kotHash);
        map['ipAddress'] = _ipAddress;
        DataService.getInstance.iLoadingDialog.showLoadingDialog("Loading");
        final result = await SyncCommunication().removeItemFromKot(map);
        _logger.e(_tag, "removeItemFromKot()", message: "Result:-  ${result.toString()}");
        NavigationService.getInstance.goBack();
        Res resultCode = Res.fromJson(result as Map<String, dynamic>);
        return resultCode;
      } catch (e) {
        _logger.e(_tag, "removeItemFromKot() - platform.invokeMethod()", message: e.toString());
      }
    } catch (e) {
      _logger.e(_tag, "removeItemFromKot()", message: e.toString());
    }
    return Res(ResCode().failed, "Something went wrong","");
  }

  Future<Res> deleteKot(List<String> kotHash) async {
    try {
      if(!await setIpAndPortOfKitchenSumMode()){
        return Res(ResCode().ipNotFound, "IP address not found.","");
      }
      try {
        Map<String, dynamic> map = Map();
        map['methodName'] = "deleteKot";
        map['data'] = jsonEncode(kotHash);
        map['ipAddress'] = _ipAddress;
        final result = await SyncCommunication().deleteKot(map);
        return Res.fromJson(result as Map<String, dynamic>);
      } catch (e) {
        _logger.e(_tag, "deleteKot() - platform.invokeMethod()", message: e.toString());
      }
    } catch (e) {
      _logger.e(_tag, "deleteKot()", message: e.toString());
    }
    return Res(ResCode().failed, "Something went wrong","");
  }

  Future<Res> dismissKot(List<String> kotHash) async {
    try {
      if(!await setIpAndPortOfKitchenSumMode()){
        return Res(ResCode().ipNotFound, "IP address not found.","");
      }
      try {
        Map<String, dynamic> map = Map();
        map['methodName'] = "dismissKot";
        map['data'] = jsonEncode(kotHash);
        map['ipAddress'] = _ipAddress;
        DataService.getInstance.iLoadingDialog.showLoadingDialog("Loading");
        final result = await SyncCommunication().dismissKot(map);
        NavigationService.getInstance.goBack();
        return Res.fromJson(result as Map<String, dynamic>);
      } catch (e) {
        _logger.e(_tag, "dismissKot() - platform.invokeMethod()", message: e.toString());
      }
    } catch (e) {
      _logger.e(_tag, "dismissKot()", message: e.toString());
    }
    return Res(ResCode().failed, "Something went wrong","");
  }

  Future<Res> addUndoKotItem(List<String> kotHash) async {
    try {
      if(!await setIpAndPortOfKitchenSumMode()){
        return Res(ResCode().ipNotFound, "IP address not found.","");
      }
      try {
        Map<String, dynamic> map = Map();
        map['methodName'] = "addUndoKotItem";
        map['data'] = jsonEncode(kotHash);
        map['ipAddress'] = _ipAddress;
        DataService.getInstance.iLoadingDialog.showLoadingDialog("Loading");
        final result = await SyncCommunication().addUndoKotItem(map);
        NavigationService.getInstance.goBack();
        _logger.e(_tag, "addUndoKotItem()", message: "Result:-  ${result.toString()}");
        Res resultCode = Res.fromJson(result as Map<String, dynamic>);
        return resultCode;
      } catch (e) {
        _logger.e(_tag, "addUndoKotItem() - platform.invokeMethod()", message: e.toString());
      }
    } catch (e) {
      _logger.e(_tag, "addUndoKotItem", message: e.toString());
    }
    return Res(ResCode().failed, "Something went wrong","");
  }


}
