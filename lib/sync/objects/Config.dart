import 'dart:io';

class Config {

  static const String BASE_URL = "";
  static const String socketPort = "8444";
  static const String socketKPort = "8445";

  Map<String, dynamic> getSessionHeader() {
    return {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.connectionHeader: "keep-alive",
      "Access-Control-Allow-Origin": "*",
    };
  }

}
