// ignore_for_file: must_be_immutable

import 'package:craft_dynamic/src/state/plugin_state.dart';
import 'package:craft_dynamic/src/ui/dynamic_static/list_data.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:craft_dynamic/src/ui/dynamic_components.dart';
import 'package:provider/provider.dart';

class RegularFormWidget extends StatefulWidget {
  final ModuleItem moduleItem;
  final List<FormItem> sortedForms;
  final List<dynamic>? jsonDisplay, formFields;
  final bool hasRecentList;

  const RegularFormWidget(
      {super.key,
      required this.moduleItem,
      required this.sortedForms,
      required this.jsonDisplay,
      required this.formFields,
      this.hasRecentList = false});

  @override
  State<RegularFormWidget> createState() => _RegularFormWidgetState();
}

class _RegularFormWidgetState extends State<RegularFormWidget> {
  final _formKey = GlobalKey<FormState>();
  List<FormItem> formItems = [];
  FormItem? recentList;

  @override
  initState() {
    recentList = widget.sortedForms.toList().firstWhereOrNull(
        (formItem) => formItem.controlType == ViewType.LIST.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    formItems = widget.sortedForms.toList()
      ..removeWhere((element) => element.controlType == ViewType.LIST.name);

    return WillPopScope(
        onWillPop: () async {
          Provider.of<PluginState>(context, listen: false)
              .setRequestState(false);
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              elevation: 2,
              title: Text(widget.moduleItem.moduleName),
              actions: recentList != null
                  ? [
                      IconButton(
                          onPressed: () {
                            CommonUtils.navigateToRoute(
                                context: context,
                                widget: ListDataScreen(
                                    widget: DynamicListWidget(
                                            moduleItem: widget.moduleItem,
                                            formItem: recentList)
                                        .render(),
                                    title: widget.moduleItem.moduleName));
                          },
                          icon: const Icon(
                            Icons.view_list,
                            color: Colors.white,
                          ))
                    ]
                  : null,
            ),
            body: SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Form(
                        key: _formKey,
                        child: ListView.builder(
                            padding: const EdgeInsets.only(
                                left: 14, right: 14, top: 8),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: formItems.length,
                            itemBuilder: (context, index) {
                              return BaseFormComponent(
                                  formItem: formItems[index],
                                  moduleItem: widget.moduleItem,
                                  formItems: formItems,
                                  formKey: _formKey,
                                  child: IFormWidget(formItems[index],
                                          jsonText: widget.jsonDisplay,
                                          formFields: widget.formFields)
                                      .render());
                            }))
                  ],
                )))));
  }
}
