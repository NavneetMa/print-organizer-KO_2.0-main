import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:kwantapo/data/dto/SnoozeKot.dart';
import 'package:kwantapo/data/entities/EKot.dart';
import 'package:kwantapo/db/DatabaseHelper.dart';
import 'package:kwantapo/utils/Logger.dart';
import 'package:kwantapo/utils/PrefUtils.dart';

class KitchenModeMethodChannelApi {

  static KitchenModeMethodChannelApi? _instance;

  factory KitchenModeMethodChannelApi() => getInstance;

  KitchenModeMethodChannelApi._();

  static KitchenModeMethodChannelApi get getInstance {
    _instance ??= KitchenModeMethodChannelApi._();
    return _instance!;
  }
  String _ipAddress = "";
  String _port = "";

  final String _tag = "KitchenModeApi";
  final Logger _logger = Logger.getInstance;
  static const platform = MethodChannel('samples.flutter.dev/response');

  Future<void> _setIpAndPortOfKitchenSumMode() async {
    try {
      await PrefUtils().getKitchenSumModeIpAddress().then((kSumModeIpAddress) {
        _ipAddress = kSumModeIpAddress!;
      });
      await PrefUtils().getKitchenSumModePort().then((kSumModePort) {
        _port = kSumModePort!;
      });
    } catch (e) {
      _logger.e(_tag, "_setIpAndPortOfKitchenSumMode()", message: e.toString());
    }
  }

  Future<String?> sendKotToKitchenSumMode(EKot eKot) async {
    try {
      await _setIpAndPortOfKitchenSumMode();
      if(_port!="" && _ipAddress!="" && _ipAddress!="0.0.0.0") {
        final socket = await Socket.connect(_ipAddress, int.parse(_port));
        try {
          final arguments = {'kot':eKot,'methodName':'sendKotToKitchenSumMode','portNumber':_port,'ipAddress':_ipAddress};
          final result = await platform.invokeMethod('post', jsonEncode(arguments));
          return result as String;
        } catch (e) {
          _logger.e(_tag, "sendKotToKitchenSumMode() - platform.invokeMethod()", message: e.toString());
          return null;
        } finally {
          socket.destroy();
        }
      }
    } catch (e) {
      _logger.e(_tag, "sendKotToKitchenSumMode()", message: e.toString());
    }
    return null;
  }

  Future<String?> hideKotOnKOTSnoozeTimeAdded(List<String> kotHash) async {
    try {
      if (kotHash.isNotEmpty) {
        await _setIpAndPortOfKitchenSumMode();
        final socket = await Socket.connect(_ipAddress, int.parse(_port));
        try{
          final snoozeKot = await getKotByHash(kotHash[0]);
          final arguments={'kot':snoozeKot,'methodName':'hideKotOnKOTSnoozeTimeAdded','portNumber':_port,'ipAddress':_ipAddress};
          final  result = await platform.invokeMethod('post',jsonEncode(arguments));
          return result as String;
        } catch (e){
          _logger.e(_tag, "hideKotOnKOTSnoozeTimeAdded - platform.invokeMethod()", message: e.toString());
          return null;
        } finally {
          socket.destroy();
        }
      }
    } catch (e) {
      _logger.e(_tag, "hideKotOnKOTSnoozeTimeAdded()", message: e.toString());
    }
    return null;
  }

  Future<SnoozeKot?> getKotByHash(String hashMD5) async{
    try {
      final dbManager = await DatabaseHelper.getInstance;
      final eKot = await dbManager.kotDao.getKotByHashMD5(hashMD5);
      if(eKot!=null) {
        return SnoozeKot(eKot.snoozeDateTime, eKot.hashMD5);
      }
    } catch (e) {
      _logger.e(_tag, "getKotByHash", message: e.toString());
    }
    return null;
  }

  Future<String?> resetHiddenKot(List<String> kotHash) async {
    try {
      await _setIpAndPortOfKitchenSumMode();
      final socket = await Socket.connect(_ipAddress, int.parse(_port));
      try {
        final arguments = {'kot': kotHash, 'methodName': 'resetHiddenKot', 'portNumber': _port, 'ipAddress': _ipAddress};
        final result = await platform.invokeMethod('post', jsonEncode(arguments));
        return result as String;
      } catch (e) {
        _logger.e(_tag, "resetHiddenKot - platform.invokeMethod()", message: e.toString());
        return null;
      } finally {
        socket.destroy();
      }
     } catch (e) {
      _logger.e(_tag, "resetHiddenKot()", message: e.toString());
    }
    return null;
  }

  Future<String?> showKotAfterSnoozeTimeIsOver(List<String> kotHash) async {
    try {
      await _setIpAndPortOfKitchenSumMode();
      final socket = await Socket.connect(_ipAddress, int.parse(_port));
      try{
        final arguments={'kot':kotHash,'methodName':'showKotAfterSnoozeTimeIsOver','portNumber':_port,'ipAddress':_ipAddress};
        final  result = await platform.invokeMethod('post',jsonEncode(arguments));
        return result as String;
      } catch (e) {
        _logger.e(_tag, "resetHiddenKot - platform.invokeMethod()", message: e.toString());
        return null;
      } finally {
        socket.destroy();
      }
    } catch (e) {
      _logger.e(_tag, "showKotAfterSnoozeTimeIsOver()", message: e.toString());
    }
    return null;
  }

  Future<String?> removeItemFromSum(List<String> kotHash) async {
    try {
      await _setIpAndPortOfKitchenSumMode();
      final socket = await Socket.connect(_ipAddress, int.parse(_port));
      try{
        final arguments={'kot':kotHash,'methodName':'removeItemFromSum','portNumber':_port,'ipAddress':_ipAddress};
        final  result = await platform.invokeMethod('post',jsonEncode(arguments));
        return result as String;
       } catch (e) {
        _logger.e(_tag, "removeItemFromSum - platform.invokeMethod()", message: e.toString(),);
         return null;
      } finally {
        socket.destroy();
       }
    } catch (e) {
      _logger.e(_tag, "removeItemFromSum()", message: e.toString());
    }
    return null;
  }

  Future<String?> removeItemFromKot(List<String> kotHash) async {
    try {
      await _setIpAndPortOfKitchenSumMode();
      final socket = await Socket.connect(_ipAddress, int.parse(_port));
      try{
       final arguments={'kot':kotHash,'methodName':'removeItemFromKot','portNumber':_port,'ipAddress':_ipAddress};
       final  result = await platform.invokeMethod('post',jsonEncode(arguments));
       return result as String;
      } catch (e) {
      _logger.e(_tag, "removeItemFromKot - platform.invokeMethod()",
      message: e.toString());
      return null;
      } finally {
        socket.destroy();
      }
    } catch (e) {
      _logger.e(_tag, "removeItemFromKot()", message: e.toString());
    }
    return null;
  }

  Future<String?> dismissKot(List<String> kotHash) async {
    try {
      if (kotHash.isNotEmpty) {
        await _setIpAndPortOfKitchenSumMode();
        final socket = await Socket.connect(_ipAddress, int.parse(_port));
        try{
          final arguments={'kot':kotHash,'methodName':'dismissKot','portNumber':_port,'ipAddress':_ipAddress};
          final  result = await platform.invokeMethod('post',jsonEncode(arguments));
          return result as String;
        } catch (e) {
          _logger.e(_tag, "dismissKot - platform.invokeMethod()", message: e.toString());
          return null;
        } finally {
          socket.destroy();
        }
      }
    } catch (e) {
      _logger.e(_tag, "dismissKot()", message: e.toString());
    }
    return null;
  }

  Future<String?> addUndoKotItem(List<String> kotHash) async {
    try {
      await _setIpAndPortOfKitchenSumMode();
      final socket = await Socket.connect(_ipAddress, int.parse(_port));
      try{
        final arguments={'kot':kotHash,'methodName':'addUndoKotItem','portNumber':_port,'ipAddress':_ipAddress};
        final  result = await platform.invokeMethod('post',jsonEncode(arguments));
        return result as String;
      } catch (e) {
        _logger.e(_tag, "addUndoKotItem - platform.invokeMethod()", message: e.toString());
        return null;
      } finally {
        socket.destroy();
      }
    } catch (e) {
      _logger.e(_tag, "addUndoKotItem", message: e.toString());
    }
    return null;
  }


}
