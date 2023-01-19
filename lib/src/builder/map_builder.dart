import 'package:craft_dynamic/craft_dynamic.dart';

abstract class IRequestObject {
  List<Map<String?, dynamic>> dataObject = [];
  Map<String, dynamic> requestObject = {};
  ActionType? actionType;

  factory IRequestObject(ActionType action,
      {required merchantID,
      required actionID,
      required requestMap,
      required dataObject,
      isList = false,
      listType,
      encryptedFields}) {
    switch (action) {
      case ActionType.DBCALL:
        return DBCall(
            merchantID: merchantID,
            actionType: action,
            actionID: actionID,
            requestObject: requestMap,
            dataObject: dataObject,
            encryptedFields: encryptedFields,
            isList: isList,
            listType: listType);

      case ActionType.PAYBILL:
        return PayBill(
            dataObject: dataObject,
            merchantID: merchantID,
            actionType: action,
            encryptedFields: encryptedFields,
            requestObject: requestMap);

      case ActionType.VALIDATE:
        return Validate(
            merchantID: merchantID,
            dataObject: dataObject,
            actionType: action,
            requestObject: requestMap);

      case ActionType.CHANGEPIN:
        return ChangePin(
          dataObject: dataObject,
          actionType: action,
          requestObject: requestMap,
          encryptedFields: encryptedFields,
        );

      default:
        return DefaultObject();
    }
  }

  Map<String, dynamic> getRequestObject();
}

class DefaultObject implements IRequestObject {
  @override
  List<Map<String?, dynamic>> dataObject = [];

  @override
  Map<String, dynamic> requestObject = {};

  @override
  ActionType? actionType;

  @override
  Map<String, dynamic> getRequestObject() {
    return {};
  }
}

class Validate implements IRequestObject {
  String merchantID;

  @override
  ActionType? actionType;

  @override
  List<Map<String?, dynamic>> dataObject;

  @override
  Map<String, dynamic> requestObject = {};

  Validate(
      {required this.merchantID,
      this.actionType,
      required this.dataObject,
      required this.requestObject});

  @override
  Map<String, dynamic> getRequestObject() {
    Map<String?, dynamic> fields = {};
    for (var element in dataObject) {
      fields.addAll(element);
    }
    requestObject[RequestParam.FormID.name] = actionType?.name;
    requestObject[RequestParam.MerchantID.name] = merchantID;
    requestObject[RequestParam.Validate.name] = fields;
    return requestObject;
  }
}

class PayBill implements IRequestObject {
  @override
  List<Map<String?, dynamic>> dataObject;

  @override
  Map<String, dynamic> requestObject = {};

  @override
  ActionType? actionType;

  Map encryptedFields;
  String merchantID;

  PayBill({
    required this.requestObject,
    required this.dataObject,
    required this.merchantID,
    required this.encryptedFields,
    this.actionType,
  });

  @override
  Map<String, dynamic> getRequestObject() {
    Map<String?, dynamic> fields = {};
    for (var element in dataObject) {
      fields.addAll(element);
    }
    fields.addAll({RequestParam.MerchantID.name: merchantID});
    requestObject[RequestParam.FormID.name] = actionType?.name;
    requestObject[RequestParam.MerchantID.name] = merchantID;
    requestObject[RequestParam.PayBill.name] = fields;
    requestObject[RequestParam.EncryptedFields.name] = encryptedFields;
    return requestObject;
  }
}

class DBCall implements IRequestObject {
  @override
  List<Map<String?, dynamic>> dataObject;

  @override
  Map<String, dynamic> requestObject = {};

  @override
  ActionType? actionType;

  Map? encryptedFields;
  final String merchantID, actionID;
  final ListType listType;
  final bool isList;

  DBCall(
      {required this.merchantID,
      required this.actionType,
      required this.actionID,
      required this.requestObject,
      required this.dataObject,
      this.encryptedFields,
      this.listType = ListType.TransactionList,
      this.isList = false});

  @override
  Map<String, dynamic> getRequestObject() {
    Map<String?, dynamic> fields = {};
    for (var element in dataObject) {
      fields.addAll(element);
    }
    requestObject[RequestParam.FormID.name] = actionType?.name;
    if (fields.containsKey(RequestParam.HEADER.name) == false) {
      fields[RequestParam.HEADER.name] = actionID;
    }
    if (listType == ListType.ViewOrderList) {
      fields[RequestParam.MerchantID.name] = merchantID;
    }
    if (encryptedFields != null) {
      requestObject[RequestParam.EncryptedFields.name] = encryptedFields;
    }
    requestObject[RequestParam.DynamicForm.name] = fields;
    return requestObject;
  }
}

class ChangePin implements IRequestObject {
  @override
  ActionType? actionType;

  @override
  List<Map<String?, dynamic>> dataObject;

  Map<String?, dynamic> encryptedFields;

  @override
  Map<String, dynamic> requestObject = {};

  ChangePin(
      {this.actionType,
      required this.dataObject,
      required this.requestObject,
      required this.encryptedFields});

  @override
  Map<String, dynamic> getRequestObject() {
    Map<String?, dynamic> fields = {};
    for (var element in dataObject) {
      fields.addAll(element);
    }
    requestObject[RequestParam.FormID.name] = actionType?.name;
    requestObject[RequestParam.CHANGEPIN.name] = fields;
    requestObject[RequestParam.EncryptedFields.name] = encryptedFields;
    return requestObject;
  }
}
