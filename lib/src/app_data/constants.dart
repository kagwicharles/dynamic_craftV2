import 'dart:io' show Platform;

import 'package:package_info_plus/package_info_plus.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:uuid/uuid.dart';

class Constants {
  static var uuid = const Uuid();

  var version = "";

  Constants() {
    getPackageName();
  }

  void getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.packageName;
  }

  static getImei() async {
    return UniqueIdentifier.serial;
  }

  static String getHostPlatform() {
    if (Platform.isIOS) {
      return "IOS";
    } else {
      return "ANDROID";
    }
  }

  static getUniqueID() {
    return uuid.v1();
  }
}
