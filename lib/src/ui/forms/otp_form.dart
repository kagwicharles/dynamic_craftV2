import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:craft_dynamic/src/ui/dynamic_components.dart';
import 'package:flutter/material.dart';

class OTPForm {
  static showModalBottomDialog(context, List<FormItem> formItems,
      ModuleItem moduleItem, List<Map<String?, dynamic>> input) async {
    return await showModalBottomSheet<int>(
      isDismissible: false,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 12, bottom: 4),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Verify OTP received",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(1);
                        },
                        child: Row(children: const [
                          Icon(Icons.close),
                          Text("Cancel")
                        ]),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Form(
                      key: formKey,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: formItems.length,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          itemBuilder: (context, index) {
                            return BaseFormComponent(
                                formItem: formItems[index],
                                moduleItem: moduleItem,
                                formItems: formItems,
                                formKey: formKey,
                                child: IFormWidget(formItems[index],
                                        jsonText: input)
                                    .render());
                          })),
                ],
              ));
        });
      },
    );
  }
}