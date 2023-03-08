part of craft_dynamic;

class DynamicCraftWrapper extends StatefulWidget {
  final Widget dashboard;
  final Widget appLoadingScreen;
  final Widget appTimeoutScreen;
  final Widget appInactivityScreen;
  final ThemeData appTheme;
  MenuType? menuType;
  Color? menuColor;

  DynamicCraftWrapper(
      {super.key,
      required this.dashboard,
      required this.appLoadingScreen,
      required this.appTimeoutScreen,
      required this.appInactivityScreen,
      required this.appTheme,
      this.menuType,
      this.menuColor});

  @override
  State<DynamicCraftWrapper> createState() => _DynamicCraftWrapperState();
}

class _DynamicCraftWrapperState extends State<DynamicCraftWrapper> {
  final _initRepository = InitRepository();
  final _sessionRepository = SessionRepository();
  final _sharedPref = CommonSharedPref();
  final _dynamicRequest = DynamicFormRequest();
  var _appTimeout = 100000;

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  initializeApp() async {
    await getAppLaunchCount();
    await PermissionUtil.checkRequiredPermissions();
    getCurrentLatLong();
    showLoadingScreen.value = true;
    await getAppData();
  }

  getAppLaunchCount() async {
    var launchCount = await _sharedPref.getLaunchCount();
    if (launchCount == 0) {
      _sharedPref.clearPrefs();
      _sharedPref.setLaunchCount(launchCount++);
    }
    if (launchCount < 5) {
      _sharedPref.setLaunchCount(launchCount++);
    }
  }

  getAppData() async {
    await _initRepository.getAppToken();
    getAppAssets();
    await _initRepository.getAppUIData();
    showLoadingScreen.value = false;
    var timeout = await _sharedPref.getAppIdleTimeout();
    if (timeout != null) {
      setState(() {
        _appTimeout = timeout ?? 100000;
      });
    }
    periodicActions(timeout ?? _appTimeout);
  }

  periodicActions(int timeout) {
    Timer.periodic(Duration(milliseconds: timeout), (timer) {
      _initRepository.getAppToken();
      getCurrentLatLong();
    });
  }

  getCurrentLatLong() {
    LocationUtil.getLatLong().then((value) {
      _sharedPref.setLatLong(json.encode(value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return _sessionRepository.getSessionManager(
        ChangeNotifierProvider(
            create: (context) => PluginState(),
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: widget.appTheme,
              home: Obx(() => showLoadingScreen.value
                  ? widget.appLoadingScreen
                  : widget.dashboard),
              navigatorKey: Get.key,
              builder: (context, child) {
                setPluginWidgets(
                  widget.appTimeoutScreen,
                  context,
                  widget.menuType,
                  widget.menuColor,
                );
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!,
                );
              },
            )),
        context: context,
        _appTimeout,
        widget.appInactivityScreen,
        widget.appTimeoutScreen);
  }

  setPluginWidgets(Widget logoutWidget, BuildContext context,
      MenuType? menuType, Color? menuColor) {
    if (menuType != null) {
      Provider.of<PluginState>(context, listen: false).setMenuType(menuType);
    }
    if (menuColor != null) {
      Provider.of<PluginState>(context, listen: false).setMenuColor(menuColor);
    }
    Provider.of<PluginState>(context, listen: false)
        .setLogoutScreen(logoutWidget);
  }

  getAppAssets() {
    var params = [
      {"BANKID": APIService.bankID},
      {"COUNTRY": APIService.countryName},
      {"CATEGORY": "LOGIN"},
      {"HEADER": "GetBankImages"}
    ];

    _dynamicRequest.dynamicRequest(null, dataObj: params).then((value) {
      debugPrint("All images:::${value?.dynamicList}");
    });
  }
}
