// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:craft_dynamic/src/ui/dynamic_components.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class StepperFormWidget extends StatefulWidget {
  ModuleItem moduleItem;
  List<FormItem> formItems;

  StepperFormWidget(
      {required this.moduleItem, required this.formItems, super.key});

  @override
  State<StatefulWidget> createState() => _StepperFormWidgetState();
}

class _StepperFormWidgetState extends State<StepperFormWidget> {
  int _index = 0;
  List<FormItem> stepControls = [];
  List<Step> steps = [];
  int stepperLength = 0;
  var formKey;

  @override
  void initState() {
    stepControls = widget.formItems
        .where((formItem) => formItem.controlType == ViewType.STEP.name)
        .toList();
    stepperLength = stepControls.length - 1;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    formKey = BaseFormInheritedComponent.of(context)?.formKey;
  }

  getSteps() {
    steps.clear();
    stepControls.asMap().forEach((key, step) {
      steps.add(Step(
          title: Text(step.controlText ?? ""),
          isActive: _index >= key,
          state: _index >= key ? StepState.complete : StepState.disabled,
          content: StepForm(
            formItems: widget.formItems,
            formItem: step,
            moduleItem: widget.moduleItem,
          )));
    });
  }

  @override
  Widget build(BuildContext context) {
    getSteps();
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
          title: Text(widget.moduleItem.moduleName),
        ),
        body: Stepper(
            currentStep: _index,
            onStepCancel: () {
              if (_index > 0) {
                setState(() {
                  _index -= 1;
                });
              }
            },
            onStepContinue: () {
              if (_index < stepperLength) {
                if (formKey?.currentState?.validate()!) {
                  setState(() {
                    _index += 1;
                  });
                } else {
                  Vibration.vibrate();
                }
              }
            },
            onStepTapped: (int index) {
              setState(() {
                _index = index;
              });
            },
            steps: steps));
  }

  bool getIsActive(int currentIndex, int index) {
    if (currentIndex == index) {
      return true;
    } else {
      return false;
    }
  }
}

class StepForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  List<dynamic>? jsonDisplay, formFields;
  List<FormItem> formItems;
  ModuleItem moduleItem;
  FormItem formItem;

  StepForm(
      {required this.formItems,
      required this.formItem,
      required this.moduleItem,
      super.key});

  @override
  Widget build(BuildContext context) {
    List<FormItem> stepForms = formItems
        .where(
          (item) => item.linkedToControl == formItem.controlId,
        )
        .toList();

    return Form(
        key: _formKey,
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stepForms.length,
            itemBuilder: (context, index) {
              return BaseFormComponent(
                  formItem: stepForms[index],
                  moduleItem: moduleItem,
                  formItems: stepForms,
                  formKey: _formKey,
                  child: IFormWidget(stepForms[index],
                          jsonText: jsonDisplay, formFields: formFields)
                      .render());
            }));
  }
}
