import 'package:kwantapo/data/entities/lib.dart';

abstract class IMasterTerminalService {
  Future<bool> postToMasterTerminal(EMT emt, {bool isKotFinished = false});

  Future<void> addReceivedKot(EMT emt);

  Future<bool> updateKotIsFinished(int id, String duration);

  Future<void> sendReceivedKot(EMT emt);

  Future<void> sendFinishedKot(int id, String duration);
}
