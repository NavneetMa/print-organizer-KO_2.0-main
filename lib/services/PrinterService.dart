import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/db/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class PrinterService {
  static PrinterService? _instance;

  factory PrinterService() => getInstance;

  PrinterService._();
  PosStyles mediumPosStyles = const PosStyles(
    height: PosTextSize.size2,
    width: PosTextSize.size2,
  );

  static PrinterService get getInstance {
    _instance ??= PrinterService._();
    return _instance!;
  }

  final String _tag = "PrinterService";
  final Logger _logger = Logger.getInstance;

  Future<void> printKOT(int? id, { bool isMSwip = false }) async {
    final DatabaseManager manager = await DatabaseHelper.getInstance;
    final EKot? eKot = await manager.kotDao.getSingle(id!);
    final bool? shortSlip = await PrefUtils().getPrintShortSlip();
    _logger.d(_tag, "printKOT()", message: "isMSwip $isMSwip");
    final bool? isPrintKOT = await PrefUtils().getPrintKOT();
    try {
      final List<EPrinter?> ePrinterList = await manager.printerDao.getAll();
      for (int i = 0; i < ePrinterList.length; i++) {
        final element = ePrinterList[i];
        final String ipAddress = element!.ipAddress;
        final String port = element.port;
        _logger.d(_tag, "printKOT()", message: "Connecting to printer at $ipAddress:$port");
        _getPrinter(ipAddress, int.parse(port)).then((printer) async {
          if (element.isSend) {
            if(printer != null) {
              await _printAllItems (printer, eKot!, isSend: element.isSend);
            }
          } else if (element.isRemove) {
            DataService.getInstance.removeKot(id);
          } else if(isPrintKOT!) {
            if (printer != null) {
              if (isMSwip && shortSlip!) {
                await _printUserAndTable(printer, eKot!);
              } else {
                await _printAllItems(printer, eKot!);
              }
            }
          } else {
            _logger.d(_tag, "printKOT()", message: "Printing disabled for the printer IP: $ipAddress");
          }
          printer?.disconnect();
        });
      }
    } catch (onError) {
      _logger.e(_tag, "printKOT() - getPrintKOT()", message: onError.toString());
    }
  }

  Future<void> printKOTFromSinglePrinter(int? id, EPrinter ePrinter) async {
    try {
      final DatabaseManager manager = await DatabaseHelper.getInstance;
      final EKot? eKot = await manager.kotDao.getSingle(id!);
      if (ePrinter.isSend) {
        final String ipAddress = ePrinter.ipAddress;
        final String port = ePrinter.port;
        final NetworkPrinter? printer = await _getPrinter(ipAddress, int.parse(port));
        if (printer != null) {
          await _printAllItems(printer, eKot!, isSend: ePrinter.isSend);
        }
      } else if (ePrinter.isRemove) {
        DataService.getInstance.removeKot(id);
      }
    } catch (e) {
      _logger.e(_tag, "printKOTFromSinglePrinter()", message: e.toString());
    }
  }

  Future<void> _printUserAndTable(NetworkPrinter printer, EKot eKot) async {
    try {
      final EFKot? efKot = await DataService.getInstance.getFKot(eKot.id!);
      if(efKot!=null){
        printer.text("${efKot.tableName!}, ${efKot.userName!}", styles: mediumPosStyles);
        printer.feed(2);
        printer.cut();
        printer.disconnect();
      }
    } catch (e) {
      _logger.e(_tag, "_printUserAndTable()", message: e.toString());
    }
  }

  Future<void> printItems(List<ItemData> list) async {
    try {
      final DatabaseManager manager = await DatabaseHelper.getInstance;
      final List<EPrinter?> ePrinterList = await manager.printerDao.getAll();
      for (int i = 0; i < ePrinterList.length; i++) {
        final element = ePrinterList[i];
        final String ipAddress = element!.ipAddress;
        final String port = element.port;
        _logger.d(_tag, "printKOT()", message: "Connecting to printer at $ipAddress:$port");
        final NetworkPrinter? printer = await _getPrinter(ipAddress, int.parse(port));
        if (printer != null) {
          for(int j=0;j<list.length;j++) {
            final itemData = list[j];
            _logger.d(_tag, "printKOT()", message: "Connecting to printer at");
            printer.text("${itemData.tableName}, ${itemData.userName}", styles: mediumPosStyles);
            printer.feed(1);
            if (itemData.categoryItem.item!="") {
              printer.text(itemData.categoryItem.item!, styles: mediumPosStyles);
            }
            printer.text("${itemData.item.quantity}x${itemData.item.unit!}  ${itemData.item.item!}", styles: mediumPosStyles);
            for (final element in itemData.itemAdditions) {
              printer.text("  ${element!.itemAddition}");
            }
            for (final element in itemData.childItems) {
              var itemAdd = "+";
              var strItem = "";
              if (element!.item!.trim().startsWith("-")) {
                itemAdd = "-";
                strItem = element.item!.trim().substring(1, element.item!.length);
                } else{
                strItem = element.item!.trim().substring(1, element.item!.length);
                }
              printer.text("  $itemAdd${element.quantity}x${element.unit} $strItem");
              for (final element in element.eItemAddition) {
                printer.text("    ${element!.itemAddition}");
              }
            }
            printer.feed(2);
            printer.cut();
          }
          printer.disconnect();
        }
      }
    } catch(e){
      _logger.e(_tag, "printItems()", message: e.toString());
    }
  }

  Future<void> printCategoryItems(String tableName, String userName,Item categoryItem, List<Item?> items) async {
    try {
      final DatabaseManager manager = await DatabaseHelper.getInstance;
      final List<EPrinter?> ePrinterList = await manager.printerDao.getAll();
      for (int i = 0; i < ePrinterList.length; i++) {
        final element = ePrinterList[i];
        final String ipAddress = element!.ipAddress;
        final String port = element.port;
        _logger.d(_tag, "printKOT()", message: "Connecting to printer at $ipAddress:$port");
        final NetworkPrinter? printer = await _getPrinter(ipAddress, int.parse(port));
        if (printer != null) {
          for (int i = 0; i < items.length; i++) {
            printer.text("$tableName, $userName", styles: mediumPosStyles);
            printer.feed(1);
            printer.text(categoryItem.item!, styles: mediumPosStyles);
            printer.text("${items[i]!.quantity}x${items[i]!.unit!}  ${items[i]!.item!}", styles: mediumPosStyles);
            for (final element in items[i]!.eItemAddition) {
              printer.text("  ${element!.itemAddition}");
            }
            for (final element in items[i]!.childItems) {
              var itemAdd = "+";
              var strItem = "";
              if(element!.item!.trim().startsWith("-")){
                itemAdd = "-";
                strItem = element.item!.trim().substring(1,element.item!.length);
              } else {
                strItem = element.item!.trim().substring(1,element.item!.length);
              }
              printer.text("  $itemAdd${element.quantity}x${element.unit} $strItem");
              for (final element in element.eItemAddition) {
                printer.text("    ${element!.itemAddition}");
              }
            }
            printer.feed(2);
            printer.cut();
          }
          printer.disconnect();
        }
      }
    } catch (e) {
      _logger.e(_tag, "printCategoryItems()", message: e.toString());
    }
  }

  Future<void> printKotAndCategoryItems(String tableName, String userName,Item categoryItem, List<Item?> items) async {
    try {
      final DatabaseManager manager = await DatabaseHelper.getInstance;
      final List<EPrinter?> ePrinterList = await manager.printerDao.getAll();
      for (int i = 0; i < ePrinterList.length; i++) {
        final element = ePrinterList[i];
        final String ipAddress = element!.ipAddress;
        final String port = element.port;
        _logger.d(_tag, "printKOT()", message: "Connecting to printer at $ipAddress:$port");
        final NetworkPrinter? printer = await _getPrinter(ipAddress, int.parse(port));
        if (printer != null) {
          printer.text("$tableName, $userName", styles: mediumPosStyles);
          printer.feed(1);
          printer.text(categoryItem.item!, styles: mediumPosStyles);
          for (int i = 0; i < items.length; i++) {
            printer.text("${items[i]!}x${items[i]!.unit} ${items[i]!.item!}", styles: mediumPosStyles);
            for (final element in items[i]!.eItemAddition) {
              printer.text("  ${element!.itemAddition}");
            }
            for (final element in items[i]!.childItems) {
              var itemAdd = "+";
              var strItem = "";
              if(element!.item!.trim().startsWith("-")){
                itemAdd = "-";
                strItem = element.item!.trim().substring(1,element.item!.length);
              } else {
                strItem = element.item!.trim().substring(1,element.item!.length);
              }
              printer.text("  $itemAdd${element.quantity}x${element.unit} $strItem");
              for (final element in element.eItemAddition) {
                printer.text("    ${element!.itemAddition}");
              }
            }
          }
          printer.feed(2);
          printer.cut();
          printer.disconnect();
        }
      }
    } catch (e) {
      _logger.e(_tag, "printCategoryItems()", message: e.toString());
    }
  }

  Future<void> _printAllItems(NetworkPrinter printer, EKot eKot, {bool isSend = false}) async {
    try{
      if (isSend) {
        printer.text(eKot.fKotWithSeparator);
        printer.feed(2);
        printer.cut();
        printer.disconnect();
        return;
      }
      final EFKot? efKot = await DataService.getInstance.getFKot(eKot.id!);
      if (efKot != null) {
      final kot = Kot(
        id: eKot.id,
        items: await DataService.getInstance.getItems(eKot.id!),
        receivedTime: eKot.receivedTime,
        kotDismissed: eKot.kotDismissed,
        hashMD5: eKot.hashMD5,
        inSum: AppConstants.isAutoSum,
        tableName: efKot.tableName!,
        userName: efKot.userName!,
        kitchenMessage: efKot.kitchenMessage.toString(),);
      printer.text("${kot.tableName}, ${efKot.userName!}", styles: mediumPosStyles);
      printer.feed(1);
      for (final element in kot.items) {
        if (element!.itemCategory) {
          printer.text(element.item!, styles: mediumPosStyles);
        } else {
          printer.text("${element.quantity}x${element.unit} ${element.item!}", styles: mediumPosStyles);
        }
        for (final element in element.eItemAddition) {
          printer.text("  ${element!.itemAddition}");
        }
        for (final element in element.childItems) {
          var itemAdd = "+";
          var strItem = "";
          if(element!.item!.trim().startsWith("-")){
            itemAdd = "-";
            strItem = element.item!.trim().substring(1,element.item!.length);
          } else {
            strItem = element.item!.trim().substring(1,element.item!.length);
          }
          printer.text("  $itemAdd${element.quantity}x${element.unit} $strItem");
          for (final element in element.eItemAddition) {
            printer.text("    ${element!.itemAddition}");
          }
        }
      }

      printer.feed(2);
      printer.cut();
    }
    } catch(e) {
      _logger.e(_tag, "_printAllItems()", message: e.toString());
    }
  }

  String prependSpace(String item, String prependStringLength) {
    return "";
  }

  void testReceipt(NetworkPrinter printer, EKot eKot) {
    printer.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ',);
    printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: const PosStyles(codeTable: 'CP1252'),);
    printer.text('Special 2: blåbærgrød',
        styles: const PosStyles(codeTable: 'CP1252'),);

    printer.text('Bold text', styles: const PosStyles(bold: true));
    printer.text('Reverse text', styles: const PosStyles(reverse: true));
    printer.text('Underlined text', styles: const PosStyles(underline: true), linesAfter: 1);
    printer.text('Align left');
    printer.text('Align center', styles: const PosStyles(align: PosAlign.center));
    printer.text('Align right', styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

    printer.text('Text size 200%',
        styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),);

    printer.feed(2);
    printer.cut();
  }

  Future<NetworkPrinter?> _getPrinter(String ipAddress, int port) async {
    try {
      const PaperSize paper = PaperSize.mm80;
      final profile = await CapabilityProfile.load();
      final printer = NetworkPrinter(paper, profile);

      final PosPrintResult res = await printer.connect(ipAddress, port: port);
      printer.setGlobalCodeTable('CP1252');

      if (res == PosPrintResult.success) {
        return printer;
      } else {
        return null;
      }
    } catch(e) {
      _logger.e(_tag, "_getPrinter()", message: e.toString());
      return null;
    }
  }
}
