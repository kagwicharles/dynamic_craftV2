import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/database.dart';
import 'package:craft_dynamic/src/state/plugin_state.dart';
import 'package:craft_dynamic/src/ui/forms/confirmation_form.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../builder/factory_builder.dart';

class DynamicFormRequest {
  Map<String, dynamic> requestObj = {};
  final _actionControlRepository = ActionControlRepository();
  final _formsRepository = FormsRepository();
  final _services = APIService();
  final _sharedPref = CommonSharedPref();
  String? confirmationModuleID;
  DynamicResponse? dynamicResponse;

  Future<DynamicResponse?> dynamicRequest(
    ModuleItem moduleItem, {
    FormItem? formItem,
    dataObj,
    encryptedField,
    isList = false,
    context,
    listType = ListType.TransactionList,
    tappedButton = false,
  }) async {
    debugPrint("****Making dynamic request****");
    dynamicResponse = DynamicResponse(status: "XXXX");
    if (dataObj == null) {
      debugPrint("Data object is null!!!");
      Fluttertoast.showToast(
          msg: "Unable to process data", backgroundColor: Colors.red);
      return dynamicResponse;
    }

    ActionType actionType = ActionType.DBCALL;
    if (listType == ListType.ViewOrderList ||
        listType == ListType.BeneficiaryList) {
      requestObj["EncryptedFields"] = {};
      requestObj["MerchantID"] = moduleItem.merchantID;
    }

    requestObj["ModuleID"] = moduleItem.moduleId;
    requestObj["SessionID"] = "ffffffff-e46c-53ce-0000-00001d093e12";

    var actionControl =
        await _actionControlRepository.getActionControlByModuleIdAndControlId(
            moduleItem.moduleId, formItem?.controlId);
    if (actionControl?.displayFormID == ControlFormat.LISTDATA.name ||
        actionControl == null) {
      isList = true;
    }

    if (actionControl != null) {
      actionType = ActionType.values.byName(actionControl.actionType);
    }

    debugPrint("Action Type::::::$actionType");
    if (actionType == ActionType.VALIDATE) {
      Provider.of<PluginState>(context, listen: false).setDeleteForm(false);
    } else {
      Provider.of<PluginState>(context, listen: false).setDeleteForm(true);
    }

    confirmationModuleID = actionControl?.confirmationModuleID;
    if (confirmationModuleID != null && confirmationModuleID != "") {
      List<FormItem> form =
          await _formsRepository.getFormsByModuleId(confirmationModuleID ?? "");
      var result = await ConfirmationForm.showModalBottomDialog(
          context,
          form,
          moduleItem,
          Provider.of<PluginState>(context, listen: false).formInputValues);
      if (result != null) {
        if (result == 1) {
          Provider.of<PluginState>(context, listen: false)
              .setRequestState(false);
          return dynamicResponse;
        }
      } else {
        Provider.of<PluginState>(context, listen: false).setRequestState(false);
        return dynamicResponse;
      }
    }

    requestObj = DynamicFactory.getDynamicRequestObject(actionType,
        merchantID: moduleItem.merchantID,
        actionID: formItem?.actionId,
        requestMap: requestObj,
        dataObject: dataObj,
        isList: isList,
        listType: listType,
        encryptedFields:
            encryptedField); // Get a request map from this interface

    dynamicResponse = await _services.dynamicRequest(
        requestObj: requestObj,
        webHeader: actionControl?.webHeader,
        formID: actionType.name);

    if (dynamicResponse?.status == "XXXX") {
      Provider.of<PluginState>(context, listen: false).setRequestState(false);
    }

    var dynamicData = DynamicData(
        actionType: actionType,
        dynamicResponse: dynamicResponse ?? DynamicResponse(status: "XXXX"),
        moduleItem: moduleItem,
        controlID: formItem?.controlId,
        isList: isList,
        listType: listType,
        tappedButton: tappedButton);

    dynamicResponse?.dynamicData = dynamicData;

    if (moduleItem.moduleId == "PIN" &&
        dynamicResponse?.status == StatusCode.success.statusCode) {
      _sharedPref.setBio(false);
    }

    Provider.of<PluginState>(context, listen: false).setRequestState(false);

    return dynamicResponse;
  }
}
