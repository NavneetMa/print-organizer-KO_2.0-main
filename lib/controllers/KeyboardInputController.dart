import 'package:get/get.dart';

class KeyboardInputController extends GetxController {

  RxInt indexInput = 0.obs;
  final String _tag = "KeyboardInputController";

  KeyboardInputController();

  @override
  void onInit() {
    indexInput(0);
    super.onInit();
  }
}