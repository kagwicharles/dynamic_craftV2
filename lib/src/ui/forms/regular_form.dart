// ignore_for_file: must_be_immutable

import 'package:craft_dynamic/src/state/plugin_state.dart';
import 'package:craft_dynamic/src/ui/dynamic_static/list_data.dart';
import 'package:craft_dynamic/src/util/common_lib_util.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    formItems = widget.sortedForms.toList()
      ..removeWhere((element) => element.controlType == ViewType.LIST.name);

    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: Text(widget.moduleItem.moduleName),
          actions: widget.hasRecentList
              ? [
                  IconButton(
                      onPressed: () {
                        CommonUtils.navigateToRoute(
                            context: context,
                            widget: ListDataScreen(
                                widget: DynamicListWidget().render(),
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
                        padding:
                            const EdgeInsets.only(left: 14, right: 14, top: 8),
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
            ))));
  }

  @override
  void dispose() {
    Provider.of<PluginState>(context, listen: false).setRequestState(false);
    super.dispose();
  }
}
