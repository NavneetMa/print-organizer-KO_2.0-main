import 'package:flutter/material.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/activities/model/ConfigurationActivityModel.dart';
import 'package:kwantapo/ui/interfaces/ILoadingDialog.dart';
import 'package:kwantapo/ui/interfaces/IMessageDialog.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/ui/views/IPAddressWidget.dart';
import 'package:kwantapo/ui/views/KitchenSumModeConfiguration.dart';
import 'package:kwantapo/ui/views/MasterTerminalConfiguration.dart';
import 'package:kwantapo/ui/views/NoOfKOTWidget.dart';
import 'package:kwantapo/ui/views/PrinterConfiguration.dart';
import 'package:kwantapo/ui/widgets/renderers/PrintKotFinished.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';
import 'package:network_info_plus/network_info_plus.dart';



class ConfigurationActivity extends StatefulWidget {

  const ConfigurationActivity({
    Key? key,
  }) : super(key: key);

  @override
  _ConfigurationActivityState createState() => _ConfigurationActivityState();

}

class _ConfigurationActivityState extends State<ConfigurationActivity> with TickerProviderStateMixin implements IMessageDialog,ILoadingDialog {
  TextEditingController? _ipAddress;
  TextEditingController? _portNum;
  TextEditingController? _printerName;
  TextEditingController? _masterTerminalIpAddress;
  TextEditingController? _masterTerminalPortNum;
  TextEditingController? _kSumModeIpAddress;
  TextEditingController? _kSumModePortNum;
  String _wifiIP = "";
  String temp="";
  Future<void>? _load;
  String _colorName="red";
  bool _printKOT = false, _ascendingKot = true, _notificationSound = true, _shortSlip = false, _autoSum = false, _sumMode = false, _printCategorySlip = false;
  int _noOfKOT = 2;
  late AnimationController? _animationController;
  final _systemService = SystemService.getInstance;
  Future<void>? _autoSumFuture;
  final _printerForm=GlobalKey<FormState>();
  final _masterForm=GlobalKey<FormState>();
  final _kitchenSumModeForm=GlobalKey<FormState>();
  final Map<String,Object?> _formData={
    'ipAddress':  '',
    'port':'',
    'printerName':''
  };

  void _updateNoOfKOT(int newValue) {
    setState(() {
      _noOfKOT = newValue;
    });
  }

  void _updateColorChange(String value){
    setState(() {
      _colorName = value;
    });
  }
  final String _tag = "ConfigurationActivity";
  final Logger _logger = Logger.getInstance;
  @override
  void initState() {
    super.initState();
    AppConstants.context = context;
    AppConstants.fromSettings = true;
    _ipAddress = TextEditingController(text: "");
    _portNum = TextEditingController(text: "");
    _printerName = TextEditingController(text: "");
    _masterTerminalIpAddress = TextEditingController(text: "");
    _masterTerminalPortNum = TextEditingController(text: "");
    _kSumModeIpAddress = TextEditingController(text: "");
    _kSumModePortNum = TextEditingController(text: "");
    _animationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _load = _loadConfigValues();
    _autoSumFuture = _getAutoSum(_autoSum);
    _systemService.setMessageDialog(this);
    _systemService.setLoadingDialog(this);
  }

  Future<void> _saveMasterForm() async{
    final isValidate=_masterForm.currentState!.validate();
    if(!isValidate){
      return;
    }
    _masterForm.currentState!.save();
    SystemService.getInstance.updateMasterTerminalConfiguration(
        context,
        _formData['ipAddress'] as String?,
        _formData['port'] as String?,
    );
  }

  Future<void> _saveKitchenSumModeForm() async{
    final isValidate=_kitchenSumModeForm.currentState!.validate();
    if(!isValidate){
      return;
    }
    _kitchenSumModeForm.currentState!.save();
    SystemService.getInstance.updateKitchenSumModeConfiguration(
        context,
        _formData['ipAddress'] as String?,
        _formData['port'] as String?,
    );
  }
  Future<void> _savePrinterForm() async{
    final isValidate=_printerForm.currentState!.validate();
    if(!isValidate){
      return;
    }
    _printerForm.currentState!.save();
    DataService.getInstance.addPrinter(EPrinter(name: _formData['printerName'].toString(), ipAddress: _formData['ipAddress'].toString(), port: _formData['port'].toString(), color: _colorName));
    _clearInputs();
  }




  void _onSaved(String value,ValidEnum enumerate){
    enumerate == ValidEnum.IPADDRESS ? _formData['ipAddress'] = value :
    enumerate == ValidEnum.PORT ? _formData['port'] = value :
    _formData['printerName'] = value;
  }

  @override
  Widget build(BuildContext context) {
    return ActivityContainer(
      context: context,
      onBackPressed: onBackPressed,
      onBackPressedVoid: () => _goBackVoid(context),
      title: AppLocalization.instance.translate("configuration"),
      child: FutureBuilder<void>(
        future: _load,
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.done ? ListView(
          shrinkWrap: true,
          padding: AppSpaces().mediumVerticalHorizontal,
          children: [
            IPAddressWidget(wifiIP: _wifiIP,refresh: _refreshIP),
            const Divider(height: 1),
            PrinterConfiguration(
              validate: ConfigurationActivityModel.getInstance.validate,
              onSaved: _onSaved,
              getPrinterListMobileMode: _getPrinterListMobileMode,
              getPrinterTableTabletMode: _getPrinterTableTabletMode,
              savePrinterForm: _savePrinterForm,
              printerForm: _printerForm,
              ipAddress: _ipAddress,
              printerName: _printerName,
              portNum: _portNum,
              colorName: _colorName,
              onColorChange: _updateColorChange,
            ),
            const Divider(height: 1),
            MasterTerminalConfiguration(
              masterForm: _masterForm,
              saveMasterForm: _saveMasterForm,
              onSaved: _onSaved,
              validate: ConfigurationActivityModel.getInstance.validate,
              masterTerminalIpAddress: _masterTerminalIpAddress,
              masterTerminalPortNum: _masterTerminalPortNum,
              clearMasterInputs: _clearMasterInputs,
            ),
            const Divider(height: 1),
            KitchenSumModeConfiguration(
                validate: ConfigurationActivityModel.getInstance.validate,
                onSaved: _onSaved,
                kSumModeIpAddress: _kSumModeIpAddress,
                kSumModePortNum: _kSumModePortNum,
                saveKitchenSumModeForm: _saveKitchenSumModeForm,
                kitchenSumModeForm: _kitchenSumModeForm,
                clearKitchenSumModeInputs: _clearKitchenSumModeInputs,
            ),
            const Divider(height: 1),
            BorderedContainer(child: PrintKotFinished(context: context,title: "print_kot", value:   _printKOT, printKotFinished: _printKotFinished,isShortSlip: _shortSlip,shortSlip: _isShortSlip,)),
            const Divider(height: 1),
            _getFormSwitch("ascending_kot", _ascendingKot, (bool? value) => SystemService.getInstance.updateAscendingKot(context, value)),
            const Divider(height: 1),
            _getFormSwitch("play_sound", _notificationSound, (bool? value) => SystemService.getInstance.updateNotificationSound(context, value)),
            const Divider(height: 1),
            FutureBuilder<void>(
              future: _autoSumFuture,
              builder: (context, snapshot) => snapshot.connectionState == ConnectionState.done ? _getFormSwitch("auto_sum", _autoSum, (bool? value) {
                AppConstants.isAutoSum = value!;
                SystemService.getInstance.updateAutoSum(value);
                DataService.getInstance.clearSummationList();
              }): const LoadingIndicator(),),
            const Divider(height: 1,),
            _getFormSwitch('sum_mode', _sumMode, (bool value) {
              _setSumMode(value);
            }),
            const Divider(height: 1,),
            _getFormSwitch('print_category_slip', _printCategorySlip, (bool value) {
              SystemService.getInstance.updatePrintCategorySlip(value);
            }),
            const Divider(height: 1),
            NoOfKOTWidget(noOfKOT: _noOfKOT,onNoOfKOTChanged: _updateNoOfKOT),
          ],
        ) : const LoadingIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }



  Widget _getPrinterTableTabletMode() {
    return PrinterTable(ConfigurationActivityModel.getInstance.sendPrinterCheckbox,ConfigurationActivityModel.getInstance.removePrinterCheckbox);
  }

  Widget _getPrinterListMobileMode() {
    return PrinterList(ConfigurationActivityModel.getInstance.sendPrinterCheckbox,ConfigurationActivityModel.getInstance.removePrinterCheckbox);
  }



  void _clearInputs(){
    _printerName?.clear();
    _portNum?.clear();
    _ipAddress?.clear();
  }

  void _clearMasterInputs(){
    _masterTerminalIpAddress?.clear();
    _masterTerminalPortNum?.clear();
    SystemService.getInstance.updateMasterTerminalConfiguration(context, "","");
  }

  void _clearKitchenSumModeInputs(){
    _kSumModeIpAddress?.clear();
    _kSumModePortNum?.clear();
    SystemService.getInstance.updateMasterTerminalConfiguration(context, "","");
  }

  Widget _getFormSwitch(String title, bool value, void Function(bool) onChanged) => FormSwitch(title: title, value: value, onChanged: (value) => onChanged(value));

  void _printKotFinished(bool? value){
    setState(() {
      _printKOT = value!;
      if(_printKOT==false){
        _shortSlip=false;
        SystemService.getInstance.updatePrintSlip(context,false);
      }
      SystemService.getInstance.updatePrintKOT(context, _printKOT);
    });
  }

  void _isShortSlip(bool? value){
    setState(() {
      if(_printKOT==true) {
        _shortSlip = value!;
        SystemService.getInstance.updatePrintSlip(context, value);
      }
    });
  }

  Future<void> _getAutoSum(bool autoSum)async {
    _autoSum = autoSum;
  }

  Future<void> _loadConfigValues() async {
    try {
      if (await NetworkInfo().getWifiIP() != null) {
        temp = (await NetworkInfo().getWifiIP())!;
        const String pattern = r'(^(?=\d+\.\d+\.\d+\.\d+$)(?:(?:25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])\.?){4}$)';
        final RegExp regExp = RegExp(pattern);
        if(regExp.hasMatch(temp)){
          _wifiIP=temp;
        }
      } else {
        _logger.e(_tag, "_loadConfigValues()-getWifiIP()", message: "_wifiIP: $_wifiIP");

        if (await SystemService.getInstance.printIps() != null) {
          _wifiIP = (await SystemService.getInstance.printIps())!;
        } else {
          _logger.e(_tag, "_loadConfigValues()-printIps()", message: "_wifiIP: $_wifiIP");
        }
      }
    } catch (e) {
      _logger.e(_tag, "_loadConfigValues()", message: "_wifiIP: $e");
    }
    await PrefUtils().getMasterTerminalIpAddress()
        .then((ipMasterTerminalAddress) {
      _masterTerminalIpAddress?.value =
          TextEditingValue(text: ipMasterTerminalAddress!);
    });
    await PrefUtils().getMasterTerminalPort().then((masterTerminalPort) {
      _masterTerminalPortNum?.value =
          TextEditingValue(text: masterTerminalPort!);
    });
    await PrefUtils().getKitchenSumModeIpAddress()
        .then((kSumModeIpAddress) {
      _kSumModeIpAddress?.value = TextEditingValue(text: kSumModeIpAddress);
    });
    await PrefUtils().getKitchenSumModePort().then((kSumModePort) {
      _kSumModePortNum?.value = TextEditingValue(text: kSumModePort);
    });
    await PrefUtils().getPrintKOT().then((printKOT) {
      _printKOT = printKOT!;
    });
    await PrefUtils().getNoOfKOT().then((noOfKOT) {
      _noOfKOT = noOfKOT;
    });
    await PrefUtils().getAscendingKot().then((ascendingKot) {
      _ascendingKot = ascendingKot!;
    });
    await PrefUtils().getSound().then((sound) {
      _notificationSound = sound!;
    });
    await PrefUtils().getPrintShortSlip().then((shortSlip) {
      _shortSlip = shortSlip!;
    });
    await PrefUtils().getAutoSum().then((autoSum){
      _autoSum = autoSum;
    });
    await PrefUtils().getSumMode().then((sumMode){
      _sumMode = sumMode!;
    });
    await PrefUtils().getPrintCategorySlip().then((printCategorySlip){
      _printCategorySlip = printCategorySlip!;
    });
  }

  void _setSumMode(bool value) {
    if (value) {
      AppConstants.isAutoSum = true;
      _autoSum = true;
      AppConstants.sumMode = _autoSum;
      SystemService.getInstance.updateAutoSum(value);
      DataService.getInstance.clearSummationList();
      setState(() {
        _autoSumFuture = _getAutoSum(_autoSum);
      });
    }
    SystemService.getInstance.updateSumMode(value);
  }

  void _goBackVoid(BuildContext context) {
    NavigationService.getInstance.settingsOff();
  }

  Future<bool> onBackPressed() async {
    NavigationService.getInstance.settingsOff();
    return true;
  }

  void showAlertDialog(BuildContext context,
      [String? title, String? content,]) =>
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title!),
            content: Text(content!),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalization.instance.translate("ok")),)
            ],
          );
        },
      );

  Future<void> _refreshIP() async {
    final bool a = await SystemService.getInstance.initializeServer();
    final String ip = (await PrefUtils().getPOIpAddress()).toString();
    _logger.e(_tag, "_refreshIP()", message: a.toString());
    if (a) {
      setState(() {
        _wifiIP = ip;
      });
      showMessageDialog('Ip Address','Your IP address is : $ip');
    } else {
      _wifiIP = "";
      setState(() {
        _wifiIP = _wifiIP;
      });
      if (_wifiIP == "0.0.0.0" || _wifiIP == "") {
        showMessageDialog('Ip Address','No IP address is found.');
      }
    }
  }

  @override
  void showMessageDialog(String? title,String message) {
    showDialog(context: context, builder: (BuildContext context) {
      return MessageDialog(title: title,message: message);
    });
  }

  @override
  void showLoadingDialog(String message) {
    showDialog(context: AppConstants.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingDialog(message: message);
      },);
  }
}
