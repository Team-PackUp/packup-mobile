import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:packup/common/router.dart';
import 'package:packup/provider/chat/chat_room_provider.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/provider/payment/toss/toss_payment_provider.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:packup/service/common/app_state_service.dart';
import 'package:packup/service/common/firebase_service.dart';
import 'package:packup/service/common/loading_service.dart';
import 'package:packup/service/common/socket_service.dart';
import 'package:packup/theme/colors/app_colors_dark.dart';
import 'package:packup/theme/colors/app_colors_light.dart';
import 'package:packup/theme/theme.dart';
import 'package:packup/widget/common/loading_progress.dart';
import 'package:provider/provider.dart';

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
  await FirebaseService().initConnect();
  // ▲ firebase

  final userProvider = UserProvider();
  await userProvider.initLoginStatus();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TossPaymentProvider()),
        ChangeNotifierProvider(create: (_) => ChatRoomProvider()),
        ChangeNotifierProvider<LoadingProvider>(
          create: (_) {
            final notifier = LoadingProvider();
            LoadingService.notifier = notifier;
            return notifier;
          },
        ),
      ],
      child: PackUp(router: createRouter(userProvider)),
    ),
  );

  // ▼ 앱 상태 변경 감지(최초 빌드시 실행 X)
  AppStateService();
  // ▲ 앱 상태 변경 감지
}


class PackUp extends StatelessWidget {
  final GoRouter router;
  const PackUp({Key? key, required this.router}) : super(key: key);

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
          theme: buildTheme(lightColors),
          darkTheme: buildTheme(darkColors),
          themeMode: value,
          routerConfig: router,
          supportedLocales: const [
            Locale('en', ''),
            Locale('ko', ''),
            Locale('ja', ''),
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale == null) return const Locale('en');
            return supportedLocales.firstWhere(
                  (l) => l.languageCode == locale.languageCode,
              orElse: () => const Locale('en'),
            );
          },
          localizationsDelegates: const [
            AppLocalizations.delegate,
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
