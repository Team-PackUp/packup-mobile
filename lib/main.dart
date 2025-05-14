import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:packup/Common/util.dart';
import 'package:packup/provider/payment/toss/toss_payment_provider.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:packup/common/router.dart';
import 'package:packup/provider/common/loading_provider.dart';

import 'package:packup/service/common/loading_service.dart';
import 'package:packup/service/common/socket_service.dart';
import 'package:packup/widget/common/loading_progress.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:packup/theme/theme.dart';

import 'package:packup/provider/user/user_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:packup/service/common/firebase_service.dart';
import 'common/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String envFile = ".env"; // 기본 파일

  /**
   * 배포용 빌드 AOS: flutter build apk --dart-define=ENV=prod
   * 개발용 빌드 AOS: flutter build apk --dart-define=ENV=dev
   * 배포용 빌드 IOS: 확인 필요
   * 개발용 빌드 IOS: 확인 필요
   * IDE에서 실행하는 경우 실행 플랫폼에 맞게 설정
   *
   * >> prod 환경에서 OS별 환경변수 파일 구분 필요한 경우 수정 해야됨
   */
  const String environment = String.fromEnvironment('ENV', defaultValue: 'dev');
  if (environment == 'prod') {
    envFile = ".env.prod";
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    envFile = ".env.android";
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    envFile = ".env.ios";
  }

  await dotenv.load(fileName: envFile);

  // 초기 테마 세팅
  String defaultTheme = await getDefaultTheme();
  PackUp.themeNotifier.value =
      defaultTheme == "light" ? ThemeMode.light : ThemeMode.dark;

  // 카카오 로그인 초기화
  String KAKAO_NATIVE_APP_KEY = dotenv.env['KAKAO_NATIVE_APP_KEY']!;
  String JAVASCRIPT_APP_KEY = dotenv.env['JAVASCRIPT_APP_KEY']!;

  KakaoSdk.init(
    nativeAppKey: KAKAO_NATIVE_APP_KEY,
    javaScriptAppKey: JAVASCRIPT_APP_KEY,
  );

  // ▼ socket
  await SocketService().initConnect();
  // ▲ socket

  // ▼ firebase
  final firebaseService = FirebaseService();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  final fireBaseInstance = FirebaseMessaging.instance;
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

  final fcmTokenKey = dotenv.env['FCM_TOKEN_KEY']!;
  final fcmToken = await fireBaseInstance.getToken();
  print("FCM 토큰 >> " + fcmToken.toString());
  saveToken(fcmTokenKey, fcmToken!);

  //FCM 토큰은 사용자가 앱을 삭제, 재설치 및 데이터 제거 등 토큰 유실 되었을 때 재발급 로직..?
  fireBaseInstance.onTokenRefresh.listen((nToken) {

  });

  final localNotification = FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel? androidNotificationChannel;

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
        ?.createNotificationChannel(androidNotificationChannel);
  }

  // // 백그라운드 핸들러 > 최상위 수준 함수
  FirebaseMessaging.onBackgroundMessage(FirebaseService.fcmBackgroundHandler);
  //
  // // 포그라운드 핸들러
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('[FCM - Foreground] MESSAGE.notification.title : ${message.notification?.title}');
    print('[FCM - Foreground] MESSAGE.notification.body : ${message.notification?.body}');
    firebaseService.fcmForegroundHandler(
        message, localNotification, androidNotificationChannel);
  });
  // ▲ firebase

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TossPaymentProvider()),
        ChangeNotifierProvider<LoadingProvider>(
          create: (_) {
            final notifier = LoadingProvider();
            LoadingService.notifier = notifier;
            return notifier;
          },
        ),
      ],
      child: const PackUp(),
    ),
  );
}


class PackUp extends StatelessWidget {
  const PackUp({Key? key}) : super(key: key);

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.light,
  );

  // 초기 라우트 체크 (login OR index)
  static String initialRoute = '/login';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: PackUp.themeNotifier,
      builder: (context, value, child) {
        return MaterialApp.router(
          title: 'PackUP Demo',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: value,
          routerConfig: router,
          supportedLocales: const [
            Locale('en', ''), // 영어
            Locale('ko', ''), // 한국어
            Locale('ja', ''), // 일본어
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale == null) {
              return const Locale('en');
            }

            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }

            return const Locale('en');
          },
          localizationsDelegates: const [
            AppLocalizations.delegate, // 코드 추가
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            FlutterQuillLocalizations.delegate,
          ],
          builder: (context, child) {
            return LoadingProgress(child: child!);
          },
        );
      },
    );
  }
}
