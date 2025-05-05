import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redis/redis.dart';

import '../../provider/chat/chat_provider.dart';

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
  final _connection = RedisConnection();
  late Command command;
  late StreamSubscription _subscription;
  late Stream stream;
  late PubSub pubsub;
  late String subscribe;

  ChatProvider chatProvider = ChatProvider();

  // Redis 채널 구독
  subscribeToChatRooms(String subscribe) async {

    this.subscribe = subscribe;
    print("레디스 연결");

    command = await _connection.connect(redisUrl, int.parse(redisPort!));

    pubsub = PubSub(command);

    // Redis 채널 구독 활성화
    pubsub.subscribe([subscribe]);

    stream = pubsub.getStream();
    _subscription = stream.listen((message) {
      final messageType = message[0];
      if (messageType == 'message') {
        final channel = message[1];
        final payload = message[2];
        print("메시지 수신: $payload");
        updateChatRoomList(payload);
      } else {
        print("REDIS 구독 성공");
      }
    });
  }

  // 채팅방 리스트 갱신
  void updateChatRoomList(payload) {

    print("메시지 수신2: $payload");
    final int chatRoomSeq = payload['chatRoomSeq'];
    final int chatMessage = payload['chatMessage'];

    // 채팅방 목록에서 seq만 추출
    final chatRoomSeqSet = chatProvider.chatRoom.map((room) => room.seq).toSet();

    // 내가 참여한 방인지 체크
    if (chatRoomSeqSet.contains(chatRoomSeq)) {
      print("내 채팅방 메시지: $chatMessage");
      chatProvider.getRoom();
    } else {
      print("내 채팅방 아님, 무시");
    }
  }

  // Redis 연결 해제
  Future<void> disconnect() async {
    print("해제");
    try {
      // 스트림 리스너 취소
      // await _subscription?.cancel();
      // _subscription = null;

      // Redis 연결 종료
      // await _connection.close();
      command.get_connection().close();
    } catch (e) {
      print("Redis disconnect 에러: $e");
    }
  }
}
