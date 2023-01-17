import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AlertUtil {
  static showAlertDialog(BuildContext context, String message,
      {isConfirm = false}) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      // user must tap button!
      pageBuilder: (BuildContext context, anim1, anim2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 34),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            title: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("packages/craft_dynamic/assets/lottie/error.json",
                    height: 110, width: 110)
              ],
            )),
            content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    child: ListBody(
                  children: <Widget>[
                    Center(
                        child: Text(
                      message,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    )),
                  ],
                ))),
            actions: <Widget>[
              Row(
                mainAxisAlignment: isConfirm
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.center,
                children: [
                  isConfirm
                      ? Row(
                          children: [
                            OutlinedButton(
                                style: const ButtonStyle(),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text("Cancel")),
                            const SizedBox(
                              width: 12,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  Align(
                      child: OutlinedButton(
                          style: const ButtonStyle(),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text("Ok"))),
                ],
              )
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
