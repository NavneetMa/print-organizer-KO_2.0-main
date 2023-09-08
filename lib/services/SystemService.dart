import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/sync/lib.dart';
import 'package:kwantapo/ui/interfaces/ILoadingDialog.dart';
import 'package:kwantapo/ui/interfaces/IMessageDialog.dart';
import 'package:kwantapo/utils/lib.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:share_plus/share_plus.dart';

class SystemService {

  static SystemService? _instance;
  factory SystemService() => getInstance;
  SystemService._();

  static SystemService get getInstance {
    _instance ??= SystemService._();
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

  final String _tag = "SystemService";
  final Logger _logger = Logger.getInstance;

  Future<void> checkForPermissionsAndProceed(BuildContext context) async {
    try {
      if (!await PermissionUtils().checkForPermissions()) {
        if (!await PermissionUtils().requestAppPermissions()) {
          checkForPermissionsAndProceed(context);
        } else {
          NavigationService.getInstance.dashboardActivity();
        }
      } else {
        NavigationService.getInstance.dashboardActivity();
      }
    }
    catch (error) {
      _logger.e(_tag, "checkForPermissionsAndProceed()", message: error.toString());
    }
  }
  Future<String?> printIps() async {
    String? ip;
    for (final interface in await NetworkInterface.list()) {
      for (final addr in interface.addresses) {
        if (addr.address.isNotEmpty) {
          ip = addr.address;
        }
      }
    }
    return ip;
  }

  Future<bool> initializeServer() async {
    bool check = false;
    const String pattern = r'(^(?=\d+\.\d+\.\d+\.\d+$)(?:(?:25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])\.?){4}$)';
    final RegExp regExp = RegExp(pattern);
    await NetworkInfo().getWifiIP().then((ipAddress) async {
      if (ipAddress != null) {
        if(regExp.hasMatch(ipAddress)){
          await NetworkService.getInstance.initializeSocketServer(ipAddress, Config.socketPort);
          check = true;
        }
      } else {
        _logger.e(_tag, "initializeServer()", message: "No WiFi connection found.");
      }
    }).catchError((error) {
      _logger.d(_tag, "initializeServer()", message: "Invalid socket server configuration found.");
      _logger.e(_tag, "initializeServer()", message: error.toString());
    });
    if(check==false){
      await printIps().then((ip) async {
        if (ip != null) {
          if(regExp.hasMatch(ip)){
            check = true;
            await NetworkService.getInstance.initializeSocketServer(ip, Config.socketPort);
          }
        } else {
          _logger.e(_tag, "initializeServer()-printIps", message: "No Ethernet connection found.");
        }
      }).catchError((error) {
        _logger.d(_tag, "initializeServer()-printIps", message: "Invalid socket server configuration found.");
        _logger.e(_tag, "initializeServer()-printIPs", message: error.toString());
      });
    }
    return check;
  }

  Future<void> shareLogs(BuildContext context) async {
    final File logsFile = await Logger.getInstance.localFile;
    Share.shareFiles(
      [logsFile.path],
      subject: "KWANTA P.O. LOGS",
      text: "Please find the attached logs file.",
    ).catchError((error) => _logger.e(_tag, "shareLogs()", message: error.toString()));
  }

  Future<void> updatePrinterConfiguration(BuildContext context, String? ipAddress, String? port) async {
    iLoadingDialog.showLoadingDialog("updating");
    //DialogService.getInstance.loadingDialog(context, message: "updating");
    await PrefUtils().setIpAddress(ipAddress!);
    await PrefUtils().setPort(port!);
    NavigationService.getInstance.goBack();
  }

  Future<void> updateMasterTerminalConfiguration(BuildContext context, String? masterTerminalIpAddress, String? masterTerminalPort) async {
    iLoadingDialog.showLoadingDialog("updating");
    //DialogService.getInstance.loadingDialog(context, message: "updating");
    await PrefUtils().setMasterTerminalIpAddress(masterTerminalIpAddress!);
    await PrefUtils().setMasterTerminalPort(masterTerminalPort!);
    NavigationService.getInstance.goBack();
  }

  Future<void> updateKitchenSumModeConfiguration(BuildContext context, String? kSumModeIpAddress, String? kSumModePort) async {
    iLoadingDialog.showLoadingDialog("updating");
    await PrefUtils().setKitchenSumModeIpAddress(kSumModeIpAddress!);
    await PrefUtils().setKitchenSumModePort(kSumModePort!);
    NavigationService.getInstance.goBack();
  }

  Future<void> updateKitchenModeConfiguration(BuildContext context, String? kModeIpAddress, String? kModePort) async {
    iLoadingDialog.showLoadingDialog("updating");
    await PrefUtils().setKitchenModeIpAddress(kModeIpAddress!);
    await PrefUtils().setKitchenModePort(kModePort!);
    NavigationService.getInstance.goBack();
  }

  Future<void> updateNoOfKOT(BuildContext context, int? noOfKot) async {
    await PrefUtils().setNoOfKOT(noOfKot!);
  }

  Future<void> updatePrintKOT(BuildContext context, bool? printKOT) async {
    await PrefUtils().setPrintKOT(printKOT!);
  }

  Future<void> updateAscendingKot(BuildContext context, bool? ascendingKot) async {
    await PrefUtils().setAscendingKot(ascendingKot!);
  }
  Future<void> updateSumMode(bool sumMode) async {
    if(sumMode){
      await PrefUtils().setAutoSum(sumMode);
    }
    await PrefUtils().setSumMode(sumMode);
  }

  Future<void> updateAutoSum(bool isAutoSum) async {
    await PrefUtils().setAutoSum(isAutoSum);
  }

  Future<void> updateNotificationSound(BuildContext context, bool? sound) async {
    await PrefUtils().setSound(sound!);
  }

  Future<void> updatePrintSlip(BuildContext context, bool printSlip) async {
    await PrefUtils().setPrintShortSlip(printSlip);
  }

  Future<void> updatePrintCategorySlip(bool? printCategorySlip) async {
    await PrefUtils().setPrintCategorySlip(printCategorySlip!);
  }
}
