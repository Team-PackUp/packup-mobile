
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:packup/common/util.dart';
import 'package:packup/common/firebase_options.dart';

@pragma('vm:entry-point')
class FirebaseService {

  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;
  FirebaseService._internal();

  late final fireBaseInstance;
  final fcmTokenKey = dotenv.env['FCM_TOKEN_KEY']!;
  AndroidNotificationChannel? androidNotificationChannel;
  final localNotification = FlutterLocalNotificationsPlugin();

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

  Future<void> initConnect() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

    fireBaseInstance = FirebaseMessaging.instance;

    setSettingOption();
    setFcmToken();
    setOsSetting();

    //FCM 토큰은 사용자가 앱을 삭제, 재설치 및 데이터 제거 등 토큰 유실 되었을 때 재발급 로직..?
    fireBaseInstance.onTokenRefresh.listen((nToken) {

    });

    // 백그라운드 핸들러 > 최상위 수준 함수
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);

    // 포그라운드 핸들러
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      fcmForegroundHandler(
          message, localNotification, androidNotificationChannel);
    });
  }

  Future<void> setOsSetting() async {

    if (Platform.isIOS) {
      //await reqIOSPermission(fbMsg);
    } else if (Platform.isAndroid) {
      //Android 8 (API 26) 이상부터는 채널설정이 필수? 라고 한다...
      androidNotificationChannel = const AndroidNotificationChannel(
        'important_channel', // id
        'Important_Notifications', // name
        description: '팩업 중요 알림',
        // description
        importance: Importance.high,
      );

      await localNotification
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidNotificationChannel!);
    }
  }

  Future<void> setFcmToken() async {
    final fcmToken = await fireBaseInstance.getToken();
    saveToken(fcmTokenKey, fcmToken!);
  }

  Future<void> setSettingOption() async {
    NotificationSettings settings = await fireBaseInstance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    /**
     * authorized > 수신 허용
     * denied > 수신 거부
     */
    print('수신 허용 여부: ${settings.authorizationStatus}');
  }
}