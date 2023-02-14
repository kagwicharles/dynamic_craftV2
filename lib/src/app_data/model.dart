// ignore_for_file: constant_identifier_names

part of craft_dynamic;

class CreditCard {
  final String balance;
  final String currency;

  CreditCard({
    required this.balance,
    required this.currency,
  });

  CreditCard.fromMap(Map map)
      : this(
          balance: map['balance'],
          currency: map['currency'],
        );
}

class MenuItemData {
  final String title;
  final String icon;

  MenuItemData({required this.title, required this.icon});
}

class AppLocation {
  double longitude;
  double latitude;
  String location;

  AppLocation(
      {required this.longitude,
      required this.latitude,
      required this.location});
}

class FavouriteItem {
  String imageUrl;
  String title;

  FavouriteItem({required this.imageUrl, required this.title});
}

class DynamicResponse {
  String status = "";
  DynamicData? dynamicData;
  String? message, formID, notifyText;
  int? nextFormSequence;
  List<dynamic>? dynamicList,
      notifications,
      resultsData,
      formFields,
      display,
      receiptDetails,
      accountStatement,
      beneficiaries;

  DynamicResponse(
      {required this.status,
      this.dynamicData,
      this.message,
      this.formID,
      this.display,
      this.nextFormSequence,
      this.dynamicList,
      this.notifications,
      this.resultsData,
      this.formFields,
      this.receiptDetails,
      this.accountStatement,
      this.beneficiaries});

  DynamicResponse.fromJson(Map<String, dynamic> json) {
    status = json["Status"];
    message = json["Message"];
    formID = json['FormID'];
    display = json["Display"];
    nextFormSequence = json["NextFormSequence"];
    if (json["Notifications"] != null) {
      notifyText = json["Notifications"][0]["NotifyText"];
    }
    resultsData = json["ResultsData"];
    dynamicList = json["Data"];
    formFields = json["FormFields"];
    receiptDetails = json["ReceiptDetails"];
    accountStatement = json["AccountStatement"];
    beneficiaries = json["Beneficiary"];
  }
}

class ActivationResponse {
  String status;
  int? staticDataVersion;
  String? message,
      firstName,
      lastName,
      idNumber,
      emailID,
      imageUrl,
      lastLoginDate,
      customerID;
  List<dynamic>? accounts,
      frequentAccessedModules,
      beneficiary,
      modulesToHide,
      modulesToDisable,
      pendingTransactions;

  ActivationResponse(
      {required this.status,
      this.message,
      this.firstName,
      this.lastName,
      this.idNumber,
      this.emailID,
      this.imageUrl,
      this.lastLoginDate,
      this.customerID,
      this.staticDataVersion,
      this.beneficiary,
      this.accounts,
      this.frequentAccessedModules,
      this.modulesToHide,
      this.modulesToDisable,
      this.pendingTransactions});

  ActivationResponse.fromJson(Map<String, dynamic> json)
      : status = json["Status"],
        message = json["Message"],
        firstName = json['FirstName'],
        lastName = json["LastName"],
        idNumber = json["IDNumber"],
        emailID = json["EMailID"],
        imageUrl = json["ImageURL"],
        customerID = json["CustomerID"],
        lastLoginDate = json["LastLoginDateTime"],
        staticDataVersion = json["StaticDataVersion"],
        beneficiary = json["Beneficiary"],
        frequentAccessedModules = json["FrequentAccessedModules"],
        modulesToHide = json["ModulesToHide"],
        modulesToDisable = json["ModulesToDisable"],
        pendingTransactions = json["PendingTrxDisplay"],
        accounts = json["Accounts"];
}

class StaticResponse {
  String status;
  int? staticDataVersion, appIdleTimeout, appRateLoginCount;
  String? message;
  List<dynamic>? usercode,
      onlineAccountProduct,
      bankBranch,
      atmLocation,
      branchLocation,
      image;

  StaticResponse(
      {required this.status,
      this.message,
      this.staticDataVersion,
      this.appIdleTimeout,
      this.appRateLoginCount,
      this.usercode,
      this.onlineAccountProduct,
      this.bankBranch,
      this.atmLocation,
      this.branchLocation,
      this.image});

  StaticResponse.fromJson(Map<String, dynamic> json)
      : status = json["Status"],
        message = json["Message"],
        staticDataVersion = json["StaticDataVersion"],
        appIdleTimeout = json["AppIdleTimeout"],
        appRateLoginCount = json["AppRateLoginCount"],
        usercode = json["UserCode"],
        branchLocation = json["BranchLocations"],
        atmLocation = json["ATMLocations"],
        bankBranch = json["BankBranch"],
        image = json["Images"],
        onlineAccountProduct = json["OnlineAccountProduct"];
}

class UIResponse {
  String status;
  String? message;
  List<dynamic>? formControl, actionControl, module;

  UIResponse(
      {required this.status,
      this.message,
      this.formControl,
      this.actionControl,
      this.module});

  UIResponse.fromJson(Map<String, dynamic> json)
      : status = json["Status"],
        message = json["Message"],
        formControl = json["FormControls"],
        actionControl = json["ActionControls"],
        module = json["Modules"];
}

class PostDynamicBuilder {
  int? nextFormSequence;
  ModuleItem? moduleItem;
  List<dynamic>? list, jsonDisplay, formFields, notifications, receiptDetails;
  String? status, message, formID, controlID, notifyText;
  ListType? listType;
  bool returnsWidget = false,
      opensDynamicRoute = false,
      isList = false,
      tappedButton = false;
}

class PostDynamic {
  BuildContext? context;
  ModuleItem? moduleItem;
  int? nextFormSequence;
  List<dynamic>? list, jsonDisplay, formFields, notifications, receiptDetails;
  String? actionID, status, message, formID, controlID, notifyText;
  ListType? listType;
  bool isList, returnsWidget, opensDynamicRoute, tappedButton;

  PostDynamic(
    PostDynamicBuilder builder,
    BuildContext buildContext,
    String myActionID,
  )   : context = buildContext,
        actionID = myActionID,
        moduleItem = builder.moduleItem,
        controlID = builder.controlID,
        listType = builder.listType,
        isList = builder.isList,
        tappedButton = builder.tappedButton,
        nextFormSequence = builder.nextFormSequence,
        list = builder.list,
        jsonDisplay = builder.jsonDisplay,
        formFields = builder.formFields,
        status = builder.status,
        message = builder.message,
        formID = builder.formID,
        returnsWidget = builder.returnsWidget,
        notifyText = builder.notifyText,
        receiptDetails = builder.receiptDetails,
        opensDynamicRoute = builder.opensDynamicRoute;
}

class TextFormFieldProperties {
  final bool autofocus, isEnabled, isObscured;
  final TextEditingController controller;
  TextInputType textInputType;
  InputDecoration? inputDecoration;
  BoxDecoration? boxDecoration;
  Function(String?)? onChange;

  TextFormFieldProperties({
    this.autofocus = false,
    this.isEnabled = false,
    this.isObscured = false,
    this.onChange,
    required this.controller,
    required this.textInputType,
    this.inputDecoration,
    this.boxDecoration,
  });
}

class DynamicData {
  ActionType actionType;
  DynamicResponse dynamicResponse;
  ModuleItem? moduleItem;
  String? controlID;
  ListType? listType;
  bool? isList, tappedButton;

  DynamicData(
      {required this.actionType,
      required this.dynamicResponse,
      this.moduleItem,
      this.controlID,
      this.isList,
      this.listType,
      this.tappedButton});
}

@JsonSerializable()
class StandingOrder {
  @JsonKey(name: 'Amount')
  double? amount;

  @JsonKey(name: 'SOID')
  String? standingOrderID;

  @JsonKey(name: 'EffectiveDate')
  String? effectiveDate;

  @JsonKey(name: 'FrequencyID')
  String? frequencyID;

  @JsonKey(name: 'LastExecutionDate')
  String? lastExecutionDate;

  @JsonKey(name: 'CreatedBy')
  String? createdBy;

  @JsonKey(name: 'RequestData')
  String? requestData;

  StandingOrder(
      {this.amount,
      this.standingOrderID,
      this.effectiveDate,
      this.frequencyID,
      this.lastExecutionDate,
      this.createdBy,
      this.requestData});

  factory StandingOrder.fromJson(Map<String, dynamic> json) =>
      _$StandingOrderFromJson(json);

  Map<String, dynamic> toJson() => _$StandingOrderToJson(this);
}
