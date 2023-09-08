import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/interfaces/ILoadingDialog.dart';
import 'package:kwantapo/ui/interfaces/IMessageDialog.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/ui/views/FilterView.dart';
import 'package:kwantapo/ui/views/MyFloatingActionButton.dart';
import 'package:kwantapo/utils/lib.dart';

class DashboardActivity extends StatefulWidget {

  @override
  State<DashboardActivity> createState() => _DashboardActivityState();

}

class _DashboardActivityState extends State<DashboardActivity> implements IMessageDialog,ILoadingDialog{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _tag = "DashboardActivity";
  final _controller = Get.find<KOTController>();
  final _dataService = DataService.getInstance;
  final _keyboardInputService = KeyboardInputService.getInstance;
  final _snoozeTimeService = SnoozeTimeService.getInstance;
  static const platform = MethodChannel('com.kitchen_mode_api/server');
  T? _ambiguate<T>(T? value) => value;

  @override
  void initState() {
    super.initState();
    _ambiguate(SchedulerBinding.instance)!.addPostFrameCallback((_) {
      _controller.getKOTList();
      isConnectedToInternet(context);
    });
    _keyboardInputService.setMessageDialog(this);
    _dataService.setMessageDialog(this);
    _dataService.setLoadingDialog(this);
    _snoozeTimeService.setMessageDialog(this);
    _snoozeTimeService.setLoadingDialog(this);
    _isServerStarted();
  }

  Future<void> _isServerStarted() async {
    String serverRes = "";
    try {
      final result = await platform.invokeMethod('startKitchenModeServer');
      serverRes = result.toString();
    } on PlatformException catch (e) {
      serverRes = "${e.message}'";
    }
    if (serverRes=="Server is started") {

    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    AppConstants.context=context;
      return RawKeyboardListener(
              onKey: (RawKeyEvent rawKeyEvent) => _keyboardInputService.handleKeyInput(rawKeyEvent, Get.find<KeyboardInputController>(),context),
              focusNode: FocusNode(),
              autofocus: true,
              child: Scaffold(
                backgroundColor: AppTheme.background,
                resizeToAvoidBottomInset: false,
                floatingActionButton:
                AppConstants.sumMode==false ? MyFloatingActionButtons(): Container(),
                appBar: MainAppBar(scaffoldKey: _scaffoldKey, controller: Get.find<KOTController>()),
                body: const KotListView(),
              ),
        );

  }

  Future<void> isConnectedToInternet(BuildContext context) async {
    if (mounted) {
      NetworkUtils().isConnectedToInternet().then((isConnected) {
        if (!isConnected!) {
          showMessageDialog(null, "no_internet");
        }
      }).catchError((error) {
        Logger.getInstance.e(_tag, "isConnectedToInternet()", message: error.toString());
      });
    }
  }


  void showFilter(BuildContext context) {
    showModalBottomSheet(context: context, builder: (context){
      return FilterView();
    },);
  }

  @override
  void showMessageDialog(String? title,String message) {
    showDialog(context: context, builder: (BuildContext context) {
      return MessageDialog(title: title,message: message);
    },);
  }

  @override
  void showLoadingDialog(String message) {
    showDialog(context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingDialog(message: message);
      },);
  }
}
