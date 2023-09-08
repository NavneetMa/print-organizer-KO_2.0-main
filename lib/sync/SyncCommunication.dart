import 'package:dio/dio.dart';
import 'package:kwantapo/data/ResCode.dart';
import 'package:kwantapo/data/dto/Res.dart';
import 'package:kwantapo/sync/interfaces/IKitchenModeApiService.dart';
import 'package:kwantapo/sync/interfaces/IKitchenSumModeApiService.dart';
import 'package:kwantapo/sync/lib.dart';
import 'package:kwantapo/utils/lib.dart';
import 'package:retrofit/retrofit.dart';

class SyncCommunication {

  static SyncCommunication? _instance;
  factory SyncCommunication() => getInstance;
  SyncCommunication._();

  static SyncCommunication get getInstance {
    _instance ??= SyncCommunication._();
    return _instance!;
  }

  final String _tag = "SyncCommunication";
  final Logger _logger = Logger.getInstance;
  final Dio _dio = Dio();

  Future<HttpResponse<dynamic>> sendReceivedKot(Map<String, dynamic> data) async {
    _dio.options.headers = Config().getSessionHeader();
    _logger.d(_tag, "sendReceivedKot()", message: "Sending data to master terminal using : ${data["mtIp"]}");
    return IKassaService(_dio, baseUrl: "http://${data["mtIp"]}").sendReceivedKot(
      currentTimestamp: DateTimeUtils.getInstance.formatKassaTime(data["currentTime"].toString()),
      tableName: data["tableName"].toString(),
      userName: data["userName"].toString(),
      receivedTimestamp: DateTimeUtils.getInstance.formatKassaTime(data["receivedTime"].toString()),
      noOfItems: data["numOfItems"] as int,
      ipAddress: data["poIp"].toString(),
    ).catchError((Object obj) {
      Logger.getInstance.e(_tag, "sendReceivedKot()", message: (obj as DioError).message);
    });
  }

  Future<HttpResponse<dynamic>> sendFinishedKot(Map<String, dynamic> data) async {
    _dio.options.headers = Config().getSessionHeader();
    _logger.d(_tag, "sendFinishedKot()", message: "Sending data to master terminal using : ${data["mtIp"]}");
    return IKassaService(_dio, baseUrl: "http://${data["mtIp"]}").sendFinishedKot(
      currentTimestamp: DateTimeUtils.getInstance.formatKassaTime(data["currentTime"].toString()),
      tableName: data["tableName"].toString(),
      userName: data["userName"].toString(),
      receivedTimestamp: DateTimeUtils.getInstance.formatKassaTime(data["receivedTime"].toString()),
      finishedTimestamp: DateTimeUtils.getInstance.formatKassaTime(data["finishedTime"].toString()),
      durationTillFinished: data["kotLiveDuration"].toString(),
      noOfItems: data["numOfItems"] as int,
      category: data["category"].toString(),
      ipAddress: data["poIp"].toString(),
    ).catchError((Object obj) {
      Logger.getInstance.e(_tag, "sendFinishedKot()", message: (obj as DioError).message);
    });
  }

  Future<dynamic> sendKotToKitchenSumMode(Map<String, dynamic> data) async {
    _dio.options.headers = Config().getSessionHeader();
    _logger.d(_tag, "sendKotToKitchenSumMode()", message: "Sending data to master terminal using : ${data["ipAddress"]}");
    return IKitchenSumModeApiService(_dio, baseUrl: "http://${data["ipAddress"]}:${Config.socketPort}").sendKotToKitchenSumMode(
      data: data['data'].toString(),
      methodName: data['methodName'].toString(),
    ).catchError((Object obj) {
      Logger.getInstance.e(_tag, "sendKotToKitchenSumMode()", message: (obj as DioError).message);
      return Res(ResCode().failed, (obj as DioError).message,"").toJson();
    });
  }

  Future<dynamic> hideKotOnKOTSnoozeTimeAdded(Map<String, dynamic> data) async {
    _dio.options.headers = Config().getSessionHeader();
    _logger.d(_tag, "hideKotOnKOTSnoozeTimeAdded()", message: "Sending data to master terminal using : ${data["ipAddress"]}");
    return IKitchenSumModeApiService(_dio, baseUrl: "http://${data["ipAddress"]}:${Config.socketPort}").hideKotOnKOTSnoozeTimeAdded(
      data: data['data'].toString(),
      methodName: data['methodName'].toString(),
    ).catchError((Object obj) {
      Logger.getInstance.e(_tag, "hideKotOnKOTSnoozeTimeAdded()", message: (obj as DioError).message);
      return Res(ResCode().failed, (obj as DioError).message,"").toJson();
    });
  }

  Future<dynamic> resetHiddenKot(Map<String, dynamic> data) async {
    _dio.options.headers = Config().getSessionHeader();
    _logger.d(_tag, "resetHiddenKot()", message: "Sending data to master terminal using : ${data["ipAddress"]}");
    return IKitchenSumModeApiService(_dio, baseUrl: "http://${data["ipAddress"]}:${Config.socketPort}").resetHiddenKot(
      data: data['data'].toString(),
      methodName: data['methodName'].toString(),
    ).catchError((Object obj) {
      Logger.getInstance.e(_tag, "resetHiddenKot()", message: (obj as DioError).message);
      return Res(ResCode().failed, (obj as DioError).message,"").toJson();
    });
  }

  Future<dynamic> showKotAfterSnoozeTimeIsOver(Map<String, dynamic> data) async {
    _dio.options.headers = Config().getSessionHeader();
    _logger.d(_tag, "showKotAfterSnoozeTimeIsOver()", message: "Sending data to master terminal using : ${data["ipAddress"]}");
    return IKitchenSumModeApiService(_dio, baseUrl: "http://${data["ipAddress"]}:${Config.socketPort}").showKotAfterSnoozeTimeIsOver(
      data: data['data'].toString(),
      methodName: data['methodName'].toString(),
    ).catchError((Object obj) {
      Logger.getInstance.e(_tag, "showKotAfterSnoozeTimeIsOver()", message: (obj as DioError).message);
      return Res(ResCode().failed, (obj as DioError).message,"").toJson();
    });
  }

  Future<dynamic> removeItemFromSum(Map<String, dynamic> data) async {
    _dio.options.headers = Config().getSessionHeader();
    _logger.d(_tag, "removeItemFromSum()", message: "Sending data to master terminal using : ${data["ipAddress"]}");
    return IKitchenSumModeApiService(_dio, baseUrl: "http://${data["ipAddress"]}:${Config.socketPort}").removeItemFromSum(
      data: data['data'].toString(),
      methodName: data['methodName'].toString(),
    ).catchError((Object obj) {
      Logger.getInstance.e(_tag, "removeItemFromSum()", message: (obj as DioError).message);
      return Res(ResCode().failed, (obj as DioError).message,"").toJson();
    });
  }

  Future<dynamic> removeItemFromKot(Map<String, dynamic> data) async {
    _dio.options.headers = Config().getSessionHeader();
    _logger.d(_tag, "removeItemFromKot()", message: "Sending data to master terminal using : ${data["ipAddress"]}");
    return IKitchenSumModeApiService(_dio, baseUrl: "http://${data["ipAddress"]}:${Config.socketPort}").removeItemFromKot(
      data: data['data'].toString(),
      methodName: data['methodName'].toString(),
    ).catchError((Object obj) {
      Logger.getInstance.e(_tag, "removeItemFromKot()", message: (obj as DioError).message);
      return Res(ResCode().failed, (obj as DioError).message,"").toJson();
    });
  }

  Future<dynamic> deleteKot(Map<String, dynamic> data) async {
    _dio.options.headers = Config().getSessionHeader();
    _logger.d(_tag, "deleteKot()", message: "Sending data to master terminal using : ${data["ipAddress"]}");
    return IKitchenSumModeApiService(_dio, baseUrl: "http://${data["ipAddress"]}:${Config.socketPort}").deleteKot(
      data: data['data'].toString(),
      methodName: data['methodName'].toString(),
    ).catchError((Object obj) {
      Logger.getInstance.e(_tag, "deleteKot()", message: (obj as DioError).message);
      return Res(ResCode().failed, (obj as DioError).message,"").toJson();
    });
  }

  Future<dynamic> dismissKot(Map<String, dynamic> data) async {
    _dio.options.headers = Config().getSessionHeader();
    _logger.d(_tag, "dismissKot()", message: "Sending data to master terminal using : ${data["ipAddress"]}");
    return IKitchenSumModeApiService(_dio, baseUrl: "http://${data["ipAddress"]}:${Config.socketPort}").dismissKot(
      data: data['data'].toString(),
      methodName: data['methodName'].toString(),
    ).catchError((Object obj) {
      Logger.getInstance.e(_tag, "dismissKot()", message: (obj as DioError).message);
      return Res(ResCode().failed, (obj as DioError).message,"").toJson();
    });
  }

  Future<dynamic> addUndoKotItem(Map<String, dynamic> data) async {
    _dio.options.headers = Config().getSessionHeader();
    _logger.d(_tag, "addUndoKotItem()", message: "Sending data to master terminal using : ${data["ipAddress"]}");
    return IKitchenSumModeApiService(_dio, baseUrl: "http://${data["ipAddress"]}:${Config.socketPort}").addUndoKotItem(
      data: data['data'].toString(),
      methodName: data['methodName'].toString(),
    ).catchError((Object obj) {
      Logger.getInstance.e(_tag, "addUndoKotItem()", message: (obj as DioError).message);
      return Res(ResCode().failed, (obj as DioError).message,"").toJson();
    });
  }

  Future<dynamic> getAllKotData(Map<String, dynamic> data) async {
    _dio.options.headers = Config().getSessionHeader();
    _logger.d(_tag, "getAllKotData()", message: "Sending data to master terminal using : ${data["ipAddress"]}");
    return IKitchenModeApiService(_dio, baseUrl: "http://${data["ipAddress"]}:${Config.socketKPort}"). getAllKotData(
      data: data['data'].toString(),
      methodName: data['methodName'].toString(),
    ).catchError((Object obj) {
      Logger.getInstance.e(_tag, "getAllKotData()", message: (obj as DioError).message);
      return Res(ResCode().failed, (obj as DioError).message,"").toJson();
    });
  }

  Future<dynamic> getSnoozedKotData(Map<String, dynamic> data) async {
    _dio.options.headers = Config().getSessionHeader();
    _logger.d(_tag, "getSnoozedKotData()", message: "Sending data to master terminal using : ${data["ipAddress"]}");
    return IKitchenModeApiService(_dio, baseUrl: "http://${data["ipAddress"]}:${Config.socketKPort}"). getSnoozedKotData(
      data: data['data'].toString(),
      methodName: data['methodName'].toString(),
    ).catchError((Object obj) {
      Logger.getInstance.e(_tag, "getSnoozedKotData()", message: (obj as DioError).message);
      return Res(ResCode().failed, (obj as DioError).message,"").toJson();
    });
  }

}
