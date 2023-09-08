import 'dart:io';
import 'package:kwantapo/utils/lib.dart';

class NetworkUtils {

  final String _tag = "NetworkUtils";

  Future<bool?> isConnectedToInternet() async {
    return InternetAddress.lookup('google.com').then((result) {
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    }).catchError((error) {
      Logger.getInstance.e(_tag, "isConnectedToInternet()", message: error.toString());
      return false;
    });
  }
}
