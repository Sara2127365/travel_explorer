
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:travel_explorer/core/notifications/notification_service.dart';
import 'package:travel_explorer/core/routes/app_navigator.dart';
import 'package:travel_explorer/core/routes/app_routes.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  debugPrint('==============================');
  debugPrint('BACKGROUND FCM MESSAGE');
  debugPrint('Message ID: ${message.messageId}');
  debugPrint(
    'Title: ${message.notification?.title}',
  );
  debugPrint(
    'Body: ${message.notification?.body}',
  );
  debugPrint(
    'Data: ${message.data}',
  );
  debugPrint('==============================');
}

class FcmService {
  static final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  static Future<void> init() async {
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    // Request notification permission
    final settings =
        await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
      'FCM Permission: '
      '${settings.authorizationStatus}',
    );

    // Get FCM token
    final token = await _messaging.getToken();

    debugPrint('==============================');
    debugPrint('FCM TOKEN:');
    debugPrint(token);
    debugPrint('==============================');

    // Token refresh
    _messaging.onTokenRefresh.listen(
      (newToken) {
        debugPrint(
          'FCM TOKEN REFRESHED: $newToken',
        );
      },
    );

    // Foreground messages
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        debugPrint('==============================');
        debugPrint('FCM MESSAGE RECEIVED');

        final title =
            message.notification?.title ??
                'Travel Explor';

        final body =
            message.notification?.body ??
                'New notification';

        debugPrint('Title: $title');
        debugPrint('Body: $body');
        debugPrint(
          'Data: ${message.data}',
        );

        debugPrint('==============================');

        // Show notification while app is open
        await NotificationService.showNotification(
          id: message.hashCode,
          title: title,
          body: body,
        );
      },
    );

    // App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        debugPrint('Notification clicked');
        debugPrint(
          'Data: ${message.data}',
        );

        _handleNotificationClick(message);
      },
    );

    // App opened from terminated state
    final initialMessage =
        await _messaging.getInitialMessage();

    if (initialMessage != null) {
      debugPrint(
        'App opened from terminated notification',
      );

      debugPrint(
        'Data: ${initialMessage.data}',
      );

      _handleNotificationClick(
        initialMessage,
      );
    }
  }

  static void _handleNotificationClick(
    RemoteMessage message,
  ) {
    final type = message.data['type'];

    debugPrint(
      'Notification type: $type',
    );

    if (type == 'hotel') {
      navigatorKey.currentState?.pushNamed(
        AppRoutes.mainScreen,
        arguments: 1,
      );
    }
  }
}

