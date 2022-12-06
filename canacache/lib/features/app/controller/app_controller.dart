import "dart:async";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/utils/notifications.dart";
import "package:canacache/features/app/view/app.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:canacache/features/stats_recording/distance_recorder.dart";
import "package:canacache/features/stats_recording/step_recorder.dart";
import "package:canacache/features/stats_recording/time_recorder.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart" show kDebugMode;
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_native_timezone/flutter_native_timezone.dart";
import "package:flutter_translate/flutter_translate.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:provider/provider.dart";
import "package:timezone/data/latest.dart" as tz;
import "package:timezone/timezone.dart" as tz;

class CanaAppController extends Controller<CanaApp, CanaAppState>
    with WidgetsBindingObserver {
  final _notifications = Notifications();
  final providers = [
    ChangeNotifierProvider(create: (_) => SettingsProvider()),
  ];
  late List<LocalizationsDelegate> delegates;
  late LocalizationDelegate localizationDelegate;

  late TimeRecorder timeRecorder;
  late DistanceRecorder distRecorder;
  late StepRecorder stepRecorder;
  List<Timer> timers = [];

  void _addTimers() {
    if (timers.isEmpty) {
      timers = [
        Timer.periodic(
          const Duration(seconds: TimeRecorder.interval),
          (Timer t) => timeRecorder.newEpoch(),
        ),
        Timer.periodic(
          const Duration(seconds: DistanceRecorder.interval),
          (Timer t) => distRecorder.newEpoch(),
        ),
        Timer.periodic(
          const Duration(seconds: StepRecorder.interval),
          (Timer t) => stepRecorder.newEpoch(),
        ),
      ];
    }
  }

  void _clearTimers() {
    for (Timer timer in timers) {
      timer.cancel();
    }
    timers = [];
  }

  @override
  void initState() {
    super.initState();

    // can't access context with default initializer, so the
    // next best thing is initializing it late here!
    localizationDelegate = LocalizedApp.of(state.context).delegate;

    delegates = [
      ...GlobalMaterialLocalizations.delegates,
      GlobalWidgetsLocalizations.delegate,
      localizationDelegate,
    ];

    WidgetsBinding.instance.addObserver(this);
    _cancelReminder();

    timeRecorder = TimeRecorder();
    distRecorder = DistanceRecorder();
    stepRecorder = StepRecorder();
    _addTimers();
  }

  @override
  void dispose() {
    _scheduleReminder();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _addTimers();
        _cancelReminder();
        break;
      case AppLifecycleState.paused:
        _clearTimers();
        _scheduleReminder();
        break;
      default:
    }
  }

  Future<void> initialize() async {
    await Firebase.initializeApp();
    await _notifications.initialize();
    await initializeDateFormatting();
    tz.initializeTimeZones();

    final localTimezone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimezone));

    await initializeDateFormatting();
  }

  /// Should be called whenever the user closes the app.
  Future<void> _scheduleReminder() {
    const delay = kDebugMode ? Duration(seconds: 10) : Duration(days: 7);
    return _notifications.schedule(
      NotificationChannel.reminders,
      ScheduledNotificationID.reminders,
      "It's been a while",
      "You haven't opened CanaCache for a long time. Ready for some geocaching?",
      tz.TZDateTime.now(tz.local).add(delay),
    );
  }

  /// Should be called whenever the user opens the app.
  Future<void> _cancelReminder() {
    return _notifications.cancel(ScheduledNotificationID.reminders);
  }
}
