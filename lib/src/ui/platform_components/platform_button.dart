import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class IElevatedButton {
  factory IElevatedButton(TargetPlatform targetPlatform) {
    switch (targetPlatform) {
      case TargetPlatform.android:
        return AndroidButton();

      case TargetPlatform.iOS:
        return IOSButton();

      default:
        return AndroidButton();
    }
  }

  Widget getPlatformButton(Function() function, String buttonTitle);
}

class IOSButton implements IElevatedButton {
  @override
  Widget getPlatformButton(Function() function, String buttonTitle) {
    return CupertinoButton(onPressed: function, child: Text(buttonTitle));
  }
}

class AndroidButton implements IElevatedButton {
  @override
  Widget getPlatformButton(Function() function, String buttonTitle) {
    return ElevatedButton(onPressed: function, child: Text(buttonTitle));
  }
}
