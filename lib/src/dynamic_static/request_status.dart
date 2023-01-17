// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vibration/vibration.dart';

class RequestStatusScreen extends StatefulWidget {
  RequestStatusScreen(
      {Key? key, required this.message, required this.statusCode})
      : super(key: key);

  String message;
  String statusCode;

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
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: MediaQuery.of(context).size.height,
      child: Column(children: [
        const SizedBox(
          height: 44,
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              onPressed: () {
                closePage();
              },
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                        // Expanded(
                        //   flex: 1,
                        //   child: Text(
                        //     widget.statusCode == "000" ? "Success:" : "Error:",
                        //     style: const TextStyle(
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.w800,
                        //         height: 1.5),
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),
                        Expanded(
                          flex: 9,
                          child: Column(
                            children: [
                              Lottie.asset(getAvatarType(widget.statusCode),
                                  height: 64,
                                  width: 64,
                                  controller: _controller, onLoaded: (comp) {
                                _controller
                                  ..duration = comp.duration
                                  ..forward();
                              }),
                              Expanded(
                                  child: Center(
                                      child: Text(
                                widget.message,
                                style:
                                    const TextStyle(fontSize: 14, height: 1.5),
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
            child: ElevatedButton(
                onPressed: () {
                  closePage();
                },
                child: const Text("Close"))),
        const SizedBox(
          height: 15,
        )
      ]),
    )));
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
