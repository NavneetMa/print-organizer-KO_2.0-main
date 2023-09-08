import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class PrinterTable extends StatefulWidget {
  final Function(PrinterController, int)? sendPrintCheckbox;
  final Function(PrinterController, int)? removePrintCheckbox;
  const PrinterTable(this.sendPrintCheckbox,this.removePrintCheckbox);

  @override
  State<PrinterTable> createState() => _PrinterTableState();
}

class _PrinterTableState extends State<PrinterTable> {
  final _printerController=Get.put(PrinterController());
  final Map<int, TableColumnWidth>? columnWidths = {
    0: const FlexColumnWidth(50),
    1: const FlexColumnWidth(150),
    2: const FlexColumnWidth(100),
    3: const FlexColumnWidth(80),
    4: const FlexColumnWidth(80),
    5: const FlexColumnWidth(80),
  };
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          columnWidths: columnWidths,
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(
              color: AppTheme.grey,),
          children: [
            TableRow(
                children: [
                  getDataCell("Send/Remove"),
                  getDataCell(AppLocalization.instance.translate("printer_name")),
                  getDataCell(AppLocalization.instance.translate("ip_address")),
                  getDataCell(AppLocalization.instance.translate("port_num")),
                  getDataCell(AppLocalization.instance.translate("color")),
                  getDataCell(""),
                ],
            ),
          ],
        ),
        getTableData()
      ],
    );
  }

  Widget getTableData() {
    return Obx(() => Table(
      columnWidths: columnWidths,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
          color: AppTheme.grey,
      ),
      children: getTableRow(),
    ),);
  }

  List<TableRow> getTableRow(){
    final List<TableRow> list=[];
    PrinterController.printers.asMap().forEach((index,element) =>
        list.add(TableRow(
            children: [
              TableCell(child: Column(
                children: [
                  Checkbox(value: element.isSend, onChanged: (value) {
                    widget.sendPrintCheckbox!(_printerController,index);
                  },),
                  Checkbox(value: element.isRemove, onChanged: (value) {
                 widget.removePrintCheckbox!(_printerController,index);
                  },),
                ],
              ),),
              TableCell(child: getDatacellContainer(element.name),),
              TableCell(child: getDatacellContainer(element.ipAddress),),
              TableCell(child: getDatacellContainer(element.port)),
              TableCell(child: getColorWidget(element.color),),
              TableCell(child: TextButton(onPressed: ()=> DataService.getInstance.deletePrinter(element.id), child: const Icon(Icons.delete, color: AppTheme.darkRed,)),),
            ],
        ),),
    );
    return list;
  }

  Widget getColorWidget(String colorName){
    final ColorMap colorMap=Assets.colorMapList.singleWhere((element) => element.name==colorName);
    return Container(margin: AppSpaces().mediumHorizontal,child: TextButton(onPressed: null, style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorMap.color)), child: Container(),),);
  }

  Widget getDataCell(String value){
    return TableCell(child:Container(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),child: Text(value),));
  }

  Widget getDatacellContainer(String value){
    return Container(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),child: Text(value),);
  }
}
