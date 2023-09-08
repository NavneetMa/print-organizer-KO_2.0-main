import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/interfaces/ILoadingDialog.dart';
import 'package:kwantapo/ui/interfaces/IMessageDialog.dart';
import 'package:kwantapo/utils/lib.dart';

class KeyboardInputService {

  static KeyboardInputService? _instance;
  factory KeyboardInputService() => getInstance;
  KeyboardInputService._();

  static KeyboardInputService get getInstance {
    if (_instance == null) {
      _instance =  KeyboardInputService._();
    }
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

  static const String _TAG = "KeyboardInputService";
  final Logger _logger = Logger.getInstance;

  void handleKeyInput(RawKeyEvent rawKeyEvent, KeyboardInputController controller,BuildContext context) {
    final kotController = Get.find<KOTController>();
    final aggregatedKotController = Get.find<AggregatedItemController>();
    int number = 0;
    if (rawKeyEvent.runtimeType.toString() == 'RawKeyDownEvent') {
      try {
        if (rawKeyEvent.physicalKey == PhysicalKeyboardKey.enter || rawKeyEvent.physicalKey == PhysicalKeyboardKey.numpadEnter) {
          if (controller.indexInput.value != 0) {
            removeKotOnEnterPressed(controller.indexInput.value - 1);
          }
          controller.indexInput(0);
        } else if (rawKeyEvent.physicalKey == PhysicalKeyboardKey.numpadMemoryAdd || rawKeyEvent.physicalKey == PhysicalKeyboardKey.numpadAdd) {
          if(aggregatedKotController.aggregatedList.isNotEmpty){

              if(kotController.kotList[controller.indexInput.value - 1]!.inSum){
                return;
              }
              else{
                addToSummationOnAddPressed(controller);
              }

          }
          else{
            addToSummationOnAddPressed(controller);
          }
        } else if (rawKeyEvent.physicalKey == PhysicalKeyboardKey.minus || rawKeyEvent.physicalKey == PhysicalKeyboardKey.numpadSubtract) {
          if(aggregatedKotController.aggregatedList.isNotEmpty){
              if(kotController.kotList[controller.indexInput.value - 1]!.inSum==false){
                return;
              }
              else{
                removeFromSummationListOnMinusPressed(controller);
              }
          }
          else{
            removeFromSummationListOnMinusPressed(controller);
          }
        } else {
          number = getPressedKey(rawKeyEvent);
        }
        if(number!=-1){
          controller.indexInput(number);
        }
      } catch (error) {
        _logger.d(_TAG, "handleKeyInput()", message: "$error key: ${rawKeyEvent.logicalKey.keyLabel}");
      }
    }
  }

  void removeFromSummationListOnMinusPressed(KeyboardInputController keyboardInputController) {
    final kotController = Get.find<KOTController>();
    final aggregatedKotController = Get.find<AggregatedItemController>();
    if (keyboardInputController.indexInput.value - 1 >= 0 && aggregatedKotController.aggregatedList.length >= 1) {
      final int id = kotController.kotList[keyboardInputController.indexInput.value - 1]!.id!;
      DataService.getInstance.removeFromSummationListOnMinusPressed(id);
    }
    keyboardInputController.indexInput(0);
  }

  void addToSummationOnAddPressed(KeyboardInputController keyboardInputController) {
    final kotController = Get.find<KOTController>();
    if (keyboardInputController.indexInput.value - 1 >= 0) {
      final int id = kotController.kotList[keyboardInputController.indexInput.value - 1]!.id!;
      DataService.getInstance.addAggregateItems(id);
    }
    keyboardInputController.indexInput(0);
  }

  Future<void> removeKotOnEnterPressed(int index) async {
    final controller = Get.find<KOTController>();
    iLoadingDialog.showLoadingDialog('Printing KOT');
    PrinterService.getInstance.printKOT(controller.kotList[index]!.id);
    DataService.getInstance.updateIsDismissed(controller.kotList[index]!.id);
    DataService.getInstance.removeFromSummationList(controller.kotList[index]!.id!);
    controller.removeFromList(index);
    NavigationService.getInstance.goBack();
  }

  static int getPressedKey(RawKeyEvent rawKeyEvent) {
    if (rawKeyEvent.physicalKey == PhysicalKeyboardKey.digit1 || rawKeyEvent.physicalKey == PhysicalKeyboardKey.numpad1) {
      return 1;
    } else if (rawKeyEvent.physicalKey == PhysicalKeyboardKey.digit2 || rawKeyEvent.physicalKey == PhysicalKeyboardKey.numpad2) {
      return 2;
    } else if (rawKeyEvent.physicalKey == PhysicalKeyboardKey.digit3 || rawKeyEvent.physicalKey == PhysicalKeyboardKey.numpad3) {
      return 3;
    } else if (rawKeyEvent.physicalKey == PhysicalKeyboardKey.digit4 || rawKeyEvent.physicalKey == PhysicalKeyboardKey.numpad4) {
      return 4;
    } else if (rawKeyEvent.physicalKey == PhysicalKeyboardKey.digit5 || rawKeyEvent.physicalKey == PhysicalKeyboardKey.numpad5) {
      return 5;
    } else if (rawKeyEvent.physicalKey == PhysicalKeyboardKey.digit6 || rawKeyEvent.physicalKey == PhysicalKeyboardKey.numpad6) {
      return 6;
    } else if (rawKeyEvent.physicalKey == PhysicalKeyboardKey.digit7 || rawKeyEvent.physicalKey == PhysicalKeyboardKey.numpad7) {
      return 7;
    } else if (rawKeyEvent.physicalKey == PhysicalKeyboardKey.digit8 || rawKeyEvent.physicalKey == PhysicalKeyboardKey.numpad8) {
      return 8;
    } else if (rawKeyEvent.physicalKey == PhysicalKeyboardKey.digit9 || rawKeyEvent.physicalKey == PhysicalKeyboardKey.numpad9) {
      return 9;
    } else if (rawKeyEvent.physicalKey == PhysicalKeyboardKey.digit0 || rawKeyEvent.physicalKey == PhysicalKeyboardKey.numpad0) {
      return 0;
    } else {
      return -1;
    }
  }

}
