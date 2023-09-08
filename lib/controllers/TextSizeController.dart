import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextSizeController extends GetxController {
  RxDouble textSize = 14.0.obs; // Default to 14

  @override
  void onInit() {
    super.onInit();
    _loadTextSize();
  }

  _loadTextSize() async {
    final prefs = await SharedPreferences.getInstance();
    textSize.value = prefs.getDouble('textSize') ?? 20.0;
  }

  Future<void> setTextSize(double newSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('textSize', newSize);
    textSize.value = newSize;
  }
}
