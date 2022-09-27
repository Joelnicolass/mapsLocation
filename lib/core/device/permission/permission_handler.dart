import 'package:permission_handler/permission_handler.dart';

class PermissionDevice {
  static Future<bool> locationIsGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  static Future<void> locationRequest(fnGranted, fnDenied) async {
    final status = await Permission.location.request();

    switch (status) {
      case PermissionStatus.granted:
        fnGranted();
        break;

      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        fnDenied();
        openAppSettings();
        break;
    }
  }
}
