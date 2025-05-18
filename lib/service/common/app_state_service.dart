import 'package:flutter/widgets.dart';
import 'package:packup/Common/util.dart';
import 'package:packup/service/common/socket_service.dart';

class AppStateService with WidgetsBindingObserver {

  static final AppStateService _instance = AppStateService._internal();

  factory AppStateService() => _instance;

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
  }

  // 상태별 앱 처리
  void handleAppState() {
    logger("상태가 변경 되어 서비스 로직 실행");
    switch (_state) {
      case AppLifecycleState.paused:
        SocketService().disconnect();
        break;

      case AppLifecycleState.resumed:
        SocketService().initConnect();
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }
}
