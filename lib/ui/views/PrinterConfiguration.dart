import 'package:flutter/material.dart';
import 'package:kwantapo/lang/AppLocalization.dart';
import 'package:kwantapo/ui/activities/model/ConfigurationActivityModel.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class PrinterConfiguration extends StatefulWidget {
  final String? Function(ValidEnum,String?) validate;
  final void Function(String,ValidEnum) onSaved;
  final String colorName;
  final Function(String) onColorChange;
  final Widget Function() getPrinterTableTabletMode;
  final Widget Function() getPrinterListMobileMode;
  final Future<void> Function() savePrinterForm;
  final GlobalKey<FormState> printerForm;
  final TextEditingController? printerName;
  final TextEditingController? ipAddress;
  final TextEditingController? portNum;

  const PrinterConfiguration({Key? key,
  required this.validate,
  required this.onSaved,
  required this.colorName,
  required this.onColorChange,
  required this.getPrinterTableTabletMode,
  required this.getPrinterListMobileMode,
  required this.savePrinterForm,
  required this.printerForm,
  required this.ipAddress,
  required this.printerName,
  required this.portNum,
  }) : super(key: key);

  @override
  State<PrinterConfiguration> createState() => _PrinterConfigurationState();
}

class _PrinterConfigurationState extends State<PrinterConfiguration> {

  @override
  Widget build(BuildContext context) {
     if (ScreenUtils.getInstance.screenWidthDp <= AppConstants().mobileDevice) {
      return BorderedContainer(
        child: Form(
          key: widget.printerForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalization.instance.translate("printer_config")),
              const SizedBox(height: 10.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FormTextInput(
                      enumerate: ValidEnum.PRINTERNAME,
                      context: context,
                      controller: widget.printerName,
                      title: AppLocalization.instance.translate("Printer Name"),
                      keyboardType: TextInputType.name,
                      validate: (value){
                        return widget.validate(ValidEnum.PRINTERNAME, value) == null ? null : widget.validate(ValidEnum.PRINTERNAME, value)!;
                      },
                      onSaved: (value){
                        widget.onSaved(value!, ValidEnum.PRINTERNAME);
                      },
                    ),
                  ),
                  FittedBox(
                    child: DropdownButton(
                      underline: Container(),
                      onChanged: (value) {
                        widget.onColorChange(value.toString());
                      },
                      iconSize: 0,
                      value: widget.colorName,
                      items: Assets.colorMapList.map((e) => DropdownMenuItem(
                        value: e.name,
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Icon(Icons.circle,color: e.color,size: 30,),
                        ),
                      ),
                      ).toList(),),
                  )
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: FormTextInput(
                      enumerate: ValidEnum.IPADDRESS,
                      context: context,
                      controller: widget.ipAddress,
                      title: AppLocalization.instance.translate("ip_address"),
                      keyboardType: TextInputType.number,
                      validate: (value){
                        return widget.validate(ValidEnum.IPADDRESS, value) == null ? null : widget.validate(ValidEnum.IPADDRESS, value)!;
                      },
                      onSaved: (value){
                        widget.onSaved(value!, ValidEnum.IPADDRESS);
                      },
                    ),
                  ),
                  const Text(" : "),
                  Expanded(
                    child: FormTextInput(
                      enumerate: ValidEnum.PORT,
                      context: context,
                      controller: widget.portNum,
                      title: AppLocalization.instance.translate("port_num"),
                      keyboardType: TextInputType.number,
                      textInputAction : TextInputAction.done,
                      validate: (value){
                        return widget.validate(ValidEnum.PORT, value) == null ? null : widget.validate(ValidEnum.PORT, value)!;
                      },
                      onSaved: (value){
                        widget.onSaved(value!, ValidEnum.PORT);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    child: Text(AppLocalization.instance.translate("save")),
                    onPressed: () async {
                      widget.savePrinterForm();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              widget.getPrinterListMobileMode()
            ],
          ),
        ),
      );
    } else {
      return BorderedContainer(
        child: Form(
          key: widget.printerForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalization.instance.translate("printer_config")),
              const SizedBox(height: 6.0),
              const SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: FormTextInput(
                      enumerate: ValidEnum.PRINTERNAME,
                      context: context,
                      controller: widget.printerName,
                      title: AppLocalization.instance.translate("Printer Name"),
                      keyboardType: TextInputType.name,
                      validate: (value){
                        return widget.validate(ValidEnum.PRINTERNAME, value) == null ? null : widget.validate(ValidEnum.PRINTERNAME, value)!;
                      },
                      onSaved: (value){
                        widget.onSaved(value!, ValidEnum.PRINTERNAME);
                      },
                    ),
                  ),
                  const SizedBox(width: 3.0),
                  Expanded(
                    flex: 2,
                    child: FormTextInput(
                      enumerate: ValidEnum.IPADDRESS,
                      context: context,
                      controller: widget.ipAddress ,
                      title: AppLocalization.instance.translate("ip_address"),
                      keyboardType: TextInputType.number,
                      validate: (value){
                        return widget.validate(ValidEnum.IPADDRESS, value) == null ? null : widget.validate(ValidEnum.IPADDRESS, value)!;
                      },
                      onSaved: (value){
                        widget.onSaved(value!, ValidEnum.IPADDRESS);
                      },
                    ),
                  ),
                   Padding(
                    padding: AppSpaces().smallTop,
                    child: const Text(" : "),
                  ),
                  Expanded(
                    child: FormTextInput(
                      context: context,
                      enumerate: ValidEnum.PORT,
                      controller: widget.portNum,
                      title: AppLocalization.instance.translate("port_num"),
                      keyboardType: TextInputType.number,
                      textInputAction : TextInputAction.done,
                      validate: (value){
                        return widget.validate(ValidEnum.PORT, value) == null ? null : widget.validate(ValidEnum.PORT, value)!;
                      },
                      onSaved: (value){
                        widget.onSaved(value!, ValidEnum.PORT);
                      },
                    ),
                  ),
                  Container(
                    margin: AppSpaces().smallLeft,
                    child: FittedBox(
                      child: DropdownButton(
                        underline: Container(),
                        onChanged: (value) {
                          widget.onColorChange(value.toString());
                        },
                        value: widget.colorName,
                        items: Assets.colorMapList.map((e) => DropdownMenuItem(
                          value: e.name,
                          child: TextButton(
                            onPressed: null,
                            focusNode: FocusNode(canRequestFocus: false),
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(e.color,)),
                            child: Container(),
                          ),
                        ),
                        ).toList(),),
                    ),

                  )
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    child: Text(AppLocalization.instance.translate("save")),
                    onPressed: () async {
                      widget.savePrinterForm();
                    },
                  ),
                ],
              ),
              widget.getPrinterTableTabletMode()
            ],
          ),
        ),
      );
    }
  }
}
