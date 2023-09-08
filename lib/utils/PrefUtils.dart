import 'package:kwantapo/utils/lib.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {

  final String _tag = "PrefUtils";
  final String _port = "port";
  final String _ipAddress = "ipAddress";
  final String _kotPrint = "kotPrint";
  final String _masterTerminalAddress = "masterTerminalAddress";
  final String _masterTerminalPort = "masterTerminalPort";
  final String _kitchenSumModeIpAddress = "kitchenSumModeIpAddress";
  final String _kitchenModeIpAddress = "kitchenModeIpAddress";
  final String _kitchenSumModePort = "kitchenSumModePort";
  final String _kitchenModePort = "kitchenModePort";
  final String _poIpAddress = "poIpAddress";
  final String _poPort = "poPort";
  final String _selectedMode = "selected_mode";
  final String _updateFirstFlag = "is_first_launch";
  final String _noOfKOT = "noOfKOT";
  final String _ascendingKot = "ascendingKot";
  final String _sound = "sound";
  final String _shortSlip = "shortSlip";
  final String _kotSum = "kotSum";
  final String _sumMode="sumMode";
  final String _printCategorySlip="printCategorySlip";

  Future<String?> getIpAddress() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_ipAddress)) {
        return prefs.getString(_ipAddress);
      }
      return "0.0.0.0";
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getIpAddress()", message: error.toString());
      return "0.0.0.0";
    });
  }

  Future<void> setIpAddress(String address) async {
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setString(_ipAddress, address);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setIpAddress()", message: error.toString());
    });
  }

  Future<String?> getPort() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_port)) {
        return prefs.getString(_port);
      }
      return "9100";
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getPort()", message: error.toString());
      return "9100";
    });
  }

  Future<void> setPort(String port) async {
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setString(_port, port);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setPort()", message: error.toString());
    });
  }

  Future<String?> getMasterTerminalIpAddress() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_masterTerminalAddress)) {
        return prefs.getString(_masterTerminalAddress);
      }
      return "0.0.0.0";
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getMasterTerminalIpAddress()", message: error.toString());
      return "0.0.0.0";
    });
  }

  Future<String> getKitchenSumModeIpAddress() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_kitchenSumModeIpAddress)) {
        return prefs.getString(_kitchenSumModeIpAddress) ?? "0.0.0.0";
      }
      return "0.0.0.0";
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getKitchenSumModeIpAddress()", message: error.toString());
      return "0.0.0.0";
    });
  }

  Future<void> setMasterTerminalIpAddress(String address) async {
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setString(_masterTerminalAddress, address);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setMasterTerminalIpAddress()", message: error.toString());
    });
  }

  Future<void> setKitchenSumModeIpAddress(String address) async {
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setString(_kitchenSumModeIpAddress, address);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setKitchenSumModeIpAddress()", message: error.toString());
    });
  }

  Future<void> setKitchenModeIpAddress(String address) async {
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setString(_kitchenModeIpAddress, address);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setKitchenModeIpAddress()", message: error.toString());
    });
  }

  Future<String> getKitchenModeIpAddress() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_kitchenModeIpAddress)) {
        return prefs.getString(_kitchenModeIpAddress) ?? "0.0.0.0";
      }
      return "0.0.0.0";
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getKitchenModeIpAddress()", message: error.toString());
      return "0.0.0.0";
    });
  }

  Future<String?> getMasterTerminalPort() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_masterTerminalPort)) {
        return prefs.getString(_masterTerminalPort);
      }
      return "9001";
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getMasterTerminalPort()", message: error.toString());
      return "9001";
    });
  }

  Future<void> setMasterTerminalPort(String port) async {
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setString(_masterTerminalPort, port);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setMasterTerminalPort()", message: error.toString());
    });
  }

  Future<String> getKitchenSumModePort() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_kitchenSumModePort)) {
        return prefs.getString(_kitchenSumModePort) ?? "8444";
      }
      return "8444";
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getKitchenSumModePort()", message: error.toString());
      return "8444";
    });
  }

  Future<void> setKitchenSumModePort(String port) async {
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setString(_kitchenSumModePort, port);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setKitchenSumModePort()", message: error.toString());
    });
  }

  Future<void> setKitchenModePort(String port) async {
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setString(_kitchenModePort , port);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setKitchenModePort()", message: error.toString());
    });
  }

  Future<String> getKitchenModePort() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_kitchenModePort)) {
        return prefs.getString(_kitchenModePort) ?? "8445";
      }
      return "8445";
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getKitchenModePort()", message: error.toString());
      return "8445";
    });
  }

  Future<String> getPOIpAddress() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_poIpAddress)) {
        return prefs.getString(_poIpAddress) ?? "0.0.0.0";
      }
      return "0.0.0.0";
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getPOIpAddress()", message: error.toString());
      return "0.0.0.0";
    });
  }

  Future<void> setPOIpAddress(String address) async {
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setString(_poIpAddress, address);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setPOIpAddress()", message: error.toString());
    });
  }

  Future<String?> getPOPort() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_poPort)) {
        return prefs.getString(_poPort);
      }
      return "9001";
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getPOPort()", message: error.toString());
      return "9001";
    });
  }

  Future<void> setPOPort(String port) async {
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setString(_poPort, port);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setPOPort()", message: error.toString());
    });
  }

  Future<bool?> getPrintKOT() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_kotPrint)) {
        return prefs.getBool(_kotPrint);
      }
      return true;
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getPrintKOT()", message: error.toString());
      return true;
    });
  }

  Future<void> setPrintKOT(bool value) async {
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setBool(_kotPrint, value);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setPrintKOT()", message: error.toString());
    });
  }

  Future<int> getNoOfKOT() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_noOfKOT)) {
        return prefs.getInt(_noOfKOT) ?? 2;
      }
      return 2;
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getNoOfKOT()", message: error.toString());
      return 2;
    });
  }

  Future<void> setNoOfKOT(int value) async {
    SharedPreferences.getInstance().then((prefs) {
      AppConstants.noOfKot=value;
      return prefs.setInt(_noOfKOT, value);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setNoOfKOT()", message: error.toString());
    });
  }

  Future<bool?> getAscendingKot() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_ascendingKot)) {
        return prefs.getBool(_ascendingKot);
      }
      return true;
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getAscendingKot()", message: error.toString());
      return true;
    });
  }

  Future<bool?> getSumMode() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_sumMode)) {
        return prefs.getBool(_sumMode);
      }
      return false;
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getSumKot()", message: error.toString());
      return false;
    });
  }

  Future<bool> getAutoSum() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_kotSum)) {
        return prefs.getBool(_kotSum) ?? false;
      }
      return false;
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getAutoSum()", message: error.toString());
      return false;
    });
  }

  Future<void> setAscendingKot(bool value) async {
    SharedPreferences.getInstance().then((prefs) {
      AppConstants.ascendingKot = value;
      return prefs.setBool(_ascendingKot, value);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setAscendingKot()", message: error.toString());
    });
  }

  Future<void> setSumMode(bool value) async {
    SharedPreferences.getInstance().then((prefs) {
      AppConstants.sumMode = value;
      return prefs.setBool(_sumMode, value);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setSumMode()", message: error.toString());
    });
  }

  Future<void> setAutoSum(bool value) async {
    SharedPreferences.getInstance().then((prefs) {
      AppConstants.isAutoSum = value;
      return prefs.setBool(_kotSum, value);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setAutoSum()", message: error.toString());
    });
  }

  Future<bool?> getSound() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_sound)) {
        return prefs.getBool(_sound);
      }
      return true;
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getSound()", message: error.toString());
      return true;
    });
  }

  Future<void> setSound(bool value) async {
    SharedPreferences.getInstance().then((prefs) {
      AppConstants.notificationSound = value;
      return prefs.setBool(_sound, value);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setSound()", message: error.toString());
    });
  }

  Future<bool?> getPrintShortSlip() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_shortSlip)) {
        return prefs.getBool(_shortSlip) ?? true;
      }
      return true;
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getPrintShortSlip()", message: error.toString());
      return true;
    });
  }

  Future<void> setPrintShortSlip(bool value) async {
    SharedPreferences.getInstance().then((prefs) {
      AppConstants.notificationSound = value;
      return prefs.setBool(_shortSlip, value);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setPrintShortSlip()", message: error.toString());
    });
  }

  Future<void> setPrintCategorySlip(bool printCategorySlip) async {
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setBool(_printCategorySlip, printCategorySlip);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "printCategorySlip()", message: error.toString());
    });
  }

  Future<bool?> getPrintCategorySlip() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_printCategorySlip)) {
        return prefs.getBool(_printCategorySlip);
      }
      return false;
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getPrintCategorySlip()", message: error.toString());
      return false;
    });
  }

  Future<void> setSaveSelectedMode(String selectedMode) async{
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setString(_selectedMode, selectedMode);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setSaveSelectedMode()", message: error.toString());
    });
  }

  Future<String?> getSaveSelectedMode() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_selectedMode)) {
        return prefs.getString(_selectedMode);
      }
      return AppConstants.SELECT_MODE;
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getSaveSelectedMode()", message: error.toString());
      return AppConstants.SELECT_MODE;
    });
  }

  Future<void> setUpdateFirstFlag(bool update) async{
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setBool(_updateFirstFlag, update);
    }).catchError((error) {
      Logger.getInstance.e(_tag, "setUpdateFirstFlag()", message: error.toString());
    });
  }

  Future<bool?> getUpdateFirstFlag() async {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_updateFirstFlag)) {
        return prefs.getBool(_updateFirstFlag);
      }
      return true;
    }).catchError((error) {
      Logger.getInstance.e(_tag, "getUpdateFirstFlag()", message: error.toString());
      return true;
    });
  }

}
