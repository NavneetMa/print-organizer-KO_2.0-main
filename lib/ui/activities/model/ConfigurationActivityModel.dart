import 'package:flutter/foundation.dart';
import 'package:kwantapo/controllers/PrinterController.dart';
import 'package:kwantapo/services/DataService.dart';

enum ValidEnum {
  PRINTERNAME,IPADDRESS,PORT
}

class ConfigurationActivityModel{
  static ConfigurationActivityModel? _instance;
  factory ConfigurationActivityModel() => getInstance;
  ConfigurationActivityModel._();

  static ConfigurationActivityModel get getInstance {
    _instance ??= ConfigurationActivityModel._();
    return _instance!;
  }

  void sendPrinterCheckbox(PrinterController printerController, int index){
    printerController.updatePrinterIsToSend(index);
    if(PrinterController.printers[index].isSend==true){
      PrinterController.printers[index].isRemove=false;
    }
    if (kDebugMode) {
      print(PrinterController.printers[index].toJson().toString());
    }
    DataService.getInstance.updatePrinterIsSend(PrinterController.printers[index].id, PrinterController.printers[index].isSend); //TODO: Sandeep - initially id is sent as null
    DataService.getInstance.updatePrinterIsRemove(PrinterController.printers[index].id, PrinterController.printers[index].isRemove); //TODO: Sandeep - initially id is sent as null
  }

  void removePrinterCheckbox(PrinterController printerController, int index){
    printerController.updatePrinterIsToRemove(index);
    if(PrinterController.printers[index].isRemove==true){
      PrinterController.printers[index].isSend=false;
    }
    if (kDebugMode) {
      print(PrinterController.printers[index].toJson().toString());
    }
    DataService.getInstance.updatePrinterIsRemove(PrinterController.printers[index].id, PrinterController.printers[index].isRemove); //TODO: Sandeep - initially id is sent as null
    DataService.getInstance.updatePrinterIsSend(PrinterController.printers[index].id, PrinterController.printers[index].isSend); //TODO: Sandeep - initially id is sent as null
  }

   String? validate(ValidEnum valid,String? value){
    switch(valid){
      case  ValidEnum.IPADDRESS:
        const String pattern = r'(^(?=\d+\.\d+\.\d+\.\d+$)(?:(?:25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])\.?){4}$)';
        final RegExp regExp = RegExp(pattern);
        if(value!.isEmpty){
          return 'Please add IP-address';
        }
        if(!regExp.hasMatch(value)){
          return 'Please add valid IP-address';
        }
        return null;

      case ValidEnum.PORT:
        if(value!.isEmpty){
          return "Can't be empty";
        }
        if(value.length <4 || value.length>4){
          return '4 digits only';
        }
        return null;
      case ValidEnum.PRINTERNAME:
        if(value!.isEmpty){
          return "Can't be empty";
        }
        return null;
    }
  }



}