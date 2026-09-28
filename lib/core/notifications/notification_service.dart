import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Initialize timezone database
    tz.initializeTimeZones();

    // Get device timezone
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();

    // Set device timezone
    tz.setLocalLocation(
      tz.getLocation(currentTimeZone.identifier),
    );

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
    );

    final androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'travel_explor_channel',
      'Travel Explor Notifications',
      channelDescription: 'Notifications for Travel Explor',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

 static Future<void> scheduleNotification({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledDate,
}) async {
  final scheduledDateTime = tz.TZDateTime.from(
    scheduledDate,
    tz.local,
  );

  const androidDetails = AndroidNotificationDetails(
    'travel_explor_scheduled_channel',
    'Travel Explor Scheduled Notifications',
    channelDescription: 'Scheduled notifications for Travel Explor',
    importance: Importance.high,
    priority: Priority.high,
  );

  const notificationDetails = NotificationDetails(
    android: androidDetails,
  );
  try {
  await _notificationsPlugin.zonedSchedule(
    id: id,
    title: title,
    body: body,
    scheduledDate: scheduledDateTime,
    notificationDetails: notificationDetails,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
  );
  await checkPendingNotifications();

  print('Scheduled notification successfully');
  print('Scheduled time: $scheduledDateTime');
} catch (e) {
  print('Schedule notification error: $e');
}
}
static Future<void> checkPendingNotifications() async {
  final pendingNotifications =
      await _notificationsPlugin.pendingNotificationRequests();

  print(
    'Pending notifications count: ${pendingNotifications.length}',
  );

  for (final notification in pendingNotifications) {
    print(
      'Pending notification: '
      'id=${notification.id}, '
      'title=${notification.title}, '
      'body=${notification.body}',
    );
  }
}
}