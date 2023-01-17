part of craft_dynamic;

class SessionRepository {
  static final SessionRepository _singleton = SessionRepository._internal();
  final sessionStateStream = StreamController<SessionState>();

  factory SessionRepository() {
    return _singleton;
  }

  void startSession() {
    sessionStateStream.add(SessionState.startListening);
  }

  MySessionConfig config({required appTimeout}) {
    return MySessionConfig(
        invalidateSessionForAppLostFocus:
            Duration(milliseconds: appTimeout == null ? 5000 : appTimeout!),
        invalidateSessionForUserInactiviity:
            Duration(milliseconds: appTimeout == null ? 5000 : appTimeout!));
  }

  void addSessionStateStream(MySessionConfig sessionConfig,
      {required BuildContext context,
      required Widget inactivityTimeoutRoute,
      required Widget focusTimeoutRoute}) {
    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      sessionStateStream.add(SessionState.stopListening);

      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        AppLogger.appLogI(tag: "Session", message: "App inactivity...");
        try {
          CommonUtils.newRouter(widget: inactivityTimeoutRoute);
        } catch (e) {
          AppLogger.appLogI(tag: "Session:error", message: e.toString());
        }
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        AppLogger.appLogI(tag: "Session", message: "App lost focus...");
        try {
          CommonUtils.newRouter(widget: focusTimeoutRoute);
        } catch (e) {
          AppLogger.appLogI(tag: "Session:error", message: e.toString());
        }
      }
    });
  }

  Widget getSessionManager(Widget child, int appTimeout,
      Widget inactivityTimeoutRoute, Widget focusTimeoutRoute,
      {required context}) {
    final myConfig = config(appTimeout: appTimeout);
    addSessionStateStream(myConfig,
        context: context,
        inactivityTimeoutRoute: inactivityTimeoutRoute,
        focusTimeoutRoute: focusTimeoutRoute);
    return SessionTimeoutManager(
        sessionConfig: myConfig,
        sessionStateStream: sessionStateStream.stream,
        child: child);
  }

  SessionRepository._internal();
}
