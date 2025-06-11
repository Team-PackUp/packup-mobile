import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:go_router/go_router.dart';

import 'package:packup/common/util.dart';
import 'package:packup/const/const.dart';
import 'package:packup/provider/chat/chat_message_provider.dart';
import 'package:packup/provider/chat/chat_room_provider.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  final String socketPrefix = dotenv.env['SOCKET_URL']!;
  late ChatMessageProvider chatMessageProvider;
  late ChatRoomProvider chatRoomProvider;
  StompClient? stompClient;

  bool isConnecting = true;
  bool isReconnecting = false; // 재연결 시도 상태 여부
  bool forceDisconnect = false; // 강제로 소켓 해제

  Future<void> initConnect() async {
    if (stompClient != null) {
      // 정상적으로 소캣이 deactive 되지 않고 서버가 꺼지면서 비 정상적으로 종료된 경우 > isActive로 인지할 수 있음
      if (stompClient!.isActive) {
        print("이미 소켓이 연결 되어 있음.");
        return;
      } else {
        print("기존 소켓 비활성화 처리");
        stompClient?.deactivate();
        stompClient = null;
      }
    }

    print("소켓을 연결합니다.");
    await initStompClient();
    if (stompClient != null) {
      stompClient!.activate();
    } else {
      print("stompClient 초기화 실패");
    }
  }

  Future<void> initStompClient() async {
    String? token = await getToken(ACCESS_TOKEN);
    String? refreshToken = await getToken(REFRESH_TOKEN);

    if (token == null || tokenExpired(token)) {
      if (refreshToken != null) {
        try {
          final dio = Dio();
          final res = await dio.post(
            '${dotenv.env['HTTP_URL']!}/auth/refresh',
            data: {'refreshToken': refreshToken},
          );

          final newAccessToken = res.data['response']['accessToken'];
          await saveToken(ACCESS_TOKEN, newAccessToken);
          token = newAccessToken;
        } on DioException catch (e) {
          await deleteToken(ACCESS_TOKEN);
          await deleteToken(REFRESH_TOKEN);

          Get.key.currentContext?.go('/login');
          return;
        }
      }
    }

    stompClient = StompClient(
      config: StompConfig(
        url: socketPrefix,
        onConnect: onConnect,
        onDisconnect: onDisconnect,
        beforeConnect: () async {
          await Future.delayed(const Duration(milliseconds: 200));
        },
        onWebSocketError: (dynamic error) {
          logger(error.toString(), 'ERROR');
          reconnect();
        },
        onStompError: (frame) {
          print('[SocketService] STOMP 에러: ${frame.body}');
          reconnect();
        },
        stompConnectHeaders: {'Authorization': "Bearer $token"},
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  void onConnect(StompFrame frame) {
    print("소켓 연결 완료.");
    forceDisconnect = false; // 연결 성공 시 강제 종료 해제

    // 재구독
    reSubscribe();

    // 연결 유지용 ping
    Timer.periodic(const Duration(seconds: 50), (_) {
      try {
        if (stompClient != null && stompClient!.isActive) {
          stompClient!.send(
            destination: '/pub/send.connection',
            body: 'keep connection',
          );
        }
      } catch (e, stackTrace) {
        print('ping 전송 중 예외: $e');
        reconnect();
      }
    });
  }

  /// 메시지 전송
  void sendMessage(destination, dynamic model) {
    stompClient!.send(
      destination: '/pub/$destination',
      body: model.toJson(),
      headers: {'content-type': 'application/json'},
    );
  }

  /// 전체 연결 해제
  void disconnect() {
    print("소켓 연결 완전 종료");

    // 모든 구독 해제
    for (var unsubscribe in _unsubscribeMap.values) {
      unsubscribe();
    }
    _unsubscribeMap.clear();
    // _subscriptions.clear();

    stompClient?.deactivate();
    forceDisconnect = true;
  }

  void onDisconnect(StompFrame frame) {
    print("소켓 연결 해제됨.");

    if (!forceDisconnect) {
      reconnect();
    }
  }

  void reconnect() {
    isConnecting = false;
    stompClient?.deactivate();

    if (forceDisconnect) {
      print("강제 종료 상태, 재연결하지 않음.");
      return;
    }

    if (isConnecting) {
      print("이미 연결됨.");
      return;
    }

    if (isReconnecting) {
      print("이미 재연결 중... 중복 방지.");
      return;
    }

    isReconnecting = true;

    Future.delayed(const Duration(seconds: 5), () async {
      print("소켓 재연결 시도...");
      await initConnect();
      isReconnecting = false;
      isConnecting = true;
    });
  }

  void reSubscribe() {
    if (stompClient == null || !stompClient!.isActive) return;

    print("모든 경로 재구독 시작...");

    _subscriptions.forEach((destination, callback) {
      print("[$destination] 재구독 시도");
      subscribe(destination, callback);
    });
  }

  void registerCallback(
    String destination,
    void Function(dynamic data) callback,
  ) {
    _subscriptions[destination] = callback;
  }

  void unregisterCallback(String destination) {
    _subscriptions.remove(destination);
  }

  // 클래스 멤버
  final Map<String, void Function(dynamic data)> _subscriptions = {};
  final Map<String, StompUnsubscribe> _unsubscribeMap = {};

  void subscribe(String destination, void Function(dynamic data) callback) {
    // 1. stompClient 연결 상태 확인
    if (stompClient == null || !stompClient!.isActive) {
      print("소켓이 연결되지 않았습니다. 구독 실패: $destination");
      reSubscribe();
      return;
    }

    // 2. 기존에 구독된게 있으면 해제
    _unsubscribeMap[destination]?.call();

    // 3. 구독 리스트 저장
    _subscriptions[destination] = callback;

    // 4. 새 구독 등록
    final unsub = stompClient!.subscribe(
      destination: destination,
      callback: (frame) {
        if (frame.body != null && _subscriptions.containsKey(destination)) {
          try {
            final data = json.decode(frame.body!);
            _subscriptions[destination]!(data);
          } catch (e) {
            print("[$destination] 메시지 처리 오류: $e");
          }
        }
      },
    );

    // 5. 구독 해제 리스트 저장
    _unsubscribeMap[destination] = unsub;

    print("[$destination] 구독 완료");
  }

  void unsubscribe(String destination) {
    _unsubscribeMap[destination]?.call();
    _unsubscribeMap.remove(destination);
    _subscriptions.remove(destination);
    print("[$destination] 구독 해제 완료");
  }
}
