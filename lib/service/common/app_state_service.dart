import 'dart:async';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:packup/Common/util.dart';
import 'package:packup/const/const.dart';
import 'package:packup/service/common/socket_service.dart';

class AppStateService with WidgetsBindingObserver {
  static final AppStateService _instance = AppStateService._internal();

  factory AppStateService() => _instance;
  Timer? _refreshTokenTimer;

  AppStateService._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  // 현재 앱 상태 저장
  AppLifecycleState _state = AppLifecycleState.resumed;
  AppLifecycleState get state => _state;

  // 외부에서 상태 변경 감지 후 활용
  void Function(AppLifecycleState state)? onStateChanged;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _state = state;

    // 콜백 호출
    if (onStateChanged != null) {
      onStateChanged!(state);
    }

    handleAppState();
  }

  // 앱 종료 등 필요 시 호출 (보통 수동 호출)
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopTokenRefreshTimer();
  }

  // 상태별 앱 처리
  void handleAppState() {
    logger("상태가 변경 되어 서비스 로직 실행");
    switch (_state) {
      case AppLifecycleState.paused:
        SocketService().disconnect();
        stopTokenRefreshTimer();
        break;

      case AppLifecycleState.resumed:
        startTokenRefreshTimer();
        SocketService().initConnect();
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void startTokenRefreshTimer() {
    _refreshTokenTimer?.cancel();

    _refreshTokenTimer = Timer.periodic(Duration(minutes: 25), (timer) async {
      final refreshToken = await getToken(REFRESH_TOKEN);
      try {
        final dio = Dio();
        final res = await dio.post(
          '${dotenv.env['HTTP_URL']!}/auth/refresh',
          data: {'refreshToken': refreshToken},
        );
        final newAccessToken = res.data['response']['accessToken'];
        await saveToken(ACCESS_TOKEN, newAccessToken);

        print("accessToken 타이머 수행 → 소켓 재연결");
        SocketService().disconnect();
        await SocketService().initConnect();
      } catch (e) {
        print("accessToken 타이머 실패 → 로그아웃");
        await deleteToken(ACCESS_TOKEN);
        await deleteToken(REFRESH_TOKEN);
        Get.key.currentContext?.go('/login');
      }
    });
  }

  void stopTokenRefreshTimer() {
    _refreshTokenTimer?.cancel();
    _refreshTokenTimer = null;
    print("[AppStateService] accessToken 자동 갱신 타이머 중지");
  }
}
