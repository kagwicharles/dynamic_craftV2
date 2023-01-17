// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:collection';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:camera/camera.dart';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/dynamic_static/grouped_button.dart';
import 'package:craft_dynamic/src/dynamic_static/list_screen.dart';
import 'package:craft_dynamic/src/dynamic_static/qr_scanner.dart';
import 'package:craft_dynamic/src/network/dynamic_request.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:craft_dynamic/src/providers/group_button_provider.dart';
import 'package:craft_dynamic/src/state/plugin_state.dart';
import 'package:craft_dynamic/src/util/common_lib_util.dart';
import 'package:craft_dynamic/src/util/dynamic_util.dart';
import 'package:craft_dynamic/src/util/extensions_util.dart';
import 'package:craft_dynamic/src/util/widget_util.dart';

class DynamicInput {
  static List<Map<String?, dynamic>> formInputValues = [];
  static Map<String?, dynamic> encryptedField = {};
}

class BaseFormComponent extends StatelessWidget {
  const BaseFormComponent(
      {super.key,
      required this.child,
      required this.formItem,
      required this.moduleItem,
      required this.formItems,
      required this.formKey});

  final Widget child;
  final FormItem formItem;
  final ModuleItem moduleItem;
  final List<FormItem> formItems;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BaseFormInheritedComponent(
          widget: child,
          formItem: formItem,
          moduleItem: moduleItem,
          formItems: formItems,
          formKey: formKey,
        ),
        formItem.controlType == ViewType.HIDDEN.name ||
                formItem.controlType == ViewType.CONTAINER.name ||
                formItem.controlType == ViewType.RBUTTON.name ||
                formItem.controlType == ViewType.TAB.name ||
                formItem.controlType == ViewType.LIST.name ||
                formItem.controlType == ViewType.TITLE.name ||
                formItem.controlType == ViewType.SELECTEDTEXT.name ||
                formItem.controlType == ViewType.FORM.name ||
                formItem.controlType == ViewType.IMAGE.name
            ? const SizedBox()
            : const SizedBox(
                height: 18,
              )
      ],
    );
  }
}

class BaseFormInheritedComponent extends InheritedWidget {
  final FormItem formItem;
  final ModuleItem moduleItem;
  final List<FormItem> formItems;
  final GlobalKey<FormState> formKey;
  final Widget widget;
  List<dynamic>? jsonText;

  BaseFormInheritedComponent(
      {Key? key,
      required this.widget,
      required this.formItem,
      required this.moduleItem,
      required this.formItems,
      required this.formKey,
      this.jsonText})
      : super(key: key, child: widget);

  static BaseFormInheritedComponent? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BaseFormInheritedComponent>();
  }

  @override
  bool updateShouldNotify(covariant BaseFormInheritedComponent oldWidget) {
    return oldWidget.formItem != formItem;
  }
}

class DynamicTextFormField extends StatefulWidget implements IFormWidget {
  Function? func;
  bool isEnabled;
  String? customText;
  TextEditingController? controller;

  DynamicTextFormField(
      {Key? key,
      this.isEnabled = true,
      this.func,
      this.customText,
      this.controller})
      : super(key: key);

  @override
  Widget render() {
    return DynamicTextFormField();
  }

  @override
  State<DynamicTextFormField> createState() => _DynamicTextFormFieldState();
}

class _DynamicTextFormFieldState extends State<DynamicTextFormField> {
  var controller = TextEditingController();
  var inputType = TextInputType.text;
  bool isObscured = false;
  IconButton? suffixIcon;
  FormItem? formItem;

  @override
  void initState() {
    super.initState();
    if (widget.customText != null) {
      controller.text = widget.customText!;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    formItem = BaseFormInheritedComponent.of(context)?.formItem;
  }

  updateControllerText(String value) {
    debugPrint("Setting value..$value");
    controller.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PluginState>(builder: (context, state, child) {
      isObscured = formItem?.controlFormat == ControlFormat.PinNumber.name ||
              formItem?.controlFormat == ControlFormat.PIN.name
          ? true
          : false;

      var textFieldParams = WidgetUtil.checkControlFormat(
          formItem!.controlFormat!,
          context: context,
          isObscure: isObscured,
          refreshParent: refreshParent);
      inputType = textFieldParams['inputType'];

      var properties = TextFormFieldProperties(
        isEnabled: widget.isEnabled,
        isObscured: isObscured ? state.obscureText : false,
        controller: controller,
        textInputType: inputType,
        inputDecoration: InputDecoration(
          // border: const OutlineInputBorder(),
          labelText: formItem?.controlText,
          suffixIcon: textFieldParams['suffixIcon'],
        ),
      );

      return WidgetFactory.buildTextField(context, properties, validator);
    });
  }

  String? validator(String? value) {
    var formattedValue = value.toString().replaceAll(',', '');
    if (formItem!.isMandatory! && value!.isEmpty) {
      return 'Input required*';
    }
    debugPrint("Max value:::${formItem?.controlId}");

    if (inputType == TextInputType.number &&
        formItem?.controlFormat == ControlFormat.Amount.name) {
      if (formItem?.maxValue != null) {
        if (formItem!.maxValue!.isNotEmpty) {
          if (int.parse(formattedValue) > int.parse(formItem!.maxValue!)) {
            return "Input exceeds max value(${formItem!.maxValue})";
          }
          if (formItem?.minValue != null) {
            if (int.parse(formattedValue) < int.parse(formItem!.minValue!)) {
              return "Input less min value(${formItem?.minValue})";
            }
          }
        }
      }
    }
    if (isObscured) {
      DynamicInput.encryptedField[formItem?.serviceParamId] =
          CryptLib.encryptField(formattedValue);
    } else {
      DynamicInput.formInputValues
          .add({"${formItem?.serviceParamId}": "$value"});
    }
    return null;
  }

  void refreshParent(bool status, {newText}) {
    debugPrint("New data selected!...$newText");
    setState(() {
      status;
      controller.text = DateFormat('yyyy-MM-dd').format(newText);
    });
  }
}

class HiddenWidget implements IFormWidget {
  List<dynamic>? formFields;
  FormItem? formItem;

  HiddenWidget({this.formFields, this.formItem});

  @override
  Widget render() {
    String controlValue = "";
    if (formFields != null) {
      formFields?.forEach((formField) {
        if (formField[FormFieldProp.ControlID.name] == formItem?.controlId) {
          controlValue = formField[FormFieldProp.ControlValue.name];
        }
      });
      if (controlValue.isNotEmpty) {
        DynamicInput.formInputValues
            .add({"${formItem?.serviceParamId}": controlValue});
      }
    } else {
      DynamicInput.formInputValues
          .add({"${formItem?.serviceParamId}": "${formItem?.controlValue}"});
    }
    return const Visibility(
      visible: false,
      child: SizedBox(),
    );
  }
}

class DynamicButton extends StatefulWidget implements IFormWidget {
  const DynamicButton({super.key});

  @override
  Widget render() {
    return const DynamicButton();
  }

  @override
  State<DynamicButton> createState() => _DynamicButtonState();
}

class _DynamicButtonState extends State<DynamicButton> {
  final _dynamicRequest = DynamicFormRequest();
  FormItem? formItem;
  ModuleItem? moduleItem;
  var formKey;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    formItem = BaseFormInheritedComponent.of(context)?.formItem;
    moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;
    formKey = BaseFormInheritedComponent.of(context)?.formKey;
  }

  @override
  Widget build(BuildContext context) {
    // AppLogger.appLogI(
    //     tag: "Button",
    //     message: "${formItem?.serviceParamId}..${formItem?.controlId}");
    return Builder(builder: (BuildContext context) {
      return Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(vertical: 34),
          child: Consumer<PluginState>(builder: (context, state, child) {
            return state.loadingNetworkData
                ? Lottie.asset("assets/lottie/loading_list.json")
                : WidgetFactory.buildButton(
                    context, onClick, formItem!.controlText!.capitalize());
          }));
    });
  }

  onClick() {
    if (formItem?.controlId == "CLOSE") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      return;
    }

    if (formItem?.controlFormat == ControlFormat.OPENFORM.name) {
      CommonUtils.navigateToRoute(
          context: context,
          widget: DynamicWidget(
            moduleItem: moduleItem,
          ));
      return;
    }

    if (formKey?.currentState?.validate()!) {
      Provider.of<PluginState>(context, listen: false).setRequestState(true);

      _dynamicRequest
          .dynamicRequest(moduleItem!,
              formItem: formItem,
              dataObj: DynamicInput.formInputValues,
              encryptedField: DynamicInput.encryptedField,
              context: context,
              tappedButton: true)
          .then((value) => DynamicUtil.processDynamicResponse(
              value!.dynamicData!, context, formItem!.controlId!,
              moduleItem: moduleItem));
    } else {
      Vibration.vibrate();
    }
  }
}

class DynamicDropDown implements IFormWidget {
  FormItem? formItem;
  ModuleItem? moduleItem;
  String? _currentValue;

  @override
  Widget render() {
    return Builder(builder: (BuildContext context) {
      formItem = BaseFormInheritedComponent.of(context)?.formItem;
      moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;

      return FutureBuilder<Map<String, dynamic>?>(
          future: getDropDownValues(formItem!, moduleItem!),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>?> snapshot) {
            Widget child = DropdownButtonFormField2(
              value: _currentValue,
              hint: Text(
                formItem!.controlText!,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              isExpanded: true,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              items: const [],
            );
            if (snapshot.hasData) {
              var dropdownItems = snapshot.data;
              var dropdownPicks = dropdownItems?.entries
                  .map((item) => DropdownMenuItem(
                        value: item.key,
                        child: Text(
                          item.value,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ))
                  .toList();
              debugPrint("Dropdown items...${dropdownPicks?.toList()}");
              dropdownPicks?.toSet().toList();
              if (dropdownPicks != null) {
                if (dropdownPicks.isNotEmpty) {
                  _currentValue = dropdownPicks[0].value;
                }
              }

              child = DropdownButtonFormField2(
                value: _currentValue,
                decoration: InputDecoration(labelText: formItem?.controlText),
                isExpanded: true,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                onChanged: ((value) => {_currentValue = value.toString()}),
                validator: (value) {
                  DynamicInput.formInputValues
                      .add({"${formItem?.serviceParamId}": "$value"});
                },
                items: dropdownPicks,
              );
            }
            return child;
          });
    });
  }

  Future<Map<String, dynamic>?>? getDropDownValues(
      FormItem formItem, ModuleItem moduleItem) async {
    return await IDropDownAdapter(formItem, moduleItem).getDropDownItems();
  }
}

class DynamicLabelWidget implements IFormWidget {
  DynamicResponse? dynamicResponse;
  final _dynamicRequest = DynamicFormRequest();

  getDynamicLabel(
          BuildContext context, FormItem formItem, ModuleItem moduleItem) =>
      _dynamicRequest.dynamicRequest(
        moduleItem,
        formItem: formItem,
        dataObj: DynamicInput.formInputValues,
        encryptedField: DynamicInput.encryptedField,
        isList: true,
        context: context,
      );

  @override
  Widget render() {
    return Builder(builder: (BuildContext context) {
      var formItem = BaseFormInheritedComponent.of(context)?.formItem;
      var moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;

      return formItem!.controlFormat == ControlFormat.LISTDATA.name
          ? FutureBuilder<DynamicResponse?>(
              future: getDynamicLabel(context, formItem, moduleItem!),
              builder: (BuildContext context,
                  AsyncSnapshot<DynamicResponse?> snapshot) {
                Widget child = Text(formItem.controlText!);
                if (snapshot.hasData) {
                  var dynamicResponse = snapshot.data;
                  DynamicUtil.processDynamicResponse(
                      dynamicResponse!.dynamicData!,
                      context,
                      formItem.controlId!);

                  child = DynamicTextViewWidget(
                          jsonText: dynamicResponse.dynamicList)
                      .render();
                }
                return child;
              })
          : Text(
              formItem.controlText!,
              style: const TextStyle(fontSize: 16),
            );
    });
  }
}

class DynamicTextViewWidget implements IFormWidget {
  List<dynamic>? jsonText;
  List<LinkedHashMap> mapItems = [];

  DynamicTextViewWidget({
    Key? key,
    this.jsonText,
  });

  @override
  Widget render() {
    // return Text(jsonTxt!.toString());
    jsonText?.forEach((item) {
      mapItems.add(item);
    });
    return Builder(builder: (BuildContext context) {
      return Column(children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mapItems.length,
          itemBuilder: (context, index) {
            var mapItem = mapItems[index];
            mapItem.removeWhere(
                (key, value) => key == null || value == null || value == "");

            return Material(
                elevation: 2,
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Column(
                    children: mapItem
                        .map((key, value) => MapEntry(
                            key,
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      textAlign: TextAlign.right,
                                      style:
                                          const TextStyle(fontFamily: "Roboto"),
                                    ))
                                  ],
                                ))))
                        .values
                        .toList(),
                  ),
                ));
          },
        ),
        const SizedBox(
          height: 12,
        )
      ]);
    });
  }
}

class DynamicQRScanner implements IFormWidget {
  @override
  Widget render() {
    return Builder(builder: (BuildContext context) {
      return Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: () {
              CommonUtils.navigateToRoute(
                  context: context, widget: const QRScanner());
            },
            child: Image.asset(
              "packages/craft_dynamic/assets/images/qr-code.png",
              width: 200,
              height: 200,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "QR Code quick scan",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 12,
          ),
          const Text("Tap on the above image to start scanning")
        ],
      );
    });
  }
}

class DynamicPhonePickerFormWidget extends StatefulWidget
    implements IFormWidget {
  const DynamicPhonePickerFormWidget({super.key});

  @override
  State<DynamicPhonePickerFormWidget> createState() =>
      _DynamicPhonePickerFormWidgetState();

  @override
  Widget render() {
    return const DynamicPhonePickerFormWidget();
  }
}

class _DynamicPhonePickerFormWidgetState
    extends State<DynamicPhonePickerFormWidget> {
  String? number;

  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var formItem = BaseFormInheritedComponent.of(context)?.formItem;

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: formItem?.controlText,
        suffixIcon: IconButton(
            icon: Icon(
              Icons.contacts,
              color: APIService.appPrimaryColor,
            ),
            onPressed: () async {
              final PhoneContact contact =
                  await FlutterContactPicker.pickPhoneContact();
              number = contact.phoneNumber?.number;
              controller.text = number!;
            }),
      ),
      validator: (value) {
        DynamicInput.formInputValues
            .add({"${formItem?.serviceParamId}": "$value"});
        return null;
      },
      style: const TextStyle(fontSize: 16),
    );
  }
}

class DynamicListWidget implements IFormWidget {
  DynamicResponse? dynamicResponse;
  final _dynamicRequest = DynamicFormRequest();
  FormItem? formItem;
  ModuleItem? moduleItem;

  getDynamicList(context, formItem, moduleItem) =>
      _dynamicRequest.dynamicRequest(
        moduleItem,
        formItem: formItem,
        dataObj: DynamicInput.formInputValues,
        encryptedField: DynamicInput.encryptedField,
        isList: true,
        context: context,
      );

  @override
  Widget render() {
    return Builder(builder: (BuildContext context) {
      formItem = BaseFormInheritedComponent.of(context)?.formItem;
      moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;

      return isEmptyList()
          ? const Visibility(visible: false, child: SizedBox())
          : FutureBuilder<DynamicResponse?>(
              future: getDynamicList(context, formItem, moduleItem),
              builder: (BuildContext context,
                  AsyncSnapshot<DynamicResponse?> snapshot) {
                Widget child = const SizedBox();
                if (snapshot.hasData) {
                  dynamicResponse = snapshot.data;
                  DynamicUtil.processDynamicResponse(
                      dynamicResponse!.dynamicData!,
                      context,
                      formItem!.controlId!);

                  child = ListWidget(
                    dynamicList: dynamicResponse?.dynamicList,
                    scrollable: false,
                    controlID: formItem?.controlId,
                    moduleItem: moduleItem,
                    serviceParamID: formItem?.serviceParamId,
                  );
                }
                return child;
              });
    });
  }

  bool isEmptyList() {
    if (formItem?.controlFormat != null &&
            formItem!.controlFormat!.isNotEmpty ||
        formItem?.actionId == null ||
        formItem?.actionId == "") {
      return true;
    }
    EasyLoading.show(status: "Processing");
    return false;
  }
}

class DynamicHyperLink implements IFormWidget {
  @override
  Widget render() {
    return Builder(builder: (BuildContext context) {
      var formItem = BaseFormInheritedComponent.of(context)?.formItem;
      if (formItem?.controlValue != null) {
        CommonUtils.openUrl(Uri.parse(formItem!.controlValue!));
        Navigator.pop(context);
      }
      return const Visibility(visible: false, child: SizedBox());
    });
  }
}

class DynamicImageUpload extends StatefulWidget implements IFormWidget {
  const DynamicImageUpload({super.key});

  @override
  State<DynamicImageUpload> createState() => _DynamicImageUpload();

  @override
  Widget render() {
    return const DynamicImageUpload();
  }
}

class _DynamicImageUpload extends State<DynamicImageUpload> {
  String? imageFile;
  FormItem? formItem;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    formItem = BaseFormInheritedComponent.of(context)?.formItem;

    return FutureBuilder<List<CameraDescription>>(
        future: availableCameras(),
        // a previously-obtained Future<String> or null
        builder: (BuildContext context,
            AsyncSnapshot<List<CameraDescription>> snapshot) {
          Widget child = const SizedBox();
          if (snapshot.hasData) {
            child = InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: () async {
                  final XFile? photo =
                      await _picker.pickImage(source: ImageSource.camera);
                  setState(() {
                    imageFile = photo?.path;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formItem!.controlText!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0)),
                      width: double.infinity,
                      height: 177,
                      child: imageFile == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                  Icon(
                                    Icons.add_a_photo,
                                    size: 34,
                                    color: Colors.blueGrey,
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text("Tap to take picture")
                                ])
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                File(imageFile!),
                                fit: BoxFit.fitWidth,
                              )),
                    )
                  ],
                ));
          }
          return child;
        });
  }
}

class DynamicLinkedContainer extends StatefulWidget implements IFormWidget {
  const DynamicLinkedContainer({super.key});

  @override
  State<StatefulWidget> createState() => _DynamicLinkedContainerState();

  @override
  Widget render() {
    return const DynamicLinkedContainer();
  }
}

class _DynamicLinkedContainerState extends State<DynamicLinkedContainer> {
  String? controlFormat;
  List<String> buttons = [];
  List<Widget> widgets = [];
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var formItem = BaseFormInheritedComponent.of(context)?.formItem;
    var formItems = BaseFormInheritedComponent.of(context)?.formItems;

    if (formItem?.controlFormat == ControlFormat.HorizontalScroll.name) {
      for (var item in formItems!) {
        if (item.controlType == ViewType.SELECTEDTEXT.name) {
          buttons.add(item.controlText!);
        }
        if (item.controlType == ViewType.TEXT.name) {
          widgets.add(const SizedBox(
            height: 15,
          ));
          widgets.add(Consumer<GroupButtonModel>(
              builder: (context, selectedItem, child) {
            _controller.text = selectedItem.selectedItem;
            return WidgetFactory.buildTextField(
                context,
                TextFormFieldProperties(
                    controller: _controller,
                    textInputType: TextInputType.name,
                    inputDecoration:
                        InputDecoration(hintText: formItem?.controlText)),
                (string) {
              DynamicInput.formInputValues
                  .add({"${formItem?.serviceParamId}": _controller.text});
              return null;
            });
          }));
          widgets.add(const SizedBox(
            height: 8,
          ));
        }
      }
    }
    if (buttons.isNotEmpty) {
      widgets.add(GroupButtonWidget(
        buttons: buttons,
      ));
    }
    widgets = widgets.reversed.toList();
    return ChangeNotifierProvider(
        create: (context) => GroupButtonModel(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ));
  }
}

class NullWidget implements IFormWidget {
  @override
  Widget render() {
    return const Visibility(
      visible: false,
      child: SizedBox(),
    );
  }
}
