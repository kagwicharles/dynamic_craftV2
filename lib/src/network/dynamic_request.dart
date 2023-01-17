import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../builder/factory_builder.dart';

class DynamicFormRequest {
  Map<String, dynamic> requestObj = {};
  late DynamicResponse dynamicResponse;
  final _actionControlRepository = ActionControlRepository();
  final _services = APIService();
  final _sharedPref = CommonSharedPref();

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
    if (dataObj == null) {
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

    var dynamicData = DynamicData(
        actionType: actionType,
        dynamicResponse: dynamicResponse,
        moduleItem: moduleItem,
        controlID: formItem?.controlId,
        isList: isList,
        listType: listType,
        tappedButton: tappedButton);

    dynamicResponse.dynamicData = dynamicData;

    if (moduleItem.moduleId == "PIN" &&
        dynamicResponse.status == StatusCode.success.statusCode) {
      _sharedPref.setBio(false);
    }

    return dynamicResponse;
  }
}
