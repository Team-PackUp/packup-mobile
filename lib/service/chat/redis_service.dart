import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redis/redis.dart';

class RedisService {

  static final RedisService _instance = RedisService._internal();

  // 객체 생성 방지
  RedisService._internal();

  // 싱글톤 보장용 > 팩토리 생성자 > 실제로 객체 생성 없이 상황에 맞는 객체 반환
  factory RedisService() {
    return _instance;
  }

  final redisUrl = dotenv.env["REDIS_URL"];
  final redisPort = dotenv.env["REDIS_PORT"];
  final RedisConnection _connection = RedisConnection();
  late Command command;
  StreamSubscription? _subscription;

  // Redis 채널 구독
  Future<void> subscribeToChatRooms() async {
    print("레디스 연결");
    command = await _connection.connect(redisUrl, int.parse(redisPort!));

    final pubsub = PubSub(command);
    pubsub.subscribe(["chat_rooms"]);
    final stream = pubsub.getStream();
    print(stream);

    _subscription = stream.listen((message) {
      print("메시지 수신됨: $message");
      updateChatRoomList(message);
    });
  }

  // 채팅방 리스트 갱신
  void updateChatRoomList(message) {
    // 메시지에 따라 채팅방 리스트를 갱신하는 로직
    print("새로운 채팅방 메시지: $message");
    // 예: UI 갱신
  }

  void disconnect() {
    // 먼저 스트림 리스너 해제
    _subscription?.cancel();
    // Redis 연결 닫기
    _connection.close();
  }
}