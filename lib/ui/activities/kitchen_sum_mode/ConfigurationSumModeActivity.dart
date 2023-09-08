import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/TextSizeController.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/sync/lib.dart';
import 'package:kwantapo/ui/activities/kitchen_sum_mode/model/ConfigurationSumModeActivityModel.dart';
import 'package:kwantapo/ui/activities/model/ConfigurationActivityModel.dart';
import 'package:kwantapo/ui/interfaces/ILoadingDialog.dart';
import 'package:kwantapo/ui/interfaces/IMessageDialog.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/ui/views/TextSizeWidget.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';
import 'package:kwantapo/ui/views/KitchenModeConfiguration.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ConfigurationSumModeActivity extends StatefulWidget {

  const ConfigurationSumModeActivity({
    Key? key,
  }) : super(key: key);

  @override
  _ConfigurationSumModeActivityState createState() => _ConfigurationSumModeActivityState();

}

class _ConfigurationSumModeActivityState extends State<ConfigurationSumModeActivity> with TickerProviderStateMixin implements ILoadingDialog,IMessageDialog{
  String _wifiIP = "";
  Future<void>? _load;
  bool  _notificationSound = true;
  late AnimationController? _animationController;
  static const String _TAG = "ConfigurationActivitySumModeState";
  final Logger _logger = Logger.getInstance;
  String temp = "";
  TextEditingController? _kModeIpAddress;
  TextEditingController? _kModePortNum;
  TextEditingController _textSizeController = TextEditingController();
  final textSizeController = Get.find<TextSizeController>();

  final _systemService = SystemService.getInstance;
  final _kitchenModeForm=GlobalKey<FormState>();
  final Map<String,Object?> _formData={
    'ipAddress':  '',
    'port':'',
  };

  @override
  void initState() {
    super.initState();
    AppConstants.context = context;
    _animationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _load = _loadConfigValues();
    _kModeIpAddress = TextEditingController(text: "");
    _kModePortNum = TextEditingController(text: "");
    _systemService.setLoadingDialog(this);
  }



  Future<void> _saveKitchenSumModeForm() async{
    final isValidate=_kitchenModeForm.currentState!.validate();
    if(!isValidate){
      return;
    }
    _kitchenModeForm.currentState!.save();
    SystemService.getInstance.updateKitchenModeConfiguration(
      context,
      _formData['ipAddress'] as String?,
      _formData['port'] as String?,
    );
  }

  void _onSaved(String value,ValidEnum enumerate){
    enumerate == ValidEnum.IPADDRESS ? _formData['ipAddress'] = value :
    enumerate == ValidEnum.PORT ? _formData['port'] = value :
    _formData['printerName'] = value;
  }

  void _clearKitchenSumModeInputs(){
    _kModeIpAddress?.clear();
    _kModePortNum?.clear();
    //why master terminal configuration
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
            _getIPAddress(),
            const Divider(height: 1),
            _getFormSwitch("play_sound", _notificationSound, (bool? value) => SystemService.getInstance.updateNotificationSound(context, value)),
            const Divider(height: 1),
            KitchenModeConfiguration(
              validate: ConfigurationSumModeActivityModel.getInstance.validate,
              onSaved: _onSaved,
              kModeIpAddress: _kModeIpAddress,
              kModePortNum: _kModePortNum,
              saveKitchenModeForm: _saveKitchenSumModeForm,
              kitchenModeForm: _kitchenModeForm,
              clearKitchenModeInputs: _clearKitchenSumModeInputs,
            ),
            const Divider(height: 1),
            TextSizeWidget(context: context,
                textSizeController: _textSizeController,
                onTextSizeChange: (value) async {
                  await textSizeController.setTextSize(value);
                },),
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

  Widget _getIPAddress() => BorderedContainer(
    child: Row(
      children: [
        Expanded(
            child: Text(
                "${AppLocalization.instance.translate("your_ip_address")} $_wifiIP:${Config.socketPort}",
            ),
        ),
        IconButton(
          onPressed: () async {
            _animationController!.forward(from: 0.0);
            _refreshIP();
          },
          icon: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_animationController!),
            child: const Icon(Icons.refresh),
          ),
        ),
      ],
    ),
  );

  Widget _getFormSwitch(String title, bool value, Function(bool) onChanged) => FormSwitch(title: title, value: value, onChanged: (value) => onChanged(value));

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
        _logger.e(_TAG, "_loadConfigValues()-getWifiIP()", message: "_wifiIP: $_wifiIP");

        if (await SystemService.getInstance.printIps() != null) {
          _wifiIP = (await SystemService.getInstance.printIps())!;
        } else {
          _logger.e(_TAG, "_loadConfigValues()-printIps()", message: "_wifiIP: " + _wifiIP);
        }
      }
    } catch (e) {
      _logger.e(_TAG, "_loadConfigValues()", message: "_wifiIP: " + e.toString());
    }

    await PrefUtils().getSound().then((sound) {
      _notificationSound = sound!;
    });

    await PrefUtils().getKitchenModeIpAddress()
        .then((kSumModeIpAddress) {
      _kModeIpAddress?.value = TextEditingValue(text: kSumModeIpAddress);
    });
    await PrefUtils().getKitchenModePort().then((kSumModePort) {
      _kModePortNum?.value = TextEditingValue(text: kSumModePort);
    });

    final prefs = await SharedPreferences.getInstance();
    _textSizeController.text = prefs.getDouble('textSize')?.toString() ?? '';

  }

  void _goBackVoid(BuildContext context) {
    NavigationService.getInstance.settingsOff();
  }

  Future<bool> onBackPressed() async {
    NavigationService.getInstance.settingsOff();
    return true;
  }

  void showAlertDialog(BuildContext context, [String? title, String? content,]) =>
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
                  child: const Text('OK'),)
            ],
          );
        },
      );

  Future<void> _refreshIP() async {
    final bool a = await SystemService.getInstance.initializeServer();
    final String ip = await PrefUtils().getPOIpAddress();
    _logger.e(_TAG, "_refreshIP()", message: a.toString());
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
  void showLoadingDialog(String message) {
    showDialog(context: AppConstants.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingDialog(message: message);
      },);
  }

  @override
  void showMessageDialog(String? title, String message) {
    showDialog(context: context, builder: (BuildContext context) {
      return MessageDialog(title: title,message: message);
    },);
  }
}
