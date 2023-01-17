// ignore_for_file: must_be_immutable
part of dynamic_widget;

class DynamicWidget extends StatefulWidget {
  List<dynamic>? jsonDisplay, formFields;
  int? nextFormSequence;
  bool isWizard;
  ModuleItem? moduleItem;
  FrequentAccessedModule? favouriteModule;

  DynamicWidget({
    Key? key,
    this.moduleItem,
    this.favouriteModule,
    this.jsonDisplay,
    this.formFields,
    this.nextFormSequence,
    this.isWizard = false,
  }) : super(key: key);

  @override
  State<DynamicWidget> createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  List<FormItem> content = [];
  ModuleItem? moduleItem;
  FrequentAccessedModule? favouriteModule;

  @override
  Widget build(BuildContext context) {
    moduleItem = checkModuleType(
        moduleItem: widget.moduleItem, favouriteModule: widget.favouriteModule);

    final orientation = MediaQuery.of(context).orientation;
    EasyLoading.dismiss();
    // _formItems = DynamicData.readFormsJson(moduleId);
    // _moduleItems = DynamicData.readModulesJson(moduleId);

    return ChangeNotifierProvider(
        create: (context) => PluginState(),
        child: moduleItem?.moduleCategory == "FORM"
            ? FormsListWidget(
                jsonDisplay: widget.jsonDisplay,
                formFields: widget.formFields,
                nextFormSequence: widget.nextFormSequence,
                isWizard: widget.isWizard,
                moduleItem: moduleItem!,
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

  @override
  void dispose() {
    super.dispose();
  }
}
