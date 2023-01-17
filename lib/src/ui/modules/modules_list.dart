// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/database.dart';
import 'package:craft_dynamic/dynamic_widget.dart';

class ModulesListWidget extends StatefulWidget {
  final Orientation orientation;
  final ModuleItem? moduleItem;
  FrequentAccessedModule? favouriteModule;

  ModulesListWidget({
    super.key,
    required this.orientation,
    required this.moduleItem,
    this.favouriteModule,
  });

  @override
  State<ModulesListWidget> createState() => _ModulesListWidgetState();
}

class _ModulesListWidgetState extends State<ModulesListWidget> {
  final _moduleRepository = ModuleRepository();

  getModules() =>
      _moduleRepository.getModulesById(widget.favouriteModule == null
          ? widget.moduleItem!.moduleId
          : widget.favouriteModule!.moduleID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 2,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: Text(widget.favouriteModule == null
                ? widget.moduleItem!.moduleName
                : widget.favouriteModule!.moduleName)),
        body: FutureBuilder<List<ModuleItem>>(
            future: getModules(),
            builder: (BuildContext context,
                AsyncSnapshot<List<ModuleItem>> snapshot) {
              Widget child = const Center(child: Text("Please wait..."));
              if (snapshot.hasData) {
                debugPrint("Modules....${snapshot.data?.toList()}");
                child = SizedBox(
                    height: double.infinity,
                    child: GridView.builder(
                        // physics: const NeverScrollableScrollPhysics(),
                        padding:
                            const EdgeInsets.only(left: 12, right: 12, top: 8),
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (widget.orientation == Orientation.portrait)
                                    ? 2
                                    : 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 4,
                            childAspectRatio: 4 / 2),
                        itemBuilder: (BuildContext context, int index) {
                          var module = snapshot.data![index];
                          return ModuleItemWidget(moduleItem: module);
                        }));
              }
              return child;
            }));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
