part of craft_dynamic;

class DynamicCraftWrapper extends StatefulWidget {
  final Widget dashboard;
  final Widget appLoadingScreen;
  final Widget appTimeoutScreen;
  final Widget appInactivityScreen;
  final ThemeData appTheme;

  const DynamicCraftWrapper(
      {super.key,
      required this.dashboard,
      required this.appLoadingScreen,
      required this.appTimeoutScreen,
      required this.appInactivityScreen,
      required this.appTheme});

  @override
  State<DynamicCraftWrapper> createState() => _DynamicCraftWrapperState();
}

class _DynamicCraftWrapperState extends State<DynamicCraftWrapper> {
  final _initRepository = InitRepository();
  final _sessionRepository = SessionRepository();
  final _sharedPref = CommonSharedPref();
  var _appTimeout = 60000;

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  initializeApp() async {
    await PermissionUtil.checkRequiredPermissions();
    getCurrentLatLong();
    showLoadingScreen.value = true;
    await getAppData();
  }

  getAppData() async {
    await _initRepository.getAppToken();
    await _initRepository.getAppUIData();
    showLoadingScreen.value = false;
    var timeout = await _sharedPref.getAppIdleTimeout();
    if (timeout != null) {
      setState(() {
        _appTimeout = timeout;
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
}
