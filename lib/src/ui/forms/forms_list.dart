// ignore_for_file: must_be_immutable

import 'package:craft_dynamic/src/ui/forms/stepper_form.dart';
import 'package:flutter/material.dart';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/database.dart';
import 'package:craft_dynamic/src/ui/dynamic_components.dart';
import 'package:craft_dynamic/src/ui/forms/regular_form.dart';
import 'package:craft_dynamic/src/ui/forms/tab_form.dart';
import 'package:craft_dynamic/src/util/widget_util.dart';

class FormsListWidget extends StatefulWidget {
  ModuleItem moduleItem;
  bool isWizard;
  int? nextFormSequence;
  List<dynamic>? jsonDisplay, formFields;

  FormsListWidget(
      {Key? key,
      required this.moduleItem,
      this.jsonDisplay,
      this.formFields,
      this.nextFormSequence,
      this.isWizard = false})
      : super(key: key);

  @override
  State<FormsListWidget> createState() => _FormsListWidgetState();
}

class _FormsListWidgetState extends State<FormsListWidget> {
  int? currentForm;
  final _formsRepository = FormsRepository();

  getFormItems() =>
      _formsRepository.getFormsByModuleId(widget.moduleItem.moduleId);

  @override
  Widget build(BuildContext context) {
    DynamicInput.formInputValues.clear();
    DynamicInput.encryptedField.clear();

    return FutureBuilder<List<FormItem>>(
        future: getFormItems(),
        builder:
            (BuildContext context, AsyncSnapshot<List<FormItem>> snapshot) {
          Widget child = const SizedBox();
          if (snapshot.hasData) {
            int? currentFormSequence = widget.nextFormSequence;
            debugPrint("Current form sequence...$currentFormSequence");
            if (currentFormSequence != null) {
              if (currentFormSequence == 0) {
                currentForm = 2;
              } else {
                currentForm = currentFormSequence;
              }
            } else {
              if (widget.isWizard) {
                currentForm = 2;
              } else {
                currentForm = 1;
              }
            }
            List<FormItem> filteredFormItems = snapshot.data!
                .where(
                    (formItem) => formItem.formSequence == (currentForm ?? 1))
                .toList()
              ..sort(((a, b) {
                return a.displayOrder!.compareTo(b.displayOrder!);
              }));
            List<FormItem> sortedForms =
                WidgetUtil.sortForms(filteredFormItems);
            bool hasRecentList = filteredFormItems
                .map((item) => item.controlType)
                .contains(ViewType.LIST.name);

            bool isTabWidget = filteredFormItems
                .map((item) => item.controlType)
                .contains(ViewType.CONTAINER.name);

            bool isStepperWigdet = filteredFormItems
                .map((item) => item.controlType)
                .contains(ViewType.STEPPER.name);

            if (isTabWidget) {
              child = TabWidget(
                title: "test",
                formItems: filteredFormItems,
                moduleItem: widget.moduleItem,
              );
            } else if (isStepperWigdet) {
              child = StepperFormWidget(
                moduleItem: widget.moduleItem,
                formItems: filteredFormItems,
              );
            } else {
              child = RegularFormWidget(
                moduleItem: widget.moduleItem,
                sortedForms: sortedForms,
                jsonDisplay: widget.jsonDisplay,
                formFields: widget.formFields,
                hasRecentList: hasRecentList,
              );
            }
          }

          return child;
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
