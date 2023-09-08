import 'package:kwantapo/ui/activities/model/ConfigurationActivityModel.dart';

class ConfigurationSumModeActivityModel{
  static ConfigurationSumModeActivityModel? _instance;
  factory ConfigurationSumModeActivityModel() => getInstance;
  ConfigurationSumModeActivityModel._();

  static ConfigurationSumModeActivityModel get getInstance {
    _instance ??= ConfigurationSumModeActivityModel._();
    return _instance!;
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