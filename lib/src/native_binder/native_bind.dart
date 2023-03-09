import 'package:flutter/services.dart';

class NativeBinder {
  static const platform = MethodChannel('craft_dynamic');

  static Future<void> invokeMethod(String littleProduct) async {
    await platform.invokeMethod('getLittleProduct', <String, dynamic>{
      'littleProduct': littleProduct,
    });
  }
}
