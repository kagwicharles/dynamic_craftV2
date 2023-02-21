// ignore_for_file: must_be_immutable

import 'package:craft_dynamic/src/ui/dynamic_static/list_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:craft_dynamic/src/state/plugin_state.dart';
import 'package:craft_dynamic/src/ui/dynamic_components.dart';
import 'package:craft_dynamic/src/util/widget_util.dart';

class TabWidget extends StatefulWidget {
  List<FormItem> formItems;
  String title;
  ModuleItem moduleItem;
  Function? updateState;

  TabWidget(
      {super.key,
      required this.title,
      required this.formItems,
      required this.moduleItem,
      this.updateState});

  @override
  State<TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> {
  FormItem? recentList;
  List<FormItem> horizontalScroll = [];
  List<Tab> tabs = [];
  List<FormItem> tabForms = [];
  List<TabWidgetList> tabWidgetList = [];
  List<String> linkControls = [];

  @override
  void initState() {
    super.initState();
    tabWidgetList.clear();
    logForms();
    addTabWidgetList();
  }

  List<FormItem> getContainers(List<FormItem> forms) {
    List<FormItem> containers = forms
        .where((element) => element.controlType == ViewType.CONTAINER.name)
        .toList();
    return containers;
  }

  List<FormItem> getContainerForms(List<FormItem> forms, FormItem container) {
    return forms
        .where((element) =>
            element.containerID == container.controlId ||
            element.linkedToControl == container.controlId)
        .toList();
  }

  List<FormItem> getRButtonForms(List<FormItem> forms, FormItem rButton) {
    return forms
        .where((element) => element.linkedToControl == rButton.controlId)
        .toList();
  }

  logForms() {
    debugPrint("##NEW get widget###");
    debugPrint("Getting all containers...");
    List<FormItem> containers = getContainers(widget.formItems);
    debugPrint("Containers....");
    for (var element in containers) {
      debugPrint("${element.controlType} ${element.controlId}");
    }
    debugPrint("Getting container forms...");
    for (int i = 0; i < containers.length; i++) {
      List<FormItem> temp = getContainerForms(widget.formItems, containers[i]);
      for (var element in temp) {
        if (element.controlType == ViewType.RBUTTON.name ||
            element.controlType == ViewType.TAB.name) {
          linkControls.add(element.controlId!);
          tabs.add(Tab(
            text: element.controlText!.capitalize(),
          ));
        }
      }
      if (containers[i].controlType == ViewType.CONTAINER.name &&
          containers[i].controlFormat == ControlFormat.HorizontalScroll.name) {
        horizontalScroll.addAll(widget.formItems.where((item) =>
            item.containerID == containers[i].controlId ||
            item.linkedToControl == containers[i].controlId));
      }
    }
  }

  bool checkGlobalControlType(
      List<String> linkControls, String linkControl, FormItem formItem) {
    bool isGlobal = true;
    for (var element in linkControls) {
      if (element == formItem.linkedToControl) {
        isGlobal = false;
      }
    }
    return isGlobal;
  }

  List<FormItem> getTabForms(List<FormItem> formItems, String linkControl) {
    List<FormItem> items = formItems
        .where((element) =>
            element.linkedToControl == linkControl ||
            element.linkedToControl == "" ||
            element.linkedToControl == null)
        .toList();

    try {
      recentList = items.firstWhere(
        (item) => item.controlType == ViewType.LIST.name,
      );
      debugPrint("Recent list::::$recentList");
    } catch (e) {
      debugPrint("Error:::$e");
    }
    items.removeWhere((element) => element.controlType == ViewType.LIST.name);
    return items;
  }

  addTabWidgetList() {
    tabForms.clear();
    linkControls.asMap().forEach((index, linkControl) {
      tabForms = getTabForms(widget.formItems, linkControl).toList();
      tabWidgetList.add(TabWidgetList(
        moduleItem: widget.moduleItem,
        formItems: tabForms,
        updateState: widget.updateState,
        horizontalScroll: horizontalScroll,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Provider.of<PluginState>(context, listen: false)
              .setRequestState(false);
          return true;
        },
        child: DefaultTabController(
            length: tabs.length,
            child: Builder(builder: (BuildContext context) {
              final TabController? tabController =
                  DefaultTabController.of(context);
              tabController?.addListener(() {
                if (!tabController.indexIsChanging) {
                  Provider.of<PluginState>(context, listen: false)
                      .setRequestState(false,
                          currentTab: linkControls[tabController.index]);
                }
              });
              return Scaffold(
                appBar: AppBar(
                  elevation: 2,
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
                  bottom: TabBar(
                    tabs: tabs,
                    isScrollable: true,
                  ),
                  title: Text(widget.moduleItem.moduleName),
                ),
                body: TabBarView(children: tabWidgetList),
              );
            })));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class TabWidgetList extends StatefulWidget {
  final List<FormItem> formItems;
  List<FormItem>? horizontalScroll;
  Function? updateState;
  ModuleItem moduleItem;

  TabWidgetList(
      {super.key,
      required this.formItems,
      required this.moduleItem,
      this.updateState,
      this.horizontalScroll});

  @override
  State<TabWidgetList> createState() => _TabWidgetListState();
}

class _TabWidgetListState extends State<TabWidgetList> {
  final _formKey = GlobalKey<FormState>();
  List<FormItem> sortedForms = [];

  @override
  void initState() {
    super.initState();
    sortedForms = WidgetUtil.sortForms(widget.formItems);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          Form(
              key: _formKey,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 8),
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
        ])));
  }

  bool get wantKeepAlive => true;
}
