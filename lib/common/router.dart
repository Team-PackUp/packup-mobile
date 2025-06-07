import 'package:go_router/go_router.dart';
import 'package:packup/provider/user/user_provider.dart';
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
import 'package:packup/view/user/register_detail/register_detail.dart';
import 'package:path/path.dart';

GoRouter createRouter(UserProvider userProvider) {
  return GoRouter(
    navigatorKey: Get.key,
    initialLocation: '/',
    refreshListenable: userProvider,
    redirect: (context, state) {
      final isInitialized = userProvider.isInitialized;
      final accessToken = userProvider.accessToken;
      final hasToken = accessToken != null && accessToken.isNotEmpty;
      final hasDetail = userProvider.hasDetailInfo;

      final currentLoc = state.fullPath!;

      if (!isInitialized) return null;

      // 보호된 페이지 모두 나열 - 추가 시 반영 필요.
      final isProtected = [
        '/index',
        '/home',
        '/chat_room',
        '/notice_list',
        '/notice_view',
        '/chat_message',
        '/preference',
      ].any((path) => currentLoc.startsWith(path));

      if (!hasToken && isProtected) {
        return '/';
      }

      print('프린트할게요');
      print('userAge: ${userProvider.userModel?.userAge}');
      print('userNation: ${userProvider.userModel?.userNation}');
      print('userGender: ${userProvider.userModel?.userGender}');
      print('nickname: ${userProvider.userModel?.nickname}');
      print('isDetailRegistered: ${userProvider.hasDetailInfo}');

      if (hasToken && !hasDetail && currentLoc != '/register-detail') {
        return '/register-detail';
      }

      if (hasToken && hasDetail && currentLoc == '/') {
        return '/index';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const Login()),
      GoRoute(path: '/index', builder: (context, state) => const Index()),
      GoRoute(path: '/home', builder: (context, state) => const Home()),
      GoRoute(
        path: '/chat_room',
        builder: (context, state) => const ChatRoom(),
      ),
      GoRoute(
        path: '/chat_message/:chatRoomSeq/:userSeq',
        builder: (context, state) {
          final chatRoomSeq = int.parse(state.pathParameters['chatRoomSeq']!);
          final userSeq = int.parse(state.pathParameters['userSeq']!);
          return ChatMessage(chatRoomSeq: chatRoomSeq, userSeq: userSeq);
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
        },
      ),
      GoRoute(
        path: '/preference',
        builder: (context, state) => const Preference(),
      ),
      GoRoute(
        path: '/register-detail',
        builder: (context, state) => const RegisterDetail(),
      ),
    ],
  );
}
