
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {

  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  //Dart VM은 네이티브 코드에서 Dart 코드로 접근할 수 있는 엔트리 포인트를 @pragma('vm:entry-point') 애너테이션을 통해 설정
  @pragma('vm:entry-point')
  static Future<void> fcmBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();

    if (message.notification != null) {
      print('Background message received: ${message.notification}');
    }
  }

  Future<void> fcmForegroundHandler(
      RemoteMessage message,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      AndroidNotificationChannel? channel) async {
    print('[FCM - Foreground] MESSAGE : ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.notification?.title,
          message.notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel!.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
            // iOS: const DarwinNotificationDetails(
            //   badgeNumber: 1,
            //   subtitle: 'the subtitle',
            //   sound: 'slow_spring_board.aiff',
            // ),
          ));
    }
  }
}