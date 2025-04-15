import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'l10n/app_localizations.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:packup/common/router.dart';
import 'package:provider/provider.dart';

import 'package:packup/theme/theme.dart';

import 'package:packup/view/login/login_view_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 환경 변수 파일 로드
  await dotenv.load();

  // 초기 테마 세팅
  String defaultTheme = await getDefaultTheme();
  PackUp.themeNotifier.value = defaultTheme == "light" ? ThemeMode.light : ThemeMode.dark;

  // 카카오 로그인 초기화
  String KAKAO_NATIVE_APP_KEY = dotenv.env['KAKAO_NATIVE_APP_KEY']!;
  String JAVASCRIPT_APP_KEY = dotenv.env['JAVASCRIPT_APP_KEY']!;

  KakaoSdk.init(
    nativeAppKey: KAKAO_NATIVE_APP_KEY,
    javaScriptAppKey: JAVASCRIPT_APP_KEY,
  );

  // if(loginFlag == true) {
  //   PackUp.initialRoute = '/index';
  // }

  runApp(
    // 모든 페이지에서 사용할 모델 등록
    ChangeNotifierProvider(
      create: (context) => UserViewModel(),
      child: const PackUp(),
  ),);
}


class PackUp extends StatelessWidget {
  const PackUp({Key? key}) : super(key: key);

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

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
          ],
            localizationsDelegates: const [
              AppLocalizations.delegate, // 코드 추가
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FlutterQuillLocalizations.delegate,
            ],
        );
      },
    );
  }
}