import 'package:intl/intl.dart';
import 'package:kwantapo/utils/lib.dart';

class DateTimeUtils{

  static DateTimeUtils? _instance;
  factory DateTimeUtils() => getInstance;
  DateTimeUtils._();

  static DateTimeUtils get getInstance {
    _instance ??= DateTimeUtils._();
    return _instance!;
  }

  final String _tag = "DateTimeUtils";
  final Logger _logger = Logger.getInstance;
  
  /*String getTimePassed(DateTime dateTime) {
    var today = DateTime.now();
    String passedTime=formatKotTime(today.subtract(Duration(
      hours: dateTime.hour,
      minutes: dateTime.minute,
      seconds: dateTime.second,
    )).toString());
    if(passedTime.substring(0,2)=="12"){
      passedTime="00:"+passedTime.substring(3,passedTime.length);
    }
    return passedTime;
    //return (today.hour-dateTime.hour).toString()+":"+(today.minute-dateTime.minute).toString()+":"+(today.second).toString();
  }*/

  String getTimePassed(DateTime dateTime) {
    String passedTime = "";
    try {
      final format = DateFormat('kk:mm:ss');
      final today = format.parse(DateFormat('kk:mm:ss').format(DateTime.now()));
      final receivedTime = format.parse(DateFormat('kk:mm:ss').format(dateTime));
      passedTime = today.difference(receivedTime).toString().split(".")[0];
    } catch (error) {
      _logger.d(_tag, "getTimePassed()", message: error.toString());
    }
    return passedTime;
  }

  String formatKotTime(String time) {
    return DateFormat('kk:mm:ss').format(DateTime.parse(time));
  }

  String formatKassaTime(String dateTime) {
    return DateFormat("dd.MM.yyyy HH:mm:ss").format(DateTime.parse(dateTime));
  }
}
