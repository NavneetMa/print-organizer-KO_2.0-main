import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/AggregatedItemController.dart';
import 'package:kwantapo/data/podos/AggregatedItem.dart';
import 'package:kwantapo/db/DatabaseHelper.dart';
import 'package:kwantapo/services/kitchen_sum_mode_api/KitchenSumModeAPI.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/activities/kitchen_sum_mode/interfaces/IKitchenSMDActivity.dart';
import 'package:kwantapo/ui/dialogs/MessageDialog.dart';
import 'package:kwantapo/ui/interfaces/IMessageDialog.dart';
import 'package:kwantapo/ui/kitchen_sum_mode/ItemTableByGroupName.dart';
import 'package:kwantapo/ui/kitchen_sum_mode/KitchenSummationPanelView.dart';
import 'package:kwantapo/ui/widgets/renderers/KitchenSMAppBar.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class KitchenSMDashboardActivity extends StatefulWidget {

  @override
  State<KitchenSMDashboardActivity> createState() => _KitchenSMDashboardActivityState();

}

class _KitchenSMDashboardActivityState extends State<KitchenSMDashboardActivity> implements IMessageDialog , IKitchenSMDActivity{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _tag = "KitchenSMDashboardActivity";
  T? _ambiguate<T>(T? value) => value;
  final _kitchenSumModeApi= KitchenSumModeAPI.getInstance;
  static const platform = MethodChannel('com.kitchen_sum_mode_api/server');
  bool groupView = false;
  final AggregatedItemController _controller = Get.find<AggregatedItemController>();
  late Rx<HashMap<String, List<AggregatedItem>>> itemMap = Rx<HashMap<String, List<AggregatedItem>>>(HashMap());
  final Logger _logger = Logger.getInstance;

  @override
  void initState() {
    super.initState();
    _ambiguate(SchedulerBinding.instance)!.addPostFrameCallback((_) => isConnectedToInternet(context));
    _isServerStarted();
    _kitchenSumModeApi.setMessageDialog(this);
    _kitchenSumModeApi.setIKitchenSMDActivity(this);
  }

  Future<void> _isServerStarted() async {
    String serverRes = "";
    try {
      final result = await platform.invokeMethod('startServer');
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
    return Scaffold(
      backgroundColor: AppTheme.background,
      resizeToAvoidBottomInset: false,
      floatingActionButton: buildFabButtons(),
      appBar: KitchenSMAppBar(scaffoldKey: _scaffoldKey),
      body: getView(),
    );
  }

  Widget getView() {
    if (groupView) {
      return Obx(() {
        if (itemMap.value.isNotEmpty) {
          return ItemTableByGroupName(data:itemMap.value);
        } else {
          return Container();
        }
      });
    } else {
      return const KitchenSummationPanelView();
    }
  }

  Widget buildFabButtons() {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: AppSpaces().smallBottom,
          child: FloatingActionButton(
            heroTag: 2,
            backgroundColor: AppConstants.clickOfClock ? AppTheme.colorAccentLight : AppTheme.colorPrimary,
            onPressed: () async {
              setState(() {
                AppConstants.clickOfClock = !AppConstants.clickOfClock;
              });
              if(groupView){
                await showSnoozedDataClicked();
              }else{
                DataService.getInstance.getKOTListForSummation();
              }
              setState(() {
                AppConstants.isProcessing=false;
              });
            },
            child: const Icon(Icons.alarm),
          ),
        ),
        Container(
          margin: AppSpaces().smallBottom,
          child: FloatingActionButton(
            heroTag: 1,
            backgroundColor: groupView ? AppTheme.colorAccentLight : AppTheme.colorPrimary,
            onPressed: () async {
              if(AppConstants.isProcessing){
                return;
              }
              setState(() {
                groupView=!groupView;
              });
              if (groupView) {
                await setGroupViewData();
              }
              setState(() {
                AppConstants.isProcessing=false;
              });
            },
            child: const Icon(Icons.table_view),
          ),
        ),
      ],
    );
  }

  Future<void> isConnectedToInternet(BuildContext context) async {
    if (mounted) {
      NetworkUtils().isConnectedToInternet().then((isConnected) {
        if (!isConnected!) {
          showMessageDialog(null,"no_internet");
        }
      }).catchError((error) {
        Logger.getInstance.e(_tag, "isConnectedToInternet()", message: error.toString());
      });
    }
  }

  @override
  void showMessageDialog(String? title,String message) {
    showDialog(context:context, builder: (BuildContext context) {
      return MessageDialog(title: title,message: message);
    },);
  }

  @override
  Future<void> setGroupViewData() async {
    try{
      final dbManager = await DatabaseHelper.getInstance;
      final groupNames = await dbManager.itemDao.getUniqueGroupNames();
      HashMap<String, List<AggregatedItem>> groupNameHash =HashMap();
      for (var group in groupNames) {
        final List<AggregatedItem> agrItem=[];
        for (final element in _controller.aggregatedList) {
          if(element.groupName == group){
            agrItem.add(element);
          }
        }
        groupNameHash.putIfAbsent(group, () => agrItem);
        for (var key in groupNameHash.keys.toList()) {
          if (groupNameHash[key]!.isEmpty) {
            groupNameHash.remove(key);
          }
        }
      }
      itemMap.value = groupNameHash;
    } catch (e) {
      _logger.e(_tag, "setGroupViewData()", message: e.toString());
    }

  }

  @override
  bool isGroupView() {
    return groupView;
  }

  @override
  Future<void> refreshGroupViewData() async {
    try{
      if(groupView){
        final dbManager = await DatabaseHelper.getInstance;
        final groupNames = await dbManager.itemDao.getUniqueGroupNames();
        HashMap<String, List<AggregatedItem>> groupNameHash =HashMap();
        for (var group in groupNames) {
          final List<AggregatedItem> agrItem=[];
          for (final element in _controller.aggregatedList) {
            if(element.groupName == group){
              agrItem.add(element);
            }
          }
          groupNameHash.putIfAbsent(group, () => agrItem);
        }
        for (var key in groupNameHash.keys.toList()) {
          if (groupNameHash[key]!.isEmpty) {
            groupNameHash.remove(key);
          }
        }
        itemMap.value = groupNameHash;
      }
    } catch (e) {
      _logger.e(_tag, "refreshGroupViewData()", message: e.toString());
    }

  }

  @override
  Future<void> addUndoKotGroupView(int kotId) async {
    try{
      if(groupView){
        final dbManager = await DatabaseHelper.getInstance;
        final kot = await dbManager.kotDao.getSingle(kotId);
        final groupNames = await dbManager.itemDao.getUniqueGroupNames();
        HashMap<String, List<AggregatedItem>> groupNameHash =HashMap();
        for (var group in groupNames) {
          final List<AggregatedItem> agrItem=[];
          for (final element in _controller.aggregatedList) {
            if(element.groupName == group){
              agrItem.add(element);
            }
          }
          groupNameHash.putIfAbsent(group, () => agrItem);
        }
        for (var key in groupNameHash.keys.toList()) {
          if (groupNameHash[key]!.isEmpty) {
            groupNameHash.remove(key);
          }
        }
        if(kot!.hideKot==false && AppConstants.clickOfClock){
          return;
        }
        itemMap.value = groupNameHash;
      }
    } catch (e) {
      _logger.e(_tag, "addUndoKotGroupView()", message: e.toString());
    }

  }

  @override
  Future<void> showSnoozedDataClicked() async{
    try{
      HashMap<String, List<AggregatedItem>> groupList =HashMap();
      DataService.getInstance.clearSummationList();
      final dbManager = await DatabaseHelper.getInstance;
      final groupName = await dbManager.itemDao.getUniqueGroupNames();
      var kotList =  AppConstants.clickOfClock ? await DataService.getInstance.getHideKot(): await DataService.getInstance.getFormattedKot();
      for (var kot in kotList){
        await DataService.getInstance.autoSumAggregatedList(kot!.id!);
      }
      for (var group in groupName) {
        final List<AggregatedItem> agrItem=[];
        for (final element in _controller.aggregatedList) {
          if(element.groupName == group){
            agrItem.add(element);
          }
        }
        groupList.putIfAbsent(group, () => agrItem);
      }
      for (var key in groupList.keys.toList()) {
        if (groupList[key]!.isEmpty) {
          groupList.remove(key);
        }
      }
      itemMap.value = groupList;
    } catch (e){
      _logger.e(_tag, "showSnoozedDataClicked()", message: e.toString());
    }

  }


}
