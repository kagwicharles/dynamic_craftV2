import 'package:flutter/services.dart';

class NativeBinder {
  static const platform = MethodChannel('flutter.native/helper');

  static Future<void> invokeMethod(String littleProduct) async {
    await platform.invokeMethod('getLittleProduct', <String, dynamic>{
      'littleProduct': littleProduct,
    });
  }
}
