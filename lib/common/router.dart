import 'package:go_router/go_router.dart';
import 'package:packup/view/chat/chat_message.dart';
import 'package:packup/view/chat/chat_room.dart';
import 'package:packup/view/home/home.dart';
import 'package:get/get.dart';
import 'package:packup/view/login/login.dart';
import 'package:packup/view/index.dart';
import 'package:packup/view/notice/notice_list.dart';
import 'package:packup/view/notice/notice_view.dart';
import 'package:packup/view/payment/toss/toss_result_screen.dart';
import 'package:packup/view/user/preference/preference.dart';
import 'package:path/path.dart';

/// 라우트 사용
/// push => 라우트를 쌓아올려서 뒤로가기 하면 이전 스크린으로 이동
/// go => 뒤로 가면 루트로 이동
// ElevatedButton(
//   onPressed: () {
//     context.go('/use_basic');
//   },
//   child: const Text('Go Basic'),
// ),
// ElevatedButton(
//   onPressed: () {
//     context.goNamed('use_named_screen');
//   },
//   child: const Text('Go Named'),
// ),
// ElevatedButton(
//   onPressed: () {
//     context.push('/use_push');
//   },
//   child: const Text('Go Push'),
// ),

final router = GoRouter(
  navigatorKey: Get.key,
  routes: [
    GoRoute(
      path: '/preference',
      builder: (context, state) => const Preference(),
    ),
    GoRoute(
        path: '/',
        builder: (context, state) => const Login()
        // builder: (context, state) => const Preference(),
    ),
    GoRoute(
        path: '/index',
        builder: (context, state) => const Index()
    ),
    GoRoute(
        path: '/home',
        builder: (context, state) => const Home()
    ),
    GoRoute(
        path: '/chat_room',
        builder: (context, state) => const ChatRoom()
    ),
    GoRoute(
      path: '/chat_message/:chatRoomSeq/:userSeq',
      builder: (context, state) {
        final chatRoomSeq = int.parse(state.pathParameters['chatRoomSeq']!);
        final userSeq = int.parse(state.pathParameters['userSeq']!);
        return ChatMessage(chatRoomSeq: chatRoomSeq, userSeq: userSeq,);
      },
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) => const TossResultScreen(),
    ),
    GoRoute(
      path: '/notice_list',
      builder: (context, state) => const NoticeList(),
    ),
    GoRoute(
        path: '/notice_view/:noticeSeq',
        builder: (context, state) {
        final noticeSeq = int.parse(state.pathParameters['noticeSeq']!);
        return NoticeView(noticeSeq: noticeSeq);
      }
    ),
  ],
);
