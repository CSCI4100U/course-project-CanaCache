import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/utils/notifications.dart";
import "package:canacache/features/app/view/app.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart" show kDebugMode;
import "package:flutter/material.dart";
import "package:flutter_native_timezone/flutter_native_timezone.dart";
import "package:timezone/data/latest.dart" as tz;
import "package:timezone/timezone.dart" as tz;

class CanaAppController extends Controller<CanaApp, CanaAppState>
    with WidgetsBindingObserver {
  final _notifications = Notifications();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cancelReminder();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _cancelReminder();
        break;
      case AppLifecycleState.paused:
        _scheduleReminder();
        break;
      default:
    }
  }

  Future<void> initialize() async {
    await Firebase.initializeApp();
    await _notifications.initialize();
    tz.initializeTimeZones();

    final localTimezone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimezone));
  }

  /// Should be called whenever the user closes the app.
  Future<void> _scheduleReminder() {
    const delay = kDebugMode ? Duration(seconds: 5) : Duration(days: 7);
    return _notifications.schedule(
      NotificationChannel.reminders,
      ScheduledNotificationID.reminders,
      "It's been a while",
      "You haven't opened CanaCache for a whole week. Ready for some geocaching?",
      tz.TZDateTime.now(tz.local).add(delay),
    );
  }

  /// Should be called whenever the user opens the app.
  Future<void> _cancelReminder() {
    return _notifications.cancel(ScheduledNotificationID.reminders);
  }
}
