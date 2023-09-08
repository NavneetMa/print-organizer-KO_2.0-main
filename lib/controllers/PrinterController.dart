import 'package:get/get.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/services/lib.dart';

class PrinterController extends GetxController {

  final String _tag = "PrinterController";
  static RxList<EPrinter> printers = <EPrinter>[].obs;

  PrinterController();

  @override
  void onInit() {
    getPrinters();
    super.onInit();
  }

  Future<void> getPrinters() async {
    await DataService.getInstance.getPrinterList().then((value) {
      if (value.isNotEmpty) {
        printers(value);
      }
    });
  }

  void addPrinter(EPrinter ePrinter) {
    printers.add(ePrinter);
  }

  void removePrinter(int id) {
    printers.removeWhere((element) => element.id == id);
    printers.refresh();
  }

  void updatePrinterIsToSend(int id) {
    printers[id].isSend = !printers[id].isSend;
    printers.refresh();
    update();
  }

  void updatePrinterIsToRemove(int id) {
    printers[id].isRemove = !printers[id].isRemove;
    printers.refresh();
    update();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
