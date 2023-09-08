import 'package:intl/intl.dart';
import 'package:kwantapo/db/lib.dart';
import 'package:kwantapo/ui/interfaces/ILoadingDialog.dart';
import 'package:kwantapo/ui/interfaces/IMessageDialog.dart';
import 'package:kwantapo/utils/lib.dart';

class SnoozeTimeService {

  static SnoozeTimeService? _instance;
  factory SnoozeTimeService() => getInstance;
  SnoozeTimeService._();

  static SnoozeTimeService get getInstance {
    if (_instance == null) {
      _instance = SnoozeTimeService._();
    }
    return _instance!;
  }

  late IMessageDialog iMessageDialog;
  late ILoadingDialog iLoadingDialog;

  void setMessageDialog(IMessageDialog iMessageDialog){
    this.iMessageDialog = iMessageDialog;
  }

  void setLoadingDialog(ILoadingDialog iLoadingDialog){
    this.iLoadingDialog = iLoadingDialog;
  }
  static const String _TAG = "SnoozeTimeService";
  final Logger _logger = Logger.getInstance;


  Future<void> updateDateTime(int id, String snoozeDateTime) async {
    try{
      final DatabaseManager dm = await DatabaseHelper.getInstance;
      await dm.kotDao.updateDateTime(id, snoozeDateTime);
    }catch(e){
      _logger.e(_TAG, "updateDateTime()", message: e.toString());
    }
  }

  Future<void> updateHideKot(int id, bool hideKot) async {
    try{
      final DatabaseManager dm = await DatabaseHelper.getInstance;
      await dm.kotDao.updateHideKot(id, hideKot);
    }catch(e){
      _logger.e(_TAG, "updateHideKot()", message: e.toString());
    }
  }

  int getHour() {
    int number=0;
    final DateTime now = DateTime.now();
    // Create a DateFormat object using the 24-hour clock format
    final DateFormat timeFormat = DateFormat('Hm');
    // Get the current time in the 24-hour clock format
    String formattedTime = timeFormat.format(now);
    // Remove any spaces from the time string
    formattedTime = formattedTime.replaceAll(RegExp(r'\s'), '');
    // Get the hours from the time string
    final String hours = formattedTime.substring(0, 2);
    number=int.parse(hours);
    int hour = number;
    for (int i = 0; i< AppConstants().twentyFourHourFormat.length; i++) {
      if(AppConstants().twentyFourHourFormat[i]==number){
        hour = i;
        break;
      }
    }
    return hour;
  }
}