// ignore_for_file: constant_identifier_names

part of craft_dynamic;

enum ViewType {
  TEXT,
  BUTTON,
  RBUTTON,
  DROPDOWN,
  TAB,
  LABEL,
  QRSCANNER,
  PHONECONTACTS,
  DATE,
  HIDDEN,
  LIST,
  TEXTVIEW,
  HYPERLINK,
  CONTAINER,
  SELECTEDTEXT,
  IMAGE,
  TITLE,
  FORM,
  OTHER,
  STEPPER,
  STEP,
  CHECKBOX,
  HORIZONTALTEXT,
  DYNAMICDROPDOWN,
  CAROUSELVIEW
}

enum ControlFormat {
  PinNumber,
  PIN,
  NUMERIC,
  Amount,
  DATE,
  imagepanel,
  HorizontalScroll,
  SELECTBANKACCOUNT,
  SELECTBENEFICIARY,
  LISTDATA,
  OTHER,
  OPENFORM,
  NEXT,
  RADIOGROUPS
}

enum FormId { MENU, FORMS, ACTIONS, STATICDATA, LOGIN }

enum DynamicDataType { Modules, ActionControls, FormControls }

enum ControlID {
  BANKACCOUNTID,
  BANKACCOUNTID1,
  BANKACCOUNTID2,
  BANKACCOUNTID3,
  BANKACCOUNTID4,
  BANKACCOUNTID5,
  BENEFICIARYACCOUNTID,
  OTHER,
  AMOUNT,
  BIBLELIST,
  TOACCOUNTID,
  SELECTTYPE
}

enum ActionType {
  DBCALL,
  ACTIVATIONREQ,
  PAYBILL,
  VALIDATE,
  LOGIN,
  CHANGEPIN,
  ACTIVATE,
  BENEFICIARY
}

enum ActionID { GETTRXLIST }

enum UserAccountData {
  FirstName,
  LastName,
  IDNumber,
  EmailID,
  ImageUrl,
  LastLoginDateTime,
  LoanLimit
}

enum RequestParam {
  FormID,
  SessionID,
  CustomerID,
  MobileNumber,
  Login,
  EncryptedFields,
  Activation,
  ModuleID,
  PayBill,
  UNIQUEID,
  BankID,
  Country,
  VersionNumber,
  IMEI,
  IMSI,
  TRXSOURCE,
  APPNAME,
  CODEBASE,
  LATLON,
  MerchantID,
  Validate,
  HEADER,
  DynamicForm,
  CHANGEPIN
}

enum FormFieldProp { ControlID, ControlValue }

enum ListType { TransactionList, ViewOrderList, BeneficiaryList }

enum ModuleId {
  DEFAULT,
  BOOKCAB,
  MERCHANTPAYMENT,
  GAS,
  DRINKS,
  TOPUPWALLET,
  SUPERMARKET,
  GROCERIES,
  PHARMACY,
  CAKE,
  FOOD,
  FINGERPRINT,
  TRANSACTIONSCENTER,
  PENDINGTRANSACTIONS,
  VIEWBENEFICIARY,
  STANDINGORDERVIEWDETAILS
}

enum LittleProduct {
  Ride,
  PayMerchants,
  LoadWallet,
  Deliveries,
}

enum StatusCode {
  success("000"),
  failure("091"),
  token("099"),
  changePin("101");

  const StatusCode(this.statusCode);
  final String statusCode;
}
