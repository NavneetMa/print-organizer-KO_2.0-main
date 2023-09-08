import 'dart:convert';
import 'dart:io';

import 'package:kwantapo/utils/lib.dart';
import 'package:logger/logger.dart' as logger;
import 'package:path_provider/path_provider.dart';

class Logger {

  static Logger? _instance;
  factory Logger() => getInstance;
  Logger._();
  static logger.Logger? _logger;

  static Logger get getInstance {
    if (_instance == null) {
      _instance = Logger._();
      _logger = logger.Logger();
    }
    return _instance!;
  }

  final String _tag = "Logger";

  void e(String tag, String methodName, {String? message}) {
    final DateTime time = DateTime.now();
    if (message != null) {
      _logger?.e("$tag : $methodName - $message");
    } else {
      _logger?.e("$tag : $methodName");
    }
    writeData(" $tag | $methodName | $message | ${time.hour}:${time.minute}:${time.second} - ${time.day}/${time.month}/${time.year} | ${AppConstants().appVersion}");
  }

  void d(String tag, String methodName, {String? message}) {
    if (message != null) {
      _logger?.d("$tag : $methodName - $message");
    } else {
      _logger?.d("$tag : $methodName");
    }
  }

  Future<String?> get localPath async => (Platform.isAndroid ? await getApplicationDocumentsDirectory() : await getApplicationSupportDirectory()).path;

  Future<File> get localFile async {
    final path = await localPath;
    return File("$path/KWANTA_PO_LOGS.txt");
  }

  Future<void> writeData(String? message) async {
    await localFile.then((file) {
      file.writeAsString("$message\n\n", encoding: Encoding.getByName("UTF-8")!, mode: FileMode.append);
    }).catchError((error) {
      d(_tag, "writeData()", message: error.toString());
    });
  }

  Future<String> readData() async {
    return localFile.then((file) async {
      return file.readAsString();
    }).catchError((error) {
      d(_tag, "readData()", message: error.toString());
      return "Nothing saved yet";
    });
  }

  Future<void> clearData() async {
    await localFile.then((file) {
      file.openWrite();
    }).catchError((error) {
      d(_tag, "clearData()", message: error.toString());
    });
  }

}
