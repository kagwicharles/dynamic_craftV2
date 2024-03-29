// ignore_for_file: must_be_immutable

import 'package:craft_dynamic/src/ui/dynamic_static/list_data.dart';
import 'package:flutter/material.dart';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:craft_dynamic/src/ui/dynamic_components.dart';
import 'package:craft_dynamic/src/util/widget_util.dart';
import 'package:provider/provider.dart';

import '../../state/plugin_state.dart';

class RadioWidget extends StatefulWidget {
  List<FormItem> formItems;
  String title;
  ModuleItem moduleItem;
  Function? updateState;

  RadioWidget(
      {super.key,
      required this.title,
      required this.formItems,
      required this.moduleItem,
      this.updateState});

  @override
  State<RadioWidget> createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {
  FormItem? recentList;
  List<FormItem> radioFormControls = [];

  @override
  void initState() {
    radioFormControls = widget.formItems;
    try {
      recentList = radioFormControls.firstWhere(
        (item) => item.controlType == ViewType.LIST.name,
      );
      debugPrint("Recent list::::$recentList");
    } catch (e) {
      debugPrint("Error:::$e");
    }
    radioFormControls
        .removeWhere((formItem) => formItem.controlType == ViewType.LIST.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
          title: Text(widget.moduleItem.moduleName),
        ),
        body: RadioWidgetList(
          formItems: radioFormControls,
          moduleItem: widget.moduleItem,
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class RadioWidgetList extends StatefulWidget {
  final List<FormItem> formItems;
  ModuleItem moduleItem;

  RadioWidgetList(
      {super.key, required this.formItems, required this.moduleItem});

  @override
  State<RadioWidgetList> createState() => _RadioWidgetListState();
}

class _RadioWidgetListState extends State<RadioWidgetList> {
  final _formKey = GlobalKey<FormState>();
  List<FormItem> sortedForms = [];
  List<Widget> chips = [];
  List<FormItem> chipChoices = [];
  List<FormItem> rButtonForms = [];
  int? _value = 0;

  @override
  void initState() {
    super.initState();
  }

  List<FormItem> getRButtons() => widget.formItems
      .where((formItem) => formItem.controlType == ViewType.RBUTTON.name)
      .toList();

  addChips(List<FormItem> formItems) {
    chips.clear();
    chipChoices.clear();
    formItems.asMap().forEach((index, formItem) {
      chipChoices.add(formItem);
      chips.add(Expanded(
          flex: 1,
          child: Container(
              margin: const EdgeInsets.only(right: 2),
              child: ChoiceChip(
                selectedColor: APIService.appSecondaryColor,
                labelStyle: TextStyle(
                  overflow: TextOverflow.visible,
                  color: _value == index
                      ? Colors.white
                      : APIService.appSecondaryColor,
                ),
                label: SizedBox(
                  width: double.infinity,
                  child: Text(formItem.controlText ?? ""),
                ),
                selected: _value == index,
                onSelected: (bool selected) {
                  if (_value != index) {
                    setState(() {
                      _value = selected ? index : null;
                    });
                  }
                },
              ))));
    });
  }

  getRButtonForms(FormItem formItem) {
    sortedForms.clear();
    rButtonForms.clear();
    rButtonForms = widget.formItems
        .where((element) =>
            element.linkedToControl == formItem.controlId ||
            element.linkedToControl == "" ||
            element.linkedToControl == null)
        .toList();

    rButtonForms
        .removeWhere((element) => element.controlType == ViewType.LIST.name);
    sortedForms = WidgetUtil.sortForms(rButtonForms);
  }

  @override
  Widget build(BuildContext context) {
    addChips(getRButtons());
    getRButtonForms(chipChoices[_value ?? 0]);

    return WillPopScope(
        onWillPop: () async {
          Provider.of<PluginState>(context, listen: false)
              .setRequestState(false);
          return true;
        },
        child: SizedBox(
            height: double.infinity,
            // padding: containsQR
            //     ? const EdgeInsets.only(left: 8, right: 8, top: 8)
            //     : const EdgeInsets.symmetric(
            //         horizontal: 0,
            //       ),
            child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.max, children: [
              const SizedBox(
                height: 12,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 8),
                  child: Align(
                      child: Row(
                    children: chips,
                  ))),
              const SizedBox(
                height: 18,
              ),
              Form(
                  key: _formKey,
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding:
                          const EdgeInsets.only(left: 14, right: 14, top: 8),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sortedForms.length,
                      itemBuilder: (context, index) {
                        return BaseFormComponent(
                            formItem: sortedForms[index],
                            moduleItem: widget.moduleItem,
                            formKey: _formKey,
                            formItems: sortedForms,
                            child: IFormWidget(
                              sortedForms[index],
                            ).render());
                      }))
            ]))));
  }
}
