// ignore_for_file: must_be_immutable

import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import '../../../craft_dynamic.dart';
import '../../state/plugin_state.dart';

class RequestStatusScreen extends StatefulWidget {
  RequestStatusScreen(
      {Key? key,
      required this.message,
      required this.statusCode,
      this.moduleItem})
      : super(key: key);

  String message;
  String statusCode;
  ModuleItem? moduleItem;

  @override
  State<RequestStatusScreen> createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen>
    with SingleTickerProviderStateMixin {
  late var _controller;

  @override
  void initState() {
    Vibration.vibrate(duration: 500);
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 5000), () {
          if (!mounted) {
            _controller.forward(from: 0.0);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          widget.moduleItem != null &&
                  widget.moduleItem?.moduleId == ModuleId.PIN.name
              ? logout()
              : closePage();
          return true;
        },
        child: Scaffold(
            body: SingleChildScrollView(
                child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            const SizedBox(
              height: 44,
            ),
            Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () {
                    widget.moduleItem != null &&
                            widget.moduleItem?.moduleId == ModuleId.PIN.name
                        ? logout()
                        : closePage();
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.close,
                            color: Color(0xff15549A),
                            size: 34,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            "CLOSE",
                            style: Theme.of(context).textTheme.labelSmall,
                          )
                        ],
                      )),
                )),
            const Spacer(),
            Expanded(
                flex: 4,
                child: Center(
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.blue[50]),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 9,
                              child: Column(
                                children: [
                                  Lottie.asset(getAvatarType(widget.statusCode),
                                      height: 88,
                                      width: 88,
                                      controller: _controller,
                                      onLoaded: (comp) {
                                    _controller
                                      ..duration = comp.duration
                                      ..forward();
                                  }),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    widget.message,
                                    style: const TextStyle(
                                        fontSize: 14, height: 1.5),
                                    textAlign: TextAlign.center,
                                  ))),
                                ],
                              ),
                            )
                          ],
                        )))),
            const Spacer(),
            Align(
                alignment: Alignment.bottomCenter,
                child: WidgetFactory.buildButton(
                    context,
                    widget.moduleItem != null &&
                            widget.moduleItem?.moduleId == "PIN"
                        ? logout
                        : closePage,
                    "Done")),
            const SizedBox(
              height: 15,
            )
          ]),
        ))));
  }

  String getAvatarType(String statusCode) {
    switch (statusCode) {
      case "000":
        return "packages/craft_dynamic/assets/lottie/success.json";

      case "099":
        return "packages/craft_dynamic/assets/lottie/error.json";
    }
    return "packages/craft_dynamic/assets/lottie/information.json";
  }

  void logout() {
    Widget? logoutScreen =
        Provider.of<PluginState>(context, listen: false).logoutScreen;
    if (logoutScreen != null) {
      CommonUtils.navigateToRoute(context: context, widget: logoutScreen);
    }
  }

  void closePage() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
