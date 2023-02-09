// ignore_for_file: unnecessary_string_interpolations, prefer_typing_uninitialized_variables

part of craft_dynamic;

class APIService {
  static final APIService _apiService = APIService._internal();

  static Map? appConfig,
      urlsConfig,
      requestConfig,
      cryptConfig,
      appPropertiesConfig;
  static bool isTestUrl = true;
  static String currentBaseUrl = "";
  static String uatUrl = "";
  static String liveUrl = "";
  static String tokenUrl = "";
  static String appName = "";
  static String bankID = "";
  static String countryName = "";

  static String staticLogKeyValue = "";
  static String staticEncryptIv = "";

  static String appLabel = "";
  static Color appPrimaryColor = Colors.blue;
  static Color appSecondaryColor = Colors.blueAccent;

  static final dio = Dio();
  var logger = Logger();
  final _sharedPref = CommonSharedPref();

  factory APIService() {
    Future.sync(() => initializeObject());
    return _apiService;
  }

  APIService._internal();

  static initializeObject() async {
    String yamlConfiguration =
        await rootBundle.loadString('assets/plugin_config.yaml');
    appConfig = loadYaml(yamlConfiguration);
    AppLogger.appLogI(
        tag: "Initialized yaml configuration file", message: appConfig);
    getAppConfigKeys();
    getAppConfigValues();
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    return yamlConfiguration;
  }

  static void getAppConfigKeys() {
    urlsConfig = appConfig?["urls"];
    requestConfig = appConfig?["request"];
    cryptConfig = appConfig?["crypt"];
    appPropertiesConfig = appConfig?["appProperties"];
  }

  static void getAppConfigValues() {
    appLabel = appPropertiesConfig?["appLabel"];
    appPrimaryColor = "#${appPropertiesConfig?["appPrimaryColor"]}".toColor();
    appSecondaryColor =
        "#${appPropertiesConfig?["appSecondaryColor"]}".toColor();
    staticLogKeyValue = cryptConfig?["staticLogKeyValue"];
    staticEncryptIv = cryptConfig?["staticEncryptIv"];
    isTestUrl = urlsConfig?["test"] ?? true;
    uatUrl = urlsConfig?["uat"] ?? "";
    liveUrl = urlsConfig?["live"] ?? "";
    tokenUrl = urlsConfig?["tokenUrl"] ?? "";
    appName = requestConfig?["appName"] ?? "";
    currentBaseUrl = isTestUrl ? uatUrl : liveUrl;
    bankID = requestConfig?["bankId"].toString() ?? "";
    countryName = requestConfig?["country"];
  }

  Future<Map<String, dynamic>> buildRequestMap() async {
    var requestBuilder = RequestBuilder(
        bankID: bankID,
        country: countryName,
        versionNumber: requestConfig?["versionNumber"].toString(),
        trxSource: requestConfig?["trxSource"],
        appName: requestConfig?["appName"],
        imei: CryptLib.encryptField(await DeviceInfo.getDeviceUniqueID()),
        imsi: CryptLib.encryptField(await DeviceInfo.getDeviceUniqueID()),
        latLong: await _sharedPref.getLatLong(),
        customerId: await _sharedPref.getCustomerID());
    return RequestObject(requestBuilder).createRequestMap();
  }

  Future<String> dioRequestBodySetUp(String formID,
      {Map<String, dynamic>? objectMap}) async {
    Map<String, dynamic> requestObject = {};
    var localDevice = await _sharedPref.getLocalDevice();
    var localIV = await _sharedPref.getLocalIv();

    requestObject[RequestParam.FormID.name] = formID;
    requestObject[RequestParam.SessionID.name] = Constants.getUniqueID();
    requestObject.addAll(await buildRequestMap());
    if (objectMap != null) {
      requestObject.addAll(objectMap);
    }
    AppLogger.appLogE(tag: "\n\nREQUEST", message: jsonEncode(requestObject));

    return CryptLib.encrypt(jsonEncode(requestObject), localDevice, localIV);
  }

  Future<Response?> performDioRequest(String encryptedBody,
      {String? route, String? requestUrl}) async {
    Response? response;
    String uniqueID = await _sharedPref.getUniqueID();
    var localToken = await _sharedPref.getLocalToken();
    var url = route ?? currentBaseUrl + requestUrl!;

    AppLogger.appLogI(tag: "REQ:ROUTE", message: url);
    try {
      response = await dio.post(url,
          options: Options(
            headers: {'T': localToken},
          ),
          data: {"Data": encryptedBody, "UniqueId": uniqueID});
    } catch (e) {
      AppLogger.appLogE(tag: "DIO:ERROR", message: e.toString());
      Fluttertoast.showToast(
          msg: "Connection error!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return response;
  }

  Future<int?> getToken() async {
    var data;
    var keys = "";
    String routes, device, iv, token = "";
    List<int> dataArr;
    List<String> deviceCharArray;
    Map<String, dynamic> requestObject = {};

    String uniqueID = Constants.getUniqueID();
    AppLogger.appLogI(tag: "UNIQUEID:", message: uniqueID);
    var latLong = await _sharedPref.getLatLong();
    await _sharedPref.setUniqueID(uniqueID);
    requestObject["appName"] = appName;
    requestObject["codeBase"] = Constants.getHostPlatform();
    requestObject["Device"] = await DeviceInfo.getDeviceUniqueID();
    requestObject["lat"] = latLong?["lat"] ?? "0.00";
    requestObject["longit"] = latLong?["long"] ?? "0.00";
    requestObject["UniqueId"] = uniqueID;
    requestObject[RequestParam.MobileNumber.name] =
        requestConfig?["bankId"].toString();

    AppLogger.appLogE(tag: "REQ:", message: jsonEncode(requestObject));

    var dioResponse;
    try {
      dioResponse =
          await dio.post(currentBaseUrl + tokenUrl, data: requestObject);
      AppLogger.writeResponseToFile(
          fileName: "TOken res", response: dioResponse.toString());
      if (dioResponse.statusCode == 200) {
        device = dioResponse.data["payload"]["Device"];
        data = dioResponse.data["data"];
        token = dioResponse.data["token"];

        deviceCharArray = device.split('');
        dataArr = data.cast<int>();
        for (var i in dataArr) {
          keys += deviceCharArray[i];
        }
        iv = dioResponse.data["payload"]["Ran"];
        await CommonSharedPref.addDeviceData(token, keys, iv);
        routes = CryptLib.decrypt(dioResponse.data["payload"]["Routes"],
            CryptLib.toSHA256(keys, 32), iv);
        AppLogger.appLogI(tag: "REQ:ROUTES", message: routes);
        await CommonSharedPref.addRoutes(json.decode(routes));
      }
    } catch (e) {
      AppLogger.appLogE(tag: "ERROR:", message: e.toString());
    }
    return dioResponse?.statusCode;
  }

  Future<UIResponse?> getUIData(FormId formId) async {
    UIResponse? uiResponse;
    String res, decrypted = "";

    final route = await _sharedPref.getRoute("staticdata".toLowerCase());
    await performDioRequest(await dioRequestBodySetUp(formId.name),
            route: route)
        .then((value) async => {
              res = value?.data["Response"],
              // decrypted = await CryptLib.oldDecrypt(res),
              decrypted = CryptLib.gzipDecompressStaticData(res),
              AppLogger.appLogI(tag: "\n\n$formId REQ", message: decrypted),
              AppLogger.writeResponseToFile(
                  fileName: formId.name, response: decrypted),
            });

    try {
      uiResponse = UIResponse.fromJson(jsonDecode(decrypted)[0]);
    } catch (e) {
      AppLogger.appLogE(tag: "DECODE:ERROR", message: e.toString());
    }
    return uiResponse ?? UIResponse(status: "XXXX");
  }

  Future<StaticResponse?> getStaticData(
      {currentStaticDataVersion, formId = "STATICDATA"}) async {
    String res, decrypted = "";
    StaticResponse? staticResponse;
    final route = await _sharedPref.getRoute("other".toLowerCase());
    await performDioRequest(await dioRequestBodySetUp(formId), route: route)
        .then((value) async => {
              res = value?.data["Response"],
              decrypted = await CryptLib.decryptResponse(res),
              // decrypted = CryptLib.gzipDecompressStaticData(res),
              AppLogger.appLogI(
                  tag: "\n\nSTATIC DATA REQ:", message: decrypted),
              AppLogger.writeResponseToFile(
                  fileName: "Static", response: decrypted),
            });
    try {
      staticResponse = StaticResponse.fromJson(jsonDecode(decrypted));
    } catch (e) {
      AppLogger.appLogE(tag: "DECODE:ERROR", message: e.toString());
    }
    return staticResponse;
  }

  Future<DynamicResponse> dynamicRequest({
    required formID,
    required requestObj,
    required webHeader,
  }) async {
    String res, decrypted = "";
    DynamicResponse? dynamicResponse;
    final route = await _sharedPref
        .getRoute(webHeader?.toLowerCase() ?? "other".toLowerCase());
    await performDioRequest(
            await dioRequestBodySetUp(formID, objectMap: requestObj),
            route: route)
        .then((value) async {
      res = value?.data["Response"];
      decrypted = await CryptLib.decryptResponse(res);
      AppLogger.appLogI(tag: "\n\nnDYNAMIC RESPONSE", message: decrypted);
    });
    try {
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(decrypted));
    } catch (e) {
      AppLogger.appLogE(tag: "DECODE:ERROR", message: e.toString());
    }
    return dynamicResponse ?? DynamicResponse(status: "XXXX");
  }

  Future<ActivationResponse> login(String encryptedPin,
      {formId = "LOGIN"}) async {
    String res, decrypted = "";
    Map<String, dynamic> requestObj = {};
    ActivationResponse? activationResponse;

    // requestObj["AppNotificationID"] = Constants.appNotificationID;
    requestObj["MobileNumber"] = await _sharedPref.getCustomerMobile();
    requestObj["Login"] = {"LoginType": "PIN"};
    requestObj["EncryptedFields"] = {"PIN": "$encryptedPin"};

    final route = await _sharedPref.getRoute("auth".toLowerCase());
    await performDioRequest(
            await dioRequestBodySetUp(formId, objectMap: requestObj),
            route: route)
        .then((value) async {
      debugPrint(value.toString());
      res = value?.data["Response"];
      decrypted = await CryptLib.decryptResponse(res);
      AppLogger.appLogI(tag: "\n\nnACTIVATION RESPONSE", message: decrypted);
      AppLogger.writeResponseToFile(fileName: "Login_res", response: decrypted);
    });
    try {
      activationResponse = ActivationResponse.fromJson(json.decode(decrypted));
    } catch (e) {
      AppLogger.appLogE(tag: "DECODE:ERROR", message: e.toString());
    }
    return activationResponse ?? ActivationResponse(status: "XXXX");
  }

  Future<ActivationResponse> activateMobile(
      {mobileNumber, encryptedPin, formId = "ACTIVATIONREQ"}) async {
    String res, decrypted = "";
    ActivationResponse? activationResponse;

    Map<String, dynamic> requestObj = {};
    requestObj["MobileNumber"] = mobileNumber;
    requestObj["Activation"] = {};
    requestObj["EncryptedFields"] = {"PIN": "$encryptedPin"};

    final route = await _sharedPref.getRoute("auth".toLowerCase());
    await performDioRequest(
            await dioRequestBodySetUp(formId, objectMap: requestObj),
            route: route)
        .then((value) async => {
              res = value?.data["Response"],
              decrypted = await CryptLib.decryptResponse(res),
              logger.d("\n\nACTIVATION RESPONSE: $decrypted"),
            });
    try {
      activationResponse = ActivationResponse.fromJson(json.decode(decrypted));
    } catch (e) {
      AppLogger.appLogE(tag: "DECODE:ERROR", message: e.toString());
    }
    return activationResponse ?? ActivationResponse(status: "XXXX");
  }

  Future<ActivationResponse> verifyOTP(
      {mobileNumber, key, formId = "ACTIVATE"}) async {
    String res, decrypted = "";
    final encryptedKey = CryptLib.encryptField(key);
    ActivationResponse? activationResponse;

    Map<String, dynamic> requestObj = {};
    requestObj["MobileNumber"] = mobileNumber;
    requestObj["Activation"] = {};
    requestObj["EncryptedFields"] = {"Key": "$encryptedKey"};

    final route = await _sharedPref.getRoute("auth".toLowerCase());
    await performDioRequest(
            await dioRequestBodySetUp(
              formId,
              objectMap: requestObj,
            ),
            route: route)
        .then((value) async => {
              res = value?.data["Response"],
              decrypted = await CryptLib.decryptResponse(res),
              logger.d("\n\nOTP VERIFICATION RESPONSE: $decrypted"),
            });

    try {
      activationResponse = ActivationResponse.fromJson(json.decode(decrypted));
    } catch (e) {
      AppLogger.appLogE(tag: "DECODE:ERROR", message: e.toString());
    }
    return activationResponse ?? ActivationResponse(status: "XXXX");
  }

  Future<DynamicResponse?> checkAccountBalance(
      {required bankAccountID,
      required merchantID,
      required moduleID,
      formId = "PAYBILL"}) async {
    String res, decrypted = "";
    DynamicResponse? dynamicResponse;
    Map<String, dynamic> innerMap = {};
    Map<String, dynamic> requestObj = {};
    innerMap["BANKACCOUNTID"] = bankAccountID;
    innerMap["MerchantID"] = merchantID;
    requestObj["ModuleID"] = moduleID;
    requestObj["PayBill"] = innerMap;

    final route = await _sharedPref.getRoute("account".toLowerCase());
    await performDioRequest(
            await dioRequestBodySetUp(formId, objectMap: requestObj),
            route: route)
        .then((value) async => {
              res = value?.data["Response"],
              debugPrint("Raw res: $res"),
              decrypted = await CryptLib.decryptResponse(res),
              logger.d("\n\nBANK BALANCE RESPONSE: $decrypted"),
            });
    try {
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(decrypted));
    } catch (e) {
      AppLogger.appLogE(tag: "DECODE:ERROR", message: e.toString());
    }
    return dynamicResponse ?? DynamicResponse(status: "XXX");
  }

  Future<DynamicResponse?> checkMiniStatement(
      {required bankAccountID,
      required merchantID,
      required moduleID,
      formId = "PAYBILL"}) async {
    String res, decrypted = "";
    DynamicResponse? dynamicResponse;
    Map<String, dynamic> innerMap = {};
    Map<String, dynamic> requestObj = {};
    innerMap["BANKACCOUNTID"] = bankAccountID;
    innerMap["MerchantID"] = merchantID;
    requestObj["ModuleID"] = moduleID;
    requestObj["PayBill"] = innerMap;
    requestObj["MerchantID"] = merchantID;

    final route = await _sharedPref.getRoute("account".toLowerCase());
    await performDioRequest(
            await dioRequestBodySetUp(formId, objectMap: requestObj),
            route: route)
        .then((value) async => {
              res = value?.data["Response"],
              debugPrint("Raw res: $res"),
              decrypted = await CryptLib.decryptResponse(res),
              logger.d("\n\nMINI-STATEMENT RESPONSE: $decrypted"),
            });
    try {
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(decrypted));
    } catch (e) {
      AppLogger.appLogE(tag: "DECODE:ERROR", message: e.toString());
    }
    return dynamicResponse ?? DynamicResponse(status: "XXX");
  }
}
