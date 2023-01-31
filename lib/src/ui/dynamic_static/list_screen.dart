// ignore_for_file: must_be_immutable

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

class ListWidget extends StatelessWidget {
  ListWidget(
      {Key? key,
      required this.scrollable,
      this.dynamicList = const [],
      this.controlID,
      this.serviceParamID,
      this.moduleItem})
      : super(key: key);

  final bool scrollable;
  String? controlID, serviceParamID;
  ModuleItem? moduleItem;
  List<dynamic>? dynamicList;
  List<Map> mapItems = [];

  @override
  Widget build(BuildContext context) {
    // return Text(jsonTxt!.toString());
    if (dynamicList != null) {
      for (var item in dynamicList!) {
        debugPrint("Adding...$item");
        mapItems.add(item);
      }
    }
    return dynamicList != null && dynamicList!.isNotEmpty
        ? SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.max, children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: mapItems.length,
              itemBuilder: (context, index) {
                var mapItem = mapItems[index];
                mapItem
                    .removeWhere((key, value) => key == null || value == null);
                debugPrint("New map...$mapItem");
                return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Material(
                            elevation: 2,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                            child: InkWell(
                                onTap: () {
                                  // if (controlID == "BIBLELIST") {
                                  //   Navigator.pop(context);
                                  //   CommonLibs.navigateToRoute(
                                  //       context: context,
                                  //       widget: StaticDynamic(
                                  //         moduleItem: moduleItem!,
                                  //         formSequence: 2,
                                  //         jsonDisplay: mapItem,
                                  //         serviceParamID: serviceParamID,
                                  //       ));
                                  // }
                                },
                                borderRadius: BorderRadius.circular(4.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 4.0),
                                  child: Column(
                                    children: mapItem
                                        .map((key, value) => MapEntry(
                                            key,
                                            Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "$key:",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium,
                                                    ),
                                                    Flexible(
                                                        child: Text(
                                                      value.toString(),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ))
                                                  ],
                                                ))))
                                        .values
                                        .toList(),
                                  ),
                                ))),
                        const SizedBox(
                          height: 12,
                        )
                      ],
                    ));
              },
            )
          ]))
        : Center(
            child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "packages/craft_dynamic/assets/images/empty.png",
                height: 64,
                width: 64,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                "No transactions yet!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ));
  }
}
