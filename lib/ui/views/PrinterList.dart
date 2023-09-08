import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class PrinterList extends StatefulWidget {
  final Function(PrinterController printerController, int value)? sendPrintCheckbox;
  final Function(PrinterController, int)? removePrintCheckbox;
  const PrinterList(this.sendPrintCheckbox,this.removePrintCheckbox);

  @override
  State<PrinterList> createState() => _PrinterListState();
}

class _PrinterListState extends State<PrinterList> {
  final PrinterController _printerController = Get.put(PrinterController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: PrinterController.printers.length,
      itemBuilder: (context, index) {
        return Container(
          margin: AppSpaces().smallVertical,
          padding: AppSpaces().smallLeft,
          decoration: BoxDecoration(
            color: AppTheme.nearlyWhite,
            border: Border.all(color: AppTheme.greyBorder),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BorderedContainer(
                      child: Text("${AppLocalization.instance.translate("printer_name")}: ${PrinterController.printers[index].name}"),),
                    ),
                  Container(
                    margin: AppSpaces().smallLeftRight,
                    child: getColorWidget(PrinterController.printers[index].color),
                  ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: BorderedContainer(
                        child: Text("${AppLocalization.instance.translate("ip_address")}: ${PrinterController.printers[index].ipAddress}:${PrinterController.printers[index].port}"),),
                    ),
                    Expanded(
                      flex: 0,
                        child: Padding(
                          padding: AppSpaces().mediumLeft,
                          child: IconButton(
                          onPressed: () => DataService.getInstance.deletePrinter(PrinterController.printers[index].id),
                          icon: const Icon(
                            Icons.delete,
                            color: AppTheme.darkRed,
                          ),
                      ),
                        ),
                    )
                  ],
                ),
              Padding(
                padding: AppSpaces().mediumLeft,
                child: Row(
                  children: [
                    const Text('Send'),
                    Checkbox(
                        activeColor: AppTheme.colorAccent,
                        value:PrinterController.printers[index].isSend,
                        onChanged: (value) {
                          widget.sendPrintCheckbox!(_printerController,index);
                        },),
                    const Spacer(),
                    const Text('Remove'),
                    Checkbox(
                        activeColor: AppTheme.colorAccent,
                        value:PrinterController.printers[index].isRemove,
                        onChanged: (value) {
                         widget.removePrintCheckbox!(_printerController,index);
                        },),

                  ],
                ),
              ),

              ],
            ),
          );
        },),
    );
  }

  Widget getColorWidget(String colorName) {
    final ColorMap colorMap = Assets.colorMapList.singleWhere((element) => element.name == colorName);
    return Icon(Icons.circle, color: colorMap.color,);
  }
}
