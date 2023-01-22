part of dynamic_widget;

abstract class IFormWidget {
  factory IFormWidget(FormItem formItem, {jsonText, formFields}) {
    ViewType? controlType = EnumFormatter.getViewType(formItem.controlType!);
    switch (controlType) {
      case ViewType.TEXT:
        return DynamicTextFormField();

      case ViewType.DATE:
        return DynamicTextFormField();

      case ViewType.HIDDEN:
        return HiddenWidget(formFields: formFields, formItem: formItem);

      case ViewType.BUTTON:
        return const DynamicButton();

      case ViewType.DROPDOWN:
        return DynamicDropDown();

      case ViewType.LABEL:
        return DynamicLabelWidget();

      case ViewType.QRSCANNER:
        return DynamicQRScanner();

      case ViewType.PHONECONTACTS:
        return const DynamicPhonePickerFormWidget();

      case ViewType.TEXTVIEW:
        return DynamicTextViewWidget(jsonText: jsonText);

      case ViewType.LIST:
        return DynamicListWidget();

      case ViewType.HYPERLINK:
        return DynamicHyperLink();

      case ViewType.IMAGE:
        return formItem.controlFormat == ControlFormat.imagepanel.name
            ? const DynamicImageUpload()
            : NullWidget();

      case ViewType.CHECKBOX:
        return const DynamicCheckBox();

      case ViewType.CONTAINER:
        return const DynamicLinkedContainer();

      default:
        {
          return NullWidget();
        }
    }
  }

  Widget render();
}

class WidgetFactory {
  static Widget buildButton(
      BuildContext context, Function() onPressed, String buttonTitle) {
    return IElevatedButton(Theme.of(context).platform)
        .getPlatformButton(onPressed, buttonTitle);
  }

  static Widget buildTextField(BuildContext context,
      TextFormFieldProperties properties, String? Function(String?) validator) {
    return ITextFormField(Theme.of(context).platform)
        .getPlatformTextField(properties, validator);
  }
}
