import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension StringCapitalization on String {
  String capitalizeWords(String separator) {
    var words = split(separator);
    var capitalizedWords =
        words.map((word) => word[0].toUpperCase() + word.substring(1));
    return capitalizedWords.join(separator);
  }
}

extension ModuleIdExt on ModuleId {
  String get name => describeEnum(this);
}

extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
