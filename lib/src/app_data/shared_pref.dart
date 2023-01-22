part of craft_dynamic;

const storage = FlutterSecureStorage();

class CommonSharedPref {
  static addDeviceData(String token, String device, String iv) async {
    await storage.write(key: "token", value: token);
    await storage.write(key: "device", value: device);
    await storage.write(key: "iv", value: iv);
  }

  static addRoutes(Map routesMap) async {
    routesMap.forEach((key, value) {
      storage.write(key: key, value: value.toLowerCase());
    });
  }

  addStaticDataVersion(int version) async {
    await storage.write(key: "currentDataVersion", value: version.toString());
  }

  addActivationData(String mobileNumber, String customerID) async {
    debugPrint("Setting activation data... $mobileNumber###$customerID");
    await storage.write(key: "customerMobile", value: mobileNumber);
    await storage.write(key: "customerID", value: customerID);
    await storage.write(key: "appactivated", value: "true");
  }

  getStaticDataVersion() async {
    return int.parse(await storage.read(key: "currentDataVersion") ?? "1");
  }

  addAppIdleTimeout(int? appIdleTimeout) async {
    if (appIdleTimeout != null) {
      await storage.write(
          key: "appIdleTimeout", value: appIdleTimeout.toString());
    }
  }

  getAppIsActivated() async {
    return await storage.read(key: "appactivated");
  }

  getAppIdleTimeout() async {
    return int.parse(await storage.read(key: "appIdleTimeout") ?? "1");
  }

  getRoute(String routeName) async {
    return await storage.read(key: routeName);
  }

  addUserAccountData({required key, required value}) async {
    await storage.write(key: key, value: value);
  }

  getCustomerMobile() async {
    return await storage.read(key: "customerMobile");
  }

  getCustomerID() async {
    return await storage.read(key: "customerID");
  }

  Future<String?> getCustomerFirstName() async {
    return await storage.read(key: "FirstName");
  }

  getUserData(String key) async {
    return await storage.read(key: key);
  }

  getLocalToken() async {
    return await storage.read(key: "token");
  }

  getLocalDevice() async {
    return await storage.read(key: "device");
  }

  getLocalIv() async {
    return await storage.read(key: "iv");
  }

  getBio() async {
    return await storage.read(key: "biometric");
  }

  setBio(bool isBio) async {
    await storage.write(key: "biometric", value: isBio.toString());
  }

  setBioPin(String bioPin) async {
    await storage.write(key: "biopin", value: bioPin);
  }

  getBioPin() async {
    return await storage.read(key: "biopin");
  }

  setUniqueID(String uniqueID) async {
    await storage.write(key: "uniqueID", value: uniqueID);
  }

  getUniqueID() async {
    return await storage.read(key: "uniqueID");
  }

  setLatLong(String latlong) async {
    await storage.write(key: "latlong", value: latlong);
  }

  getLatLong() async {
    return json.decode(await storage.read(key: "latlong") ?? "{}");
  }
}
