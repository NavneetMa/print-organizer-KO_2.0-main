import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:kwantapo/data/ResCode.dart';
import 'package:kwantapo/data/dto/Res.dart';
import 'package:kwantapo/data/dto/SnoozeKot.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/db/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/sync/lib.dart';
import 'package:kwantapo/ui/activities/kitchen_sum_mode/interfaces/IKitchenSMDActivity.dart';
import 'package:kwantapo/ui/interfaces/IMessageDialog.dart';
import 'package:kwantapo/utils/AppConstants.dart';
import 'package:kwantapo/utils/Logger.dart';
import 'package:kwantapo/utils/PrefUtils.dart';

class KitchenSumModeAPI {
  static KitchenSumModeAPI? _instance;

  factory KitchenSumModeAPI() => getInstance;

  KitchenSumModeAPI._();

  static KitchenSumModeAPI get getInstance {
    _instance ??= KitchenSumModeAPI._();
    return _instance!;
  }

  final String _tag = "KitchenSumModeAPI";
  String _ipAddress = "";
  String _port = "";
  bool snoozeList = false;
  late IMessageDialog iMessageDialog;
  late IKitchenSMDActivity iKitchenSMDActivity;
  final Logger _logger = Logger.getInstance;

  void setMessageDialog(IMessageDialog iMessageDialog) {
    this.iMessageDialog = iMessageDialog;
  }

  void setIKitchenSMDActivity(IKitchenSMDActivity iKitchenSMDActivity) {
    this.iKitchenSMDActivity = iKitchenSMDActivity;
  }

  void configureChannel() {
    const MethodChannel('com.kitchen_sum_mode_api').setMethodCallHandler(methodHandler);
  }

  Future<bool> setIpAndPortOfKitchenMode() async {
    try {
      _ipAddress = await PrefUtils().getKitchenModeIpAddress();
      _port = await PrefUtils().getKitchenModePort();
      if (_port != "" && _ipAddress != "" && _ipAddress != "0.0.0.0") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _logger.e(_tag, "_setIpAndPortOfKitchenSumMode()", message: e.toString());
    }
    return false;
  }

  Future<void> getAllKotData() async {
    try {
      if (!await setIpAndPortOfKitchenMode()) {
        iMessageDialog.showMessageDialog(
            "Alert", "Kitchen Mode IP Address is empty",);
        return;
      }
      try {
        Map<String, dynamic> map = Map();
        map['methodName'] = "getAllKotData";
        map['ipAddress'] = _ipAddress;
        final result = await SyncCommunication().getAllKotData(map);
        _logger.e(_tag, "getAllKotData()", message: "Result:-  ${result.toString()}");
        Res resultCode = Res.fromJson(result as Map<String, dynamic>);
        if (resultCode.code == ResCode().success) {
          final jsonData = jsonDecode(resultCode.data) as List<dynamic>;
          final dbManager = await DatabaseHelper.getInstance;
          await dbManager.kotDao.delete();
          await dbManager.fkotDao.delete();
          await dbManager.itemDao.delete();
          await dbManager.childItemDao.delete();
          await dbManager.itemAdditionDao.delete();
          DataService.getInstance.clearSummationList();

          for (final temp in jsonData) {
            EKot eKot = EKot(
              kot: temp['kot'].toString(),
              kotDismissed: temp['kotDismissed'] as int,
              receivedTime: temp['receivedTime'].toString(),
              hashMD5: temp['hashMD5'].toString(),
              snoozeDateTime: temp['snoozeDateTime'].toString(),
              fKotWithSeparator: temp['fKotWithSeparator'].toString(),
              hideKot: temp['hideKot'] as bool,
            );
            final dbManager = await DatabaseHelper.getInstance;
            if (await dbManager.kotDao.getKotByHashMD5(eKot.hashMD5) == null) {
              await DataService.getInstance.addKotInKitchenSumMode(eKot, jsonDecode(eKot.fKotWithSeparator) as Map<String, dynamic>);
              if (iKitchenSMDActivity.isGroupView()) {
                iKitchenSMDActivity.setGroupViewData();
              }
            }

          }
        }
      } catch (e) {
        _logger.e(_tag, "getAllKotData() - ip address", message: e.toString());
      }
    } catch (e) {
      _logger.e(_tag, "getAllKotData()", message: e.toString());
    }
  }

  Future<void> getSnoozedKotData() async {
    try {
      if (!await setIpAndPortOfKitchenMode()) {
        iMessageDialog.showMessageDialog(
            "Alert", "Kitchen Mode IP Address is empty",);
        return;
      }
      try {
        Map<String, dynamic> map = Map();
        map['methodName'] = "getSnoozedKotData";
        map['ipAddress'] = _ipAddress;
        final result = await SyncCommunication().getSnoozedKotData(map);
        _logger.e(_tag, "getSnoozedKotData()", message: "Result:-  ${result.toString()}");
        Res resultCode = Res.fromJson(result as Map<String, dynamic>);
        if (resultCode.code == ResCode().success) {
          final jsonData = jsonDecode(resultCode.data) as List<dynamic>;
          DataService.getInstance.clearSummationList();

          for (final temp in jsonData) {
            EKot eKot = EKot(
              kot: temp['kot'].toString(),
              kotDismissed: temp['kotDismissed'] as int,
              receivedTime: temp['receivedTime'].toString(),
              hashMD5: temp['hashMD5'].toString(),
              snoozeDateTime: temp['snoozeDateTime'].toString(),
              fKotWithSeparator: temp['fKotWithSeparator'].toString(),
              hideKot: temp['hideKot'] as bool,
            );
            final dbManager = await DatabaseHelper.getInstance;
            await dbManager.kotDao.deleteByHash(eKot.hashMD5);
            if (await dbManager.kotDao.getKotByHashMD5(eKot.hashMD5) == null) {
              await DataService.getInstance.addKotInKitchenSumModeForClickOfClock(eKot, jsonDecode(eKot.fKotWithSeparator) as Map<String, dynamic>);
              if (iKitchenSMDActivity.isGroupView()) {
                iKitchenSMDActivity.showSnoozedDataClicked();
              }
            }
          }
        }
      } catch (e) {
        _logger.e(_tag, "getSnoozedKotData() - ip address", message: e.toString());
      }
    } catch (e) {
      _logger.e(_tag, "getSnoozedKotData()", message: e.toString());
    }
  }

  Future<String> methodHandler(MethodCall call) async {
    final res = await receivedData(call.method, call.arguments.toString());
    return res;
  }

  Future<String> receivedData(String methodName, String jsonData) async {
    Res? res;
    try {
      switch (methodName) {
        case "dismissKot":
          final data = jsonDecode(jsonData);
          res = await dismissKot(getHashList(data));
          return jsonEncode(res).toString();
        case "kot":
          final eKotObject = jsonDecode(jsonData);
          res = await getEKot(eKotObject as Map<String, dynamic>);
          return jsonEncode(res).toString();
        case "hideKotOnKOTSnoozeTimeAdded":
          final data = jsonDecode(jsonData);
          res = await hideKotOnKOTSnoozeTimeAdded(data as Map<String, dynamic>);
          return jsonEncode(res).toString();
        case "resetHiddenKot":
          final data = jsonDecode(jsonData);
          res = await resetHiddenKot(getHashList(data));
          return jsonEncode(res).toString();
        case "showKotAfterSnoozeTimeIsOver":
          final data = jsonDecode(jsonData);
          res = await showKotAfterSnoozeTimeIsOver(getHashList(data));
          return jsonEncode(res).toString();
        case "removeItemFromSum":
          final data = jsonDecode(jsonData);
          res = await removeItemFromSum(getHashList(data));
          return jsonEncode(res).toString();
        case "deleteKot":
          final data = jsonDecode(jsonData);
          res = await deleteKot(getHashList(data));
          return jsonEncode(res).toString();
        case "removeItemFromKot":
          final data = jsonDecode(jsonData);
          res = await removeItemFromKot(getHashList(data));
          return jsonEncode(res).toString();
        case "addUndoKotItem":
          final data = jsonDecode(jsonData);
          res = await addUndoKotItem(getHashList(data));
          return jsonEncode(res).toString();
      }
    } catch (e) {
      _logger.e(_tag, "receivedData()", message: e.toString());
    }
    return jsonEncode(res).toString();
  }

  List<String> getHashList(dynamic jsonData) {
    final List<String> hashList = [];
    try {
      final data = jsonData as List<dynamic>;
      data.forEach((value) {
        hashList.add(value.toString());
      });
    } catch (e) {
      _logger.e(_tag, "getHashList()", message: e.toString());
    }
    return hashList;
  }

  Future<Res> deleteKot(List<String> data) async{
    final Res res = Res(ResCode().failed, "No Response", "");
    try {
      if (data.isNotEmpty) {
        final dbManager = await DatabaseHelper.getInstance;
        for (final value in data) {
          int? id = await dbManager.kotDao.getIdByHashMD5(value);
          DataService.getInstance.removeKot(id!);
        }
        return Res(ResCode().success, "", "");
      }
    } catch (e) {
      _logger.e(_tag, "showKotAfterSnoozeTimeIsOver()", message: e.toString());
    }
    return res;
  }

  Future<Res> hideKotOnKOTSnoozeTimeAdded(dynamic data) async {
    final Res res = Res(ResCode().failed, "No Response", "");
    try {
      final dbManager = await DatabaseHelper.getInstance;
      final snoozeKot = SnoozeKot.fromJson(data as Map<String, dynamic>);
      await dbManager.kotDao.updateSnoozeDateTimeByHash(snoozeKot.hashMD5, snoozeKot.snoozeDateTime);
      await dbManager.kotDao.updateHideKotByHash(snoozeKot.hashMD5, true);
      final kot = await dbManager.kotDao.getKotByHashMD5(snoozeKot.hashMD5);
      if (AppConstants.clickOfClock) {
        await DataService.getInstance.addAggregateItems(kot!.id!, isAutoSum: true);
      } else {
        await DataService.getInstance.removeFromSummationList(kot!.id!);
      }
      iKitchenSMDActivity.refreshGroupViewData();
      return Res(ResCode().success, "", "");
    } catch (e) {
      _logger.e(_tag, "hideKotOnKOTSnoozeTimeAdded()", message: e.toString());
    }
    return res;
  }

  Future<Res> resetHiddenKot(List<String> data) async {
    final Res res = Res(ResCode().failed, "No Response", "");
    try {
      final dbManager = await DatabaseHelper.getInstance;
      if (data.isNotEmpty) {
        for (final value in data) {
          await dbManager.kotDao.updateSnoozeDateTimeByHash(value, DateTime.now().toString());
          await dbManager.kotDao.updateHideKotByHash(value, false);
          final kot = await dbManager.kotDao.getKotByHashMD5(value);
          if (!AppConstants.clickOfClock) {
            await DataService.getInstance.addAggregateItems(kot!.id!, isAutoSum: true);
          } else {
            await DataService.getInstance.removeFromSummationList(kot!.id!);
          }
        }
        iKitchenSMDActivity.refreshGroupViewData();
        return Res(ResCode().success, "", "");
      }
    } catch (e) {
      _logger.e(_tag, "resetHiddenKot()", message: e.toString());
    }
    return res;
  }

  Future<Res> showKotAfterSnoozeTimeIsOver(List<String> data) async {
    final Res res = Res(ResCode().failed, "No Response", "");
    try {
      if (data.isNotEmpty) {
        final dbManager = await DatabaseHelper.getInstance;
        for (final value in data) {
          await dbManager.kotDao.updateSnoozeDateTimeByHash(value, DateTime.now().toString());
          await dbManager.kotDao.updateHideKotByHash(value, false);
          final kot = await dbManager.kotDao.getKotByHashMD5(value);
          if (kot != null) {
            if (!AppConstants.clickOfClock) {
              await DataService.getInstance.addAggregateItems(kot.id!, isAutoSum: true);
            } else {
              await DataService.getInstance.removeFromSummationList(kot.id!);
            }
          }
        }
        iKitchenSMDActivity.refreshGroupViewData();
        return Res(ResCode().success, "", "");
      }
    } catch (e) {
      _logger.e(_tag, "showKotAfterSnoozeTimeIsOver()", message: e.toString());
    }
    return res;
  }

  Future<Res> dismissKot(List<String> data) async {
    final Res res = Res(ResCode().failed, "No Response", "");
    try {
      if (data.isNotEmpty) {
        final dbManager = await DatabaseHelper.getInstance;
        for (final value in data) {
          await dbManager.kotDao.updateIsDismissedByHash(value, 1);
          final kot = await dbManager.kotDao.getKotByHashMD5(value);
          await DataService.getInstance.removeFromSummationList(kot!.id!);
        }
        iKitchenSMDActivity.refreshGroupViewData();
        return Res(ResCode().success, "", "");
      }
    } catch (e) {
      _logger.e(_tag, "dismissKot()", message: e.toString());
    }
    return res;
  }

  Future<Res> getEKot(Map<String, dynamic> eKotJson) async {
    final Res res = Res(ResCode().failed, "No Response", "");
    try {
      final eKot = EKot(
        kot: eKotJson['kot'].toString(),
        kotDismissed: eKotJson['kotDismissed'] as int,
        receivedTime: eKotJson['receivedTime'].toString(),
        hashMD5: eKotJson['hashMD5'].toString(),
        snoozeDateTime: eKotJson['snoozeDateTime'].toString(),
        fKotWithSeparator: eKotJson['fKotWithSeparator'].toString(),
      );
      final dbManager = await DatabaseHelper.getInstance;
      if (await dbManager.kotDao.getKotByHashMD5(eKot.hashMD5) == null) {
         await DataService.getInstance.addKotInKitchenSumMode(eKot, jsonDecode(eKot.fKotWithSeparator) as Map<String, dynamic>);
      }
      if (iKitchenSMDActivity.isGroupView()) {
         iKitchenSMDActivity.setGroupViewData();
      }
      return Res(ResCode().success, "", "");
    } catch (e) {
      _logger.e(_tag, "getEKot()", message: e.toString());
    }
    return res;
  }

  Future<Res> addUndoKotItem(List<String> data) async {
    final Res res = Res(ResCode().failed, "No Response", "");
    try {
      final dbManager = await DatabaseHelper.getInstance;
      if (data.isNotEmpty) {
        for (final value in data) {
          await dbManager.itemDao.updateItemIsPrintedByItemHash(value, false);
          await dbManager.kotDao.updateIsDismissedByHash(value, 0);
          final kot = await dbManager.kotDao.getKotByHashMD5(value);
          if (kot != null) {
            await DataService.getInstance.addAggregateItems(kot.id!, kot: kot, isAutoSum: true);
            iKitchenSMDActivity.addUndoKotGroupView(kot.id!);
          }
        }
      }
      return Res(ResCode().success, "", "");
    } catch (e) {
      _logger.e(_tag, "addUndoKotItem()", message: e.toString());
    }
    return res;
  }

  Future<Res> removeItemFromSum(List<String> data) async {
    final Res res = Res(ResCode().failed, "No Response", "");
    try {
      final dbManager = await DatabaseHelper.getInstance;
      if (data.isNotEmpty) {
        _logger.e(_tag, "removeItemFromSum() jsonEncode(data)", message: jsonEncode(data));
        for (final value in data) {
          final int itemId = await dbManager.itemDao.getItemIdByHash(value) ?? 0;
          await dbManager.itemDao.updateIsPrintedByItemHash(value);
          await DataService.getInstance.removeFromSummationListByItemId(itemId);
        }
        iKitchenSMDActivity.refreshGroupViewData();
        return Res(ResCode().success, "", "");
      }
    } catch (e) {
      _logger.e(_tag, "removeItemFromSum()", message: e.toString());
    }
    return res;
  }

  Future<Res> removeItemFromKot(List<String> data) async {
    final Res res = Res(ResCode().failed, "No Response", "");
    try {
      final dbManager = await DatabaseHelper.getInstance;
      if (data.isNotEmpty) {
        for (final value in data) {
          final int itemId = await dbManager.itemDao.getItemIdByHash(value) ?? 0;
          await dbManager.itemDao.updateIsPrintedByItemHash(value);
          await DataService.getInstance.removeFromSummationListByItemId(itemId);
        }
        iKitchenSMDActivity.refreshGroupViewData();
        return Res(ResCode().success, "", "");
      }
    } catch (e) {
      _logger.e(_tag, "removeItemFromKot()", message: e.toString());
    }
    return res;
  }
}
