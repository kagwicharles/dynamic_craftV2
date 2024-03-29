import 'package:craft_dynamic/craft_dynamic.dart';

abstract class IPostDynamicCheck {
  factory IPostDynamicCheck(dynamicData) {
    switch (dynamicData.actionType) {
      case ActionType.DBCALL:
        return PostDynamicDBCall(
            dynamicResponse: dynamicData.dynamicResponse,
            moduleItem: dynamicData.moduleItem,
            controlID: dynamicData.controlID,
            isList: dynamicData.isList,
            listType: dynamicData.listType,
            tappedButton: dynamicData.tappedButton);

      case ActionType.VALIDATE:
        return PostDynamicValidate(
            dynamicResponse: dynamicData.dynamicResponse,
            moduleItem: dynamicData.moduleItem,
            listType: dynamicData.listType);

      case ActionType.PAYBILL:
        return PostDynamicPayBill(
            dynamicResponse: dynamicData.dynamicResponse,
            listType: dynamicData.listType);

      case ActionType.CHANGEPIN:
        return PostDynamicChangePin(
            dynamicResponse: dynamicData.dynamicResponse);

      default:
        return DefaultPostDynamic();
    }
  }

  PostDynamicBuilder getBuilder();
}

class DefaultPostDynamic implements IPostDynamicCheck {
  @override
  PostDynamicBuilder getBuilder() {
    return PostDynamicBuilder();
  }
}

class PostDynamicDBCall implements IPostDynamicCheck {
  DynamicResponse dynamicResponse;
  ModuleItem moduleItem;
  String controlID;
  ListType listType;
  bool isList, tappedButton;

  PostDynamicDBCall(
      {required this.dynamicResponse,
      required this.moduleItem,
      required this.controlID,
      required this.listType,
      required this.isList,
      required this.tappedButton});

  @override
  PostDynamicBuilder getBuilder() {
    var builder = PostDynamicBuilder()
      ..formID = dynamicResponse.formID
      ..status = dynamicResponse.status
      ..message = dynamicResponse.message
      ..jsonDisplay = dynamicResponse.display
      ..opensDynamicRoute = dynamicResponse.display != null ||
              dynamicResponse.formID != null && dynamicResponse.formID != ""
          ? true
          : false
      ..formFields = dynamicResponse.formFields
      ..list = dynamicResponse.dynamicList
      ..notifyText = dynamicResponse.notifyText
      ..nextFormSequence = dynamicResponse.nextFormSequence
      ..moduleItem = moduleItem
      ..listType = listType
      ..isList = isList
      ..controlID = controlID
      ..tappedButton = tappedButton;
    return builder;
  }
}

class PostDynamicValidate implements IPostDynamicCheck {
  final DynamicResponse dynamicResponse;
  final ModuleItem moduleItem;
  final ListType listType;

  PostDynamicValidate(
      {required this.dynamicResponse,
      required this.moduleItem,
      required this.listType});

  @override
  PostDynamicBuilder getBuilder() {
    var builder = PostDynamicBuilder()
      ..formID = dynamicResponse.formID
      ..status = dynamicResponse.status
      ..message = dynamicResponse.message
      ..jsonDisplay = dynamicResponse.display
      ..formFields = dynamicResponse.formFields
      ..moduleItem = moduleItem
      ..notifyText = dynamicResponse.notifyText
      ..opensDynamicRoute = true
      ..nextFormSequence = dynamicResponse.nextFormSequence
      ..list = dynamicResponse.dynamicList;
    return builder;
  }
}

class PostDynamicPayBill implements IPostDynamicCheck {
  DynamicResponse dynamicResponse;
  ListType listType;

  PostDynamicPayBill({required this.dynamicResponse, required this.listType});

  @override
  PostDynamicBuilder getBuilder() {
    var builder = PostDynamicBuilder()
      ..formID = dynamicResponse.formID
      ..status = dynamicResponse.status
      ..message = dynamicResponse.message
      ..jsonDisplay = dynamicResponse.display
      ..opensDynamicRoute = dynamicResponse.display != null ? true : false
      ..list = dynamicResponse.dynamicList
      ..formFields = dynamicResponse.formFields
      ..notifyText = dynamicResponse.notifyText
      ..nextFormSequence = dynamicResponse.nextFormSequence
      ..receiptDetails = dynamicResponse.receiptDetails
      ..listType = listType;
    return builder;
  }
}

class PostDynamicChangePin implements IPostDynamicCheck {
  DynamicResponse dynamicResponse;

  PostDynamicChangePin({
    required this.dynamicResponse,
  });

  @override
  PostDynamicBuilder getBuilder() {
    var builder = PostDynamicBuilder()
      ..formID = dynamicResponse.formID
      ..status = dynamicResponse.status
      ..message = dynamicResponse.message;
    return builder;
  }
}
