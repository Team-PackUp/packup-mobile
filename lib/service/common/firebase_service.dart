
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
class FirebaseService {

  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;
  FirebaseService._internal();

  @pragma('vm:entry-point')
  static Future<void> fcmBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await flutterLocalNotificationsPlugin.initialize(initSettings);

    if (message.data.isNotEmpty) {
      const androidDetails = AndroidNotificationDetails(
        'packup_notification_push',
        'Important Notification',
        channelDescription: 'Used for important notifications',
        importance: Importance.high,
        priority: Priority.high,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      if(message.data['title'].isEmpty || message.data['body'].isEmpty) {
        return;
      }

      await flutterLocalNotificationsPlugin.show(
        0,
        message.data['title'],
        message.data['body'],
        notificationDetails,
      );
    }
  }


  Future<void> fcmForegroundHandler(
      RemoteMessage message,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      AndroidNotificationChannel? channel) async {
    print('[FCM - Foreground] MESSAGE : ${message.data}');

    // if (message.notification != null) {
    //   print('Message also contained a notification: ${message.notification}');
    //   flutterLocalNotificationsPlugin.show(
    //       message.hashCode,
    //       message.notification?.title,
    //       message.notification?.body,
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           channel!.id,
    //           channel.name,
    //           channelDescription: channel.description,
    //           icon: '@mipmap/ic_launcher',
    //         ),
    //         // iOS: const DarwinNotificationDetails(
    //         //   badgeNumber: 1,
    //         //   subtitle: 'the subtitle',
    //         //   sound: 'slow_spring_board.aiff',
    //         // ),
    //       ));
    // }
  }
}