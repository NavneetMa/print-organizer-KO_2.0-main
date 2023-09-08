import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:kwantapo/data/ResCode.dart';
import 'package:kwantapo/data/dto/Res.dart';
import 'package:kwantapo/data/podos/APIData.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class NetworkService {
  static NetworkService? _instance;
  factory NetworkService() => getInstance;
  NetworkService._();

  static NetworkService get getInstance {
    _instance ??= NetworkService._();
    return _instance!;
  }

  final String _tag = "NetworkService";
  static ServerSocket? _serverSocket;
  final Logger _logger = Logger.getInstance;

  Future<void> initializeSocketServer(String ipAddress, String port) async {
    try {
      _logger.e(_tag, "initializeSocketServer()", message: "Device IP : $ipAddress Port : $port");
      await PrefUtils().setPOIpAddress(ipAddress);
      await PrefUtils().setPOPort(port);
      if (AppConstants.selectedMode == AppConstants.KITCHEN_SUM_MODE){
        return;
      }
      await ServerSocket.bind(ipAddress, int.parse(port), shared: true).then((server) {
        _serverSocket = server;
        _logger.e(_tag, "initializeSocketServer() bind", message: "Server running on IP : $ipAddress on port : $port",);
        if (AppConstants.context != null) {
          Snack().show(AppConstants.context!, "PO Server is initialized");
        }
      }).catchError((error) {
        _logger.e(_tag, "initializeSocketServer()", message: error.toString());
        if (AppConstants.context != null) {
          Snack().show(AppConstants.context!, "Something went wrong");
        }
        Future.delayed(const Duration(minutes: 1), () {
          initializeSocketServer(ipAddress, port);
        });
      });
      _serverSocket!.listen(
        (Socket event) {
          _logger.d(_tag, "handleConnection()", message: "Connection from ${event.remoteAddress.address}:${event.remotePort}");
          List<int> dataList = [];
          event.listen(
            (List<int> data) {
              dataList.addAll(data);
            },
            onError: (Object error) {
              _logger.e(_tag, "handleConnection() - onError()", message: "Client socket closed $error");
              event.close();
            },
            onDone: () async{
              await _processData(dataList, event);
            },
          );
        },
      );
    } catch (error) {
      _logger.e(_tag, "initializeSocketServer() - onError", message: error.toString());
    }
  }

  Future<void> _processData(List<int> finalData, Socket event) async {
    switch (AppConstants.selectedMode) {
      case AppConstants.KITCHEN_SUM_MODE:
        // Res res = await KitchenSumModeAPI.getInstance.receivedData(utf8.decode(finalData));
        // event.write(res);
        // event.flush();
        // event.close();
        break;
      case AppConstants.KITCHEN_MODE:
        await DataService.getInstance.interpretRawData(finalData);
        event.flush();
        event.close();
        break;
    }
  }


  String _ipAddress = "";
  String _port = "";

  Future<bool> _setIpAndPortOfKitchenSumMode() async {
    try {
      _ipAddress = await PrefUtils().getKitchenSumModeIpAddress();
      _port = await PrefUtils().getKitchenSumModePort();
      if (_ipAddress == "0.0.0.0" || _ipAddress.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      _logger.e(_tag, "_setIpAndPortOfKitchenSumMode()", message: e.toString());
    }
    return false;
  }

  Future<Res> post(String apiName, dynamic data) async {
    Res res = Res(ResCode().failed, "No Response","");
    try {
      if(await _setIpAndPortOfKitchenSumMode()) {
        final Socket socket = await Socket.connect(_ipAddress, int.parse(_port));
        final List<int> message = [];
        socket.setOption(SocketOption.tcpNoDelay, true);
        socket.encoding = utf8;
        socket.write(jsonEncode(ApiData(apiName: apiName, data: data)));
        socket.timeout(
          const Duration(seconds: 5),
          onTimeout: (sink) {
            sink.addError(
              res = Res(0, "Process took too much time",""),
            );
          },
        );
        socket.listen(
          (List<int> data) {
            if (kDebugMode) {
              print(data);
            }
            message.addAll(message);
          },
          onError: (Object onError) {
            res = Res(0, "Process took too much time","");
          },
          onDone: () {
            res = Res.fromJson(jsonDecode(latin1.decode(message)) as Map<String, dynamic>);
          },);
        socket.destroy();
      } else {
        res = Res(ResCode().ipNotFound, "No Response","");
      }
    } catch (e) {
      _logger.e(_tag, "post()", message: e.toString());
    }
    return res;
  }

  Future<Res> _get() async{
    Res res = Res(ResCode().failed, "No Response","");
    try {
      if(await _setIpAndPortOfKitchenSumMode()) {
        final Socket socket = await Socket.connect(_ipAddress, int.parse(_port));
        final client = HttpClient();

        try {
          HttpClientRequest request = await client.get(_ipAddress, int.parse(_port), '/file.txt');
          // Optionally set up headers...
          // Optionally write to the request object...
          HttpClientResponse response = await request.close();
          // Process the response
          final stringData = await response.transform(utf8.decoder).join();
          print(stringData);
        } finally {
          client.close();
        }
      } else {
        res = Res(ResCode().ipNotFound, "No Response","");
      }
    } catch (e) {
      _logger.e(_tag, "post()", message: e.toString());
    }
    return res;
  }
}
