import 'package:go_router/go_router.dart';
import 'package:packup/model/reply/reply_model.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:packup/view/chat/chat_message.dart';
import 'package:packup/view/chat/chat_room.dart';
import 'package:packup/view/home/home.dart';
import 'package:get/get.dart';
import 'package:packup/view/login/login.dart';
import 'package:packup/view/index.dart';
import 'package:packup/view/payment/toss/toss_result_screen.dart';
import 'package:packup/view/reply/reply_write.dart';
import 'package:packup/view/search/search.dart';
import 'package:packup/view/user/preference/preference.dart';
import 'package:packup/view/user/register_detail/register_detail.dart';

import '../provider/search/search_provider.dart';
import '../view/ai_recommend/ai_recommend_detail.dart';
import '../view/alert_center/alert_center_list.dart';
import '../view/profile/contact_center/contact_center_index.dart';
import '../view/profile/notice/notice_list.dart';
import '../view/profile/notice/notice_view.dart';
import '../view/reply/reply_list.dart';

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
        builder: (context, state) {
          return ChatRoom();
        },
      ),

      GoRoute(
        path: '/chat_message/:chatRoomSeq/:title/:userSeq',
        builder: (context, state) {
          final chatRoomSeq = int.parse(state.pathParameters['chatRoomSeq']!);
          final title = state.pathParameters['title']!;
          final userSeq = int.parse(state.pathParameters['userSeq']!);

          return ChatMessage(
            chatRoomSeq: chatRoomSeq,
            title: title,
            userSeq: userSeq,
          );
        },
      ),
      GoRoute(
        path: '/result',
        builder: (context, state) => const TossResultScreen(),
      ),
      GoRoute(
        path: '/preference',
        builder: (context, state) => const Preference(),
      ),
      GoRoute(
        path: '/register-detail',
        builder: (context, state) => const RegisterDetail(),
      ),
      GoRoute(
        path: '/reply_list/:targetSeq/:targetType',
        builder: (context, state) {
          final targetSeq = int.parse(state.pathParameters['targetSeq']!);
          final String param = state.pathParameters['targetType']!;
          final TargetType targetType = TargetType.values
              .firstWhere((e) => e.code == param);

          return ReplyList(
            targetSeq: targetSeq,
            targetType: targetType,
          );
      }),
      GoRoute(
          path: '/reply_write/:targetSeq/:targetType',
          builder: (context, state) {
            final targetSeq = int.parse(state.pathParameters['targetSeq']!);
            final String param = state.pathParameters['targetType']!;
            final TargetType targetType = TargetType.values
                .firstWhere((e) => e.code == param);

            return ReplyWrite(
              targetSeq: targetSeq,
              targetType: targetType,
            );
          }),
      GoRoute( // 댓글 수정
        path: '/reply_write/:seq',
        builder: (context, state) {
          final seq = int.parse(state.pathParameters['seq']!);

          return ReplyWrite(
            seq: seq,
          );
        },
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
        path: '/alert_center',
        builder: (context, state) => AlertCenterListContent(),
      ),
      GoRoute(
        path: '/contact_center',
        builder: (context, state) => ContactCenterIndex(),
      ),
      GoRoute(
        path: '/ai_recommend_detail',
        builder: (context, state) => AiRecommendDetail(),
      ),
      GoRoute(
        path: '/search/:searchType',
        builder: (context, state) {
          final typeString = state.pathParameters['searchType']!;
          final searchType = SearchType.values.firstWhere(
                (e) => e.name == typeString,
            orElse: () => SearchType.all,
          );
          return Search(searchType: searchType);
        },
      ),
    ],
  );
}
