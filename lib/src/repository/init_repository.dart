part of craft_dynamic;

class InitRepository {
  final _services = APIService();
  final _sharedPref = CommonSharedPref();
  final _uiRepository = UIDataRepository();
  final _staticRepository = StaticDataRepository();

  // Must call this method to get app token
  Future<int?> getAppToken() async {
    return _services.getToken();
  }

  // Call this method to get app data
  getAppUIData() async {
    final refreshUIData = await getAppStaticData();
    if (refreshUIData) {
      await getDynamicControls();
    }
  }

  Future<bool> getAppStaticData() async {
    bool refreshUIData = false;
    var staticDataVersion = await _sharedPref.getStaticDataVersion();
    AppLogger.appLogI(tag: "Local data version", message: staticDataVersion);
    await _services.getStaticData().then((value) async {
      await _staticRepository.addStaticData(value);
      final currentStaticDataVersion = value?.staticDataVersion;
      await _sharedPref.addStaticDataVersion(currentStaticDataVersion ?? 0);
      AppLogger.appLogI(
          tag: "New data version", message: currentStaticDataVersion);
      if (currentStaticDataVersion != null &&
          currentStaticDataVersion > staticDataVersion) {
        refreshUIData = true;
      }
    });
    return refreshUIData;
  }

  getDynamicControls() async {
    await _services
        .getUIData(FormId.ACTIONS)
        .then((value) => _uiRepository.addUIDataToDB(uiResponse: value));
    await _services
        .getUIData(FormId.FORMS)
        .then((value) => _uiRepository.addUIDataToDB(uiResponse: value));
    await _services
        .getUIData(FormId.MENU)
        .then((value) => _uiRepository.addUIDataToDB(uiResponse: value));
  }
}
