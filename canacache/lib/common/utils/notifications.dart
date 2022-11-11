import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:timezone/timezone.dart" as tz;

enum ScheduledNotificationID {
  reminders,
}

enum NotificationChannel {
  reminders(
    NotificationDetails(
      android: AndroidNotificationDetails(
        "reminders",
        "Reminders",
        channelShowBadge: false,
      ),
    ),
  );

  const NotificationChannel(this.details);
  final NotificationDetails details;
}

class Notifications {
  factory Notifications() => _this;
  Notifications._();
  static final _this = Notifications._();

  final _plugin = FlutterLocalNotificationsPlugin();
  var _notificationID = 1000; // give lots of room for scheduled ids

  /// Initialize the notification plugin.
  ///
  /// This only needs to be done once, when the app loads.
  Future<void> initialize() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("mipmap/round_launcher"),
    );
    await _plugin.initialize(initializationSettings);
  }

  /// Show a notification immediately.
  ///
  /// Will return the id of the sent notification. This id will NOT be unique across app restarts.
  Future<int> show(
    NotificationChannel notificationChannel,
    String title,
    String body,
  ) async {
    final id = _notificationID++;
    await _plugin.show(id, title, body, notificationChannel.details);
    return id;
  }

  /// Schedule a notification to be shown at some point in the future.
  ///
  /// The id is auto-generated from the enum index, to avoid accidental collisions.
  Future<void> schedule(
    NotificationChannel notificationChannel,
    ScheduledNotificationID id,
    String title,
    String body,
    tz.TZDateTime scheduledDate,
  ) {
    return _plugin.zonedSchedule(
      id.index,
      title,
      body,
      scheduledDate,
      notificationChannel.details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  /// Cancel a scheduled notification.
  Future<void> cancel(ScheduledNotificationID id) {
    return _plugin.cancel(id.index);
  }
}
