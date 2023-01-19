// ignore_for_file: must_be_immutable
part of dynamic_widget;

class DynamicWidget extends StatelessWidget {
  List<dynamic>? jsonDisplay, formFields;
  int? nextFormSequence;
  bool isWizard, isNextForm;
  ModuleItem? moduleItem;
  FrequentAccessedModule? favouriteModule;

  DynamicWidget(
      {Key? key,
      this.moduleItem,
      this.favouriteModule,
      this.jsonDisplay,
      this.formFields,
      this.nextFormSequence,
      this.isWizard = false,
      this.isNextForm = false})
      : super(key: key);

  List<FormItem> content = [];

  @override
  Widget build(BuildContext context) {
    moduleItem = checkModuleType(
        moduleItem: moduleItem, favouriteModule: favouriteModule);

    final orientation = MediaQuery.of(context).orientation;
    EasyLoading.dismiss();
    // _formItems = DynamicData.readFormsJson(moduleId);
    // _moduleItems = DynamicData.readModulesJson(moduleId);

    return ChangeNotifierProvider(
        create: (context) => PluginState(),
        child: moduleItem?.moduleCategory == "FORM"
            ? FormsListWidget(
                jsonDisplay: jsonDisplay,
                formFields: formFields,
                nextFormSequence: nextFormSequence,
                isWizard: isWizard,
                moduleItem: moduleItem!,
                isNextForm: isNextForm,
              )
            : ModulesListWidget(
                orientation: orientation,
                moduleItem: moduleItem,
              ));
  }

  ModuleItem? checkModuleType(
      {ModuleItem? moduleItem, FrequentAccessedModule? favouriteModule}) {
    ModuleItem? item = moduleItem;
    if (favouriteModule != null) {
      item = ModuleItem(
          parentModule: favouriteModule.parentModule,
          moduleUrl: favouriteModule.moduleUrl,
          moduleId: favouriteModule.moduleID,
          moduleName: favouriteModule.moduleName,
          moduleCategory: favouriteModule.moduleCategory,
          merchantID: favouriteModule.merchantID);
    }
    return item;
  }
}
