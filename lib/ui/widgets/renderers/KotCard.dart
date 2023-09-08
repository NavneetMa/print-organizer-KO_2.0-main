import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/data/ResCode.dart';
import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/interfaces/ILoadingDialog.dart';
import 'package:kwantapo/ui/interfaces/IMessageDialog.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class KotCard extends StatefulWidget {

  final Kot kot;
  final int kotIndex;
  final bool addScroll;

  const KotCard({
    Key? key,
    required this.kot,
    required this.kotIndex,
    required this.addScroll,
  }) : super(key: key);

  @override
  _KotCardState createState() => _KotCardState();

}

class _KotCardState extends State<KotCard> implements ILoadingDialog,IMessageDialog {

  final ItemService _itemService = ItemService();
  final _systemService = SystemService.getInstance;
  final Logger _logger = Logger.getInstance;
  final String _tag = "KotCard";
  final KOTController _controller = Get.find<KOTController>();

  @override
  void initState() {
    super.initState();
    _systemService.setLoadingDialog(this);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Card(
        shadowColor: Get.find<KeyboardInputController>().indexInput.value == widget.kotIndex ? AppTheme.mediumRed : AppTheme.white,
        elevation: 4,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Get.find<KeyboardInputController>().indexInput.value == widget.kotIndex ? AppTheme.mediumRed : AppTheme.white),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              constraints: const BoxConstraints(minHeight: 200),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    padding: AppSpaces().mediumLeftRightTop,
                    child: Text("${widget.kot.tableName}, ${widget.kot.userName}", style: TextStyles().kotTextLarge()),
                  ),
                  ListView.builder(
                    padding: AppSpaces().mediumBottomRightLeftTop,
                    physics: widget.addScroll ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.kot.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Item? item = widget.kot.items.elementAt(index);
                      return Container(
                        padding: AppSpaces().smallBottom,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CardItems(
                              updateItemChecked: updateItemChecked,
                              item: item!,
                              itemIndex: index,
                              singleCategory: widget.kot.singleCategory,
                            ),
                            ...item.eItemAddition.map((e) => Container(padding: AppSpaces().mediumLeft, child: Text(e!.itemAddition.trim(), style: TextStyles().kotTextNormal()),)),
                            ...item.childItems.map((e) => Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(padding: AppSpaces().mediumLeft, child: Text(getChildItemLine(e!), style: TextStyles().kotTextMedium()),),
                                ...e.eItemAddition.map((e) => Container(margin: AppSpaces().largeLeft, child: Text(e!.itemAddition.trim(), style: TextStyles().kotTextNormal()),))
                              ],
                            ),),
                          ],
                        ),
                      );
                    },
                  ),
                  loadKitchenMessage(widget.kot)
                ],
              ),
            ),
            TriangleSwipe()
          ],
        ),
      );
    });
  }

  String getChildItemLine(ChildItem e){
    if(e.item!.trim().startsWith("+")) {
      return "+ ${e.quantity}x${e.unit!} ${e.item!.replaceFirst("+", "").trim()}";
    } else {
      return "- ${e.quantity}x${e.unit!} ${e.item!.replaceFirst("-", "").trim()}";
    }
  }

  Widget loadKitchenMessage(Kot kot) {
    if(kot.kitchenMessage=='null' || kot.kitchenMessage.isEmpty){
      return Container();
    } else {
      if(kot.kitchenMessage.startsWith("text:")){
        return Container(
          margin: AppSpaces().largeHorizontal,
          alignment: Alignment.center,
          padding: AppSpaces().smallAll,
          child: Text(kot.kitchenMessage.replaceFirst("text:", ""), style: TextStyles().kotTextLarge(),),
        );
      }
      return Container(
        height: 200,
        alignment: Alignment.center,
        padding: AppSpaces().smallAll,
        margin: AppSpaces().mediumBottomLeftRight,
        child: Image.memory(base64Decode(kot.kitchenMessage.replaceAll(RegExp(r'\s+'), ''))),
      );
    }
  }

  Future<void> updateItemChecked(bool checked, Item item, int itemIndex) async {
    if (item.item!.trim().startsWith("--")) {
      await _itemService.updateItemChecked(item.itemId, checked);
      await _itemService.updateCategoryItems(item.itemId, checked);
      final tempItems = widget.kot.items.map((element) {
        if(element?.categoryId == item.itemId){
          element!.checkbox = true;
        }
        return element;
      });
      final itemList = tempItems.where((element) => element?.categoryId == item.itemId).toList();
      final uncheckedItems = tempItems.where((element) => element!.itemCategory == false && element.checkbox == false).toList();
      if (uncheckedItems.isEmpty) {
        await _removeKotAndPrintCategory(widget.kotIndex - 1, item, itemList, AppConstants.context!);
      } else {
        await _printItemCategory(widget.kotIndex - 1, item, itemList, AppConstants.context!);
      }
    } else {
      final categoryId = widget.kot.items[itemIndex]?.categoryId ?? 0;
      if (categoryId != -1) {
        var itemList = widget.kot.items.where((element) => element?.categoryId == categoryId && element?.checkbox == false).toList();
        final uncheckedItems = widget.kot.items.where((element) => element!.itemCategory == false && element.checkbox == false).toList();
        if (itemList.isEmpty  && checked) {
          final Item categoryItem = widget.kot.items.where((element) => element?.itemId == categoryId).first!;
          await _itemService.updateItemChecked(categoryItem.itemId, checked);
          await _itemService.updateCategoryItems(item.itemId, checked);
          itemList = widget.kot.items.where((element) => element?.categoryId == categoryId).toList();
          if (uncheckedItems.isEmpty) {
            await _removeKotAndPrintCategory(widget.kotIndex - 1, categoryItem, itemList, AppConstants.context!);
          } else {
            await _printItemCategory(widget.kotIndex - 1, categoryItem, itemList, AppConstants.context!);
          }
        } else {
          await _itemService.updateItemChecked(item.itemId, checked);
        }
      }
    }
  }

  Future<void> _removeKotAndPrintCategory(int kotIndex, Item categoryItem, List<Item?> itemList, BuildContext context) async {
    showLoadingDialog('Printing KOT');
    try {
      _resetFilter();
      final kot = Get.find<KOTController>().kotList[kotIndex]!;
      final tableName = kot.tableName;
      final userName = kot.userName;
      var result= await KitchenModeApi.getInstance.dismissKot([kot.hashMD5!]);
      if(result.code==ResCode().failed) {
        Navigator.pop(context);
        showMessageDialog("Alert", "Failed to send data to Kitchen Sum Mode");
        _controller.getKOTList();
        return;
      }
      await _itemService.updateItemIsPrintedByCategoryId(categoryItem.itemId, true);
      await _itemService.updateItemIsPrinted(categoryItem.itemId, true);
      await DataService.getInstance.updateIsDismissed(kot.id);
      await Get.find<KOTController>().removeFromList(kotIndex);
      Get.find<KOTController>().removeFromSearchList(kot.id!);
      await DataService.getInstance.removeFromSummationList(kot.id!);
      PrinterService.getInstance.printKotAndCategoryItems(tableName, userName, categoryItem, itemList);
      Navigator.pop(context);
    } catch(e) {
      _logger.e(_tag, "_removeItemToPrintCategory()", message: e.toString());
    }
  }


  Future<void> _printItemCategory(int kotIndex, Item categoryItem, List<Item?> itemList, BuildContext context) async {
    showLoadingDialog('Printing KOT');
    try {
      final kot = Get.find<KOTController>().kotList[kotIndex]!;
      final tableName = kot.tableName;
      final userName = kot.userName;
      final List<int> itemIds = [];
      itemIds.add(categoryItem.itemId);
      for (final element in itemList) {
        itemIds.add(element!.itemId);
        var itemHashId = await ItemService.getInstance.getItemHash(element.itemId);
        var result = await KitchenModeApi.getInstance.removeItemFromKot([itemHashId]);
        if(result.code==ResCode().failed) {
          NavigationService.getInstance.goBack();
          showMessageDialog("Alert", "Failed to send data to Kitchen Sum Mode");
          return;
        }
        await _itemService.updateItemIsPrinted(categoryItem.itemId, true);
        await _itemService.updateItemIsPrinted(element.itemId, true);
        Get.find<KOTController>().removeItemFromSearchList(kot.id!, element.itemId);
        Get.find<KOTController>().removeCategoryItemFromSearchList(kot.id!, categoryItem.itemId);
        await Get.find<KOTController>().removeItemFromKot(kotIndex, element.itemId);
        await Get.find<KOTController>().removeCategoryItemFromKot(kotIndex, categoryItem.itemId);
        await DataService.getInstance.removeFromSummationListByItemId(element.itemId);
      }
      PrinterService.getInstance.printCategoryItems(tableName, userName, categoryItem, itemList);
      Navigator.pop(context);
    } catch(e) {
      _logger.e(_tag, "_removeItemToPrintCategory()", message: e.toString());
    }
  }

  Future<bool> _resetFilter() async {
    return Get.find<FilterController>().resetFilter();
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
    });
  }
}
