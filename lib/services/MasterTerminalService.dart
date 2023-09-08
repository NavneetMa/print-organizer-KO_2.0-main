import 'package:kwantapo/data/entities/lib.dart';
import 'package:kwantapo/db/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/sync/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class MasterTerminalService implements IMasterTerminalService {

  static MasterTerminalService? _instance;
  factory MasterTerminalService() => getInstance;
  MasterTerminalService._();

  static MasterTerminalService get getInstance {
    _instance ??= MasterTerminalService._();
    return _instance!;
  }

  final String _tag = "MasterTerminalService";
  final Logger _logger = Logger.getInstance;

  @override
  Future<bool> postToMasterTerminal(EMT? emt, {bool isKotFinished = false}) async {
    try {
      final String? ipAddress = await PrefUtils().getMasterTerminalIpAddress();
      final String? port = await PrefUtils().getMasterTerminalPort();
      if (ipAddress != "0.0.0.0" && ipAddress != "" && ipAddress != null) {
        _logger.d(_tag, "postToMasterTerminal()", message: "Connecting to master terminal at $ipAddress:$port");
        if (emt != null) {
          _logger.d(_tag, "postToMasterTerminal()", message: "Sending data to master terminal $ipAddress:$port");
          _logger.e(_tag, "postToMasterTerminal()", message: "Terminal : $ipAddress:$port\nData : ${emt.toJson().toString()}");
          if (isKotFinished) {
            await SyncCommunication.getInstance.sendFinishedKot(emt.toJson());
          } else {
            await SyncCommunication.getInstance.sendReceivedKot(emt.toJson());
          }
        } else {
          _logger.d(_tag, "postToMasterTerminal()", message: "No data found to print.");
          return false;
        }
        return true;
      } else {
        _logger.e(_tag, "postToMasterTerminal()", message: "No master terminal IP configured.");
        return false;
      }
    } catch (error) {
      _logger.e(_tag, "postToMasterTerminal()", message: error.toString());
      return false;
    }
  }



  @override
  Future<void> addReceivedKot(EMT emt) async {
    try {
      final DatabaseManager manager = await DatabaseHelper.getInstance;
      manager.mtDao.insert(emt);
      sendReceivedKot(emt);
    } catch (error) {
      _logger.e(_tag, "addReceivedKot()", message: error.toString());
    }
  }

  @override
  Future<bool> updateKotIsFinished(int id, String duration) async {
    try {
      final String currentDateTime = DateTime.now().toString();
      final DatabaseManager manager = await DatabaseHelper.getInstance;
      final EMT? emt = await manager.mtDao.getById(id);
      emt!.currentTime = currentDateTime;
      emt.finishedTime = currentDateTime;
      emt.kotLiveDuration = duration;
      await manager.mtDao.updateFinishedTime(id, currentDateTime, duration);
      return true;
    } catch (error) {
      _logger.e(_tag, "updateKotIsFinished()", message: error.toString());
      return false;
    }
  }

  @override
  Future<void> sendFinishedKot(int id, String duration) async {
    try {
      final String currentDateTime = DateTime.now().toString();
      final DatabaseManager manager = await DatabaseHelper.getInstance;
      final EMT? emt = await manager.mtDao.getById(id);
      emt!.currentTime = currentDateTime;
      emt.finishedTime = currentDateTime;
      emt.kotLiveDuration = duration;
      emt.poIp = "${await PrefUtils().getPOIpAddress()}:${(await PrefUtils().getPOPort())!}";
      emt.mtIp = "${(await PrefUtils().getMasterTerminalIpAddress())!}:${(await PrefUtils().getMasterTerminalPort())!}";
      await updateKotIsFinished(id, duration);
      final bool success = await postToMasterTerminal(emt, isKotFinished: true);
      if (success) {
        await manager.mtDao.delete(id);
      }
    } catch (error) {
      _logger.e(_tag, "sendFinishedKot()", message: error.toString());
    }
  }

  @override
  Future<void> sendReceivedKot(EMT emt) async {
    try {
      emt.poIp = "${await PrefUtils().getPOIpAddress()}:${(await PrefUtils().getPOPort())!}";
      emt.mtIp = "${(await PrefUtils().getMasterTerminalIpAddress())!}:${(await PrefUtils().getMasterTerminalPort())!}";
      //await addReceivedKot(emt);
      await postToMasterTerminal(emt);
    } catch (error) {
      _logger.e(_tag, "sendReceivedKot()", message: error.toString());
    }
  }

}
