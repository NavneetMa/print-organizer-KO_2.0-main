import 'package:kwantapo/utils/lib.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {

  final String _tag = "PermissionUtils";

  Future<bool> checkForPermissions() async {
    final PermissionStatus permissionStorage = await Permission.storage.status;
    if (permissionStorage.isGranted) {
      Logger.getInstance.e(_tag, "checkForPermissions()", message : "Permissions already granted.");
      return true;
    } else {
      Logger.getInstance.e(_tag, "checkForPermissions()", message : "Permissions not granted.");
      return false;
    }
  }

  Future<bool> requestAppPermissions() async {
    final Map<Permission, PermissionStatus> result = await [Permission.storage].request();
    bool status = true;
    result.forEach((key, value) {
      if (value != PermissionStatus.granted) {
        status = false;
      }
    });
    if (status) {
      Logger.getInstance.e(_tag, "requestAppPermissions()", message : "Permissions granted.");
    } else {
      Logger.getInstance.e(_tag, "requestAppPermissions()", message : "Permissions denied.");
    }
    return status;
  }

}
