part of craft_dynamic;

@entity
class ModuleItem {
  @primaryKey
  String moduleId;
  String parentModule;
  String? moduleUrl;
  String moduleName;
  String moduleCategory;
  String? merchantID;

  ModuleItem(
      {required this.parentModule,
      required this.moduleUrl,
      required this.moduleId,
      required this.moduleName,
      required this.moduleCategory,
      required this.merchantID});

  ModuleItem.fromJson(Map<String, dynamic> json)
      : parentModule = json["ParentModule"],
        moduleUrl = json["ModuleURL"],
        moduleId = json["ModuleID"],
        moduleName = json["ModuleName"],
        moduleCategory = json["ModuleCategory"],
        merchantID = json["MerchantID"];
}

@entity
class FormItem {
  @primaryKey
  int? no;
  String? controlType;
  String? controlText;
  String? moduleId;
  String? controlId;
  String? containerID;
  String? actionId;
  String? linkedToControl;
  int? formSequence;
  String? serviceParamId;
  double? displayOrder;
  String? controlFormat;
  String? dataSourceId;
  String? controlValue;
  bool? isMandatory;
  bool? isEncrypted;
  String? minValue;
  String? maxValue;

  FormItem(
      {required this.controlType,
      required this.controlText,
      required this.moduleId,
      this.linkedToControl,
      this.controlId,
      this.containerID,
      this.actionId,
      this.formSequence,
      this.serviceParamId,
      this.displayOrder,
      this.controlFormat,
      this.dataSourceId,
      this.controlValue,
      this.isMandatory,
      this.isEncrypted,
      this.minValue,
      this.maxValue});

  FormItem.fromJson(Map<String, dynamic> json) {
    controlType = json['ControlType'];
    controlText = json['ControlText'];
    moduleId = json['ModuleID'];
    linkedToControl = json['LinkedToControl'];
    controlId = json['ControlID'];
    containerID = json["ContainerID"];
    actionId = json['ActionID'];
    formSequence = json['FormSequence'];
    serviceParamId = json['ServiceParamID'];
    displayOrder = json['DisplayOrder'];
    isMandatory = json['IsMandatory'];
    isEncrypted = json['IsEncrypted'];
    controlFormat = json['ControlFormat'];
    dataSourceId = json['DataSourceID'];
    controlValue = json['ControlValue'];
    minValue = json['MinValue'];
    maxValue = json["MaxValue"];
  }
}

@entity
class ActionItem {
  @primaryKey
  int? no;
  String moduleId;
  String actionType;
  String actionId;
  String serviceParamsIds;
  String controlId;
  String webHeader;
  String? merchantId;
  String? formId;
  String? displayFormID;

  ActionItem(
      {required this.moduleId,
      required this.actionType,
      required this.actionId,
      required this.serviceParamsIds,
      required this.controlId,
      required this.webHeader,
      this.displayFormID,
      this.formId,
      this.merchantId});

  ActionItem.fromJson(Map<String, dynamic> json)
      : moduleId = json["ModuleID"],
        actionType = json["ActionType"],
        actionId = json["ActionID"],
        serviceParamsIds = json["ServiceParamIDs"],
        controlId = json["ControlID"],
        webHeader = json["WebHeader"],
        displayFormID = json["DisplayFormID"],
        formId = json["FormID"],
        merchantId = json["MerchantID"];
}

@entity
class UserCode {
  @primaryKey
  int? no;
  String id;
  String subCodeId;
  String? description;
  String? relationId;
  String? extraField;
  int? displayOrder;
  bool? isDefault;
  String? extraFieldName;

  UserCode(
      {required this.id,
      required this.subCodeId,
      this.description,
      this.relationId,
      this.extraField,
      this.displayOrder,
      this.isDefault,
      this.extraFieldName});

  UserCode.fromJson(Map<String, dynamic> json)
      : id = json["ID"],
        subCodeId = json["SubCodeID"],
        description = json["Description"],
        relationId = json["RelationID"],
        extraField = json["ExtraField"],
        displayOrder = json["DisplayOrder"],
        isDefault = json["IsDefault"],
        extraFieldName = json["ExtraFieldName"];
}

@entity
class OnlineAccountProduct {
  @primaryKey
  int? no;
  String? id;
  String? description;
  String? relationId;
  String? url;

  OnlineAccountProduct({this.id, this.description, this.relationId, this.url});

  OnlineAccountProduct.fromJson(Map<String, dynamic> json)
      : id = json["ID"],
        description = json["Description"],
        relationId = json["RelationID"],
        url = json["Urls"];
}

@entity
class BankBranch {
  @primaryKey
  int? no;
  String? description;
  String? relationId;

  BankBranch({this.description, this.relationId});

  BankBranch.fromJson(Map<String, dynamic> json)
      : description = json["Description"],
        relationId = json["RelationID"];
}

@entity
class ImageData {
  @primaryKey
  int? no;
  String? imageUrl;
  String? imageInfoUrl;
  String? imageCategory;

  ImageData({this.no, this.imageUrl, this.imageInfoUrl, this.imageCategory});

  ImageData.fromJson(Map<String, dynamic> json)
      : imageUrl = json['ImageURL'],
        imageInfoUrl = json['ImageInfoURL'],
        imageCategory = json['ImageCategory'];
}

@entity
class AtmLocation {
  @primaryKey
  int? no;
  double longitude;
  double latitude;
  String location;

  AtmLocation(
      {required this.longitude,
      required this.latitude,
      required this.location});

  AtmLocation.fromJson(Map<String, dynamic> json)
      : longitude = json["Longitude"],
        latitude = json["Latitude"],
        location = json["Location"];
}

@entity
class BranchLocation {
  @primaryKey
  int? no;
  double longitude;
  double latitude;
  String location;

  BranchLocation(
      {required this.longitude,
      required this.latitude,
      required this.location});

  BranchLocation.fromJson(Map<String, dynamic> json)
      : longitude = json["Longitude"],
        latitude = json["Latitude"],
        location = json["Location"];
}

@entity
class BankAccount {
  @primaryKey
  int? no;
  String bankAccountId;
  String aliasName;
  String currencyID;
  String accountType;
  bool groupAccount;
  bool defaultAccount;

  BankAccount(
      {required this.bankAccountId,
      this.aliasName = "",
      this.currencyID = "",
      this.accountType = "",
      required this.groupAccount,
      required this.defaultAccount});

  BankAccount.fromJson(Map<String, dynamic> json)
      : bankAccountId = json["BankAccountID"],
        aliasName = json["AliasName"],
        currencyID = json["CurrencyID"],
        accountType = json["AccountType"],
        groupAccount = json["GroupAccount"],
        defaultAccount = json["DefaultAccount"];
}

@entity
class FrequentAccessedModule {
  @primaryKey
  int? no;
  String parentModule;
  String moduleID;
  String moduleName;
  String moduleCategory;
  String moduleUrl;
  String? badgeColor;
  String? badgeText;
  String? merchantID;
  double? displayOrder;
  String? containerID;
  String? lastAccessed;

  FrequentAccessedModule(
      {required this.parentModule,
      required this.moduleID,
      required this.moduleName,
      required this.moduleCategory,
      required this.moduleUrl,
      required this.merchantID,
      this.badgeColor,
      this.badgeText,
      this.displayOrder,
      this.containerID,
      this.lastAccessed});

  FrequentAccessedModule.fromJson(Map<String, dynamic> json)
      : parentModule = json["ParentModule"],
        moduleID = json["ModuleID"],
        moduleName = json["ModuleName"],
        moduleCategory = json["ModuleCategory"],
        moduleUrl = json["ModuleURL"],
        merchantID = json["MerchantID"],
        badgeColor = json["BadgeColor"],
        badgeText = json["BadgeText"],
        displayOrder = json["DisplayOrder"],
        containerID = json["ContainerID"],
        lastAccessed = json["LastAccessed"];
}

@entity
class Beneficiary {
  @primaryKey
  int? no;
  int rowId;
  String merchantID;
  String merchantName;
  String accountID;
  String accountAlias;
  String? bankID;
  String? branchID;
  Beneficiary(
      {required this.merchantID,
      required this.merchantName,
      required this.accountID,
      required this.accountAlias,
      required this.rowId,
      this.bankID,
      this.branchID});

  Beneficiary.fromJson(Map<String, dynamic> json)
      : rowId = json["RowID"],
        merchantID = json["MerchantID"],
        merchantName = json["MerchantName"],
        accountID = json["AccountID"],
        accountAlias = json["AccountAlias"],
        bankID = json["BankID"],
        branchID = json["BranchID"];
}

@entity
class ModuleToHide {
  @primaryKey
  int? no;
  String moduleId;

  ModuleToHide({required this.moduleId});

  ModuleToHide.fromJson(Map<String, dynamic> json)
      : moduleId = json["ModuleID"];
}

@entity
class ModuleToDisable {
  @primaryKey
  int? no;
  String moduleID;
  String? merchantID;
  String? displayMessage;

  ModuleToDisable(
      {required this.moduleID, this.merchantID, this.displayMessage});

  ModuleToDisable.fromJson(Map<String, dynamic> json)
      : moduleID = json["ModuleID"],
        merchantID = json["MerchantID"],
        displayMessage = json["DisplayMessage"];
}

@entity
class PendingTrxDisplay {
  @primaryKey
  int? no;
  String name;
  String comments;
  String transactionType;
  String sendTo;
  double amount;
  String pendingUniqueID;

  PendingTrxDisplay(
      {required this.name,
      required this.comments,
      required this.transactionType,
      required this.sendTo,
      required this.amount,
      required this.pendingUniqueID});

  PendingTrxDisplay.fromJson(Map<String, dynamic> json)
      : name = json["Name"],
        comments = json["Comments"],
        transactionType = json["Trx Type"],
        sendTo = json["Send to"],
        amount = json["Amount"],
        pendingUniqueID = json["PendingUniqueID"];
}

//TODO Add Entity for service alerts
//TODO Add Entity for loanlimit

