import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:packup/common/util.dart';
import 'package:packup/common/firebase_options.dart';
import '../../common/deep_link/deep_link_handler.dart';

@pragma('vm:entry-point')
class FirebaseService {
  FirebaseService._internal();
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;

  late final FirebaseMessaging _messaging;
  final _fcmTokenKey = dotenv.env['FCM_TOKEN_KEY']!;
  final _localNoti   = FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel? _androidChannel;

  // iOS용 초기화 세트
  static const _iosInit = DarwinInitializationSettings(
    requestAlertPermission:  false,
    requestBadgePermission:  false,
    requestSoundPermission:  false,
    defaultPresentAlert:     true,
    defaultPresentBadge:     true,
    defaultPresentSound:     true,
  );

  @pragma('vm:entry-point')
  static Future<void> fcmBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    final noti = FlutterLocalNotificationsPlugin();

    await noti.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: _iosInit,
      ),
    );

    if (message.notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'packup_notification_push',
      'Important Notification',
      channelDescription: 'Used for important notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    await noti.show(
      0,
      message.notification!.title,
      message.notification!.body,
      const NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails()),
      payload: message.data['deepLink'],
    );
  }

  Future<void> initConnect() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    _messaging = FirebaseMessaging.instance;

    // 알림 권한·채널 설정
    await _setupPlatform();

    // 로컬 알림 플러그인 초기화 (Android + iOS)
    await _localNoti.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: _iosInit,
      ),
      onDidReceiveNotificationResponse: (resp) {
        final payload = resp.payload;
        if (payload != null) {
          try {
            DeepLinkHandler().handle(jsonDecode(payload));
          } catch (e) {
            logger('딥링크 파싱 실패: $e');
          }
        }
      },
    );

    // APNs 토큰 확보 → FCM 토큰 저장
    await _registerFcmToken();

    // 스트림 리스너
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_fcmForegroundHandler);
  }

  Future<void> _setupPlatform() async {
    if (Platform.isIOS) {
      await _requestIosPermission();
    } else if (Platform.isAndroid) {
      _androidChannel ??= const AndroidNotificationChannel(
        'important_channel',
        'Important_Notifications',
        description: '팩업 중요 알림',
        importance: Importance.high,
      );

      await _localNoti
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidChannel!);
    }
  }

  Future<void> _requestIosPermission() async {
    final settings = await _messaging.requestPermission(alert: true, badge: true, sound: true);
    logger('알림 권한 상태: ${settings.authorizationStatus}');

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _registerFcmToken() async {
    String? apns = await _messaging.getAPNSToken();
    if (apns == null) {
      _messaging.onTokenRefresh.listen(_saveToken);
      return;
    }
    _saveToken(await _messaging.getToken());
  }

  void _saveToken(String? token) {
    if (token == null) return;
    saveToken(_fcmTokenKey, token);
  }

  void _fcmForegroundHandler(RemoteMessage msg) {
    if (msg.notification == null) return;

    final details = Platform.isAndroid
        ? NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel!.id,
        _androidChannel!.name,
        channelDescription: _androidChannel!.description,
        icon: '@mipmap/ic_launcher',
      ),
    )
        : const NotificationDetails(iOS: DarwinNotificationDetails());

    _localNoti.show(
      msg.hashCode,
      msg.notification!.title,
      msg.notification!.body,
      details,
      payload: msg.data['deepLink'],
    );
  }
}
