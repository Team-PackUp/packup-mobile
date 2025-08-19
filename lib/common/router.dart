import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/model/common/app_mode.dart';
import 'package:packup/model/reply/reply_model.dart';
import 'package:packup/model/user/user_withdraw_log/user_withdraw_log_model.dart';
import 'package:packup/provider/user/user_provider.dart';
import 'package:packup/view/ai_recommend/ai_recommend.dart';
import 'package:packup/view/chat/chat_message.dart';
import 'package:packup/view/chat/chat_room.dart';
import 'package:packup/view/guide/detail/guide_detail.dart';
import 'package:get/get.dart';
import 'package:packup/view/login/login.dart';
import 'package:packup/view/index.dart';
import 'package:packup/view/menu/guide_menu.dart';
import 'package:packup/view/payment/toss/toss_result_screen.dart';
import 'package:packup/view/profile/profile_index.dart';
import 'package:packup/view/profile/profile_modify/profile_modify.dart';
import 'package:packup/view/profile/setting_account/reservation_manage/reservation_manage.dart';
import 'package:packup/view/profile/setting_account/setting/setting_index.dart';
import 'package:packup/view/profile/setting_account/setting/setting_language.dart';
import 'package:packup/view/profile/setting_account/setting/setting_nation.dart';
import 'package:packup/view/profile/setting_account/setting/setting_withdraw.dart';
import 'package:packup/view/profile/setting_account/setting/setting_withdraw_confirm.dart';
import 'package:packup/view/reply/reply_write.dart';
import 'package:packup/view/search/search.dart';
import 'package:packup/view/tour/user/tour_detail.dart';
import 'package:packup/view/user/preference/preference.dart';
import 'package:packup/view/user/register_detail/register_detail.dart';
import 'package:packup/widget/common/custom_error.dart';
import 'package:packup/view/guide/application/guide_application_submit.dart';
import 'package:packup/provider/common/app_mode_provider.dart';
import 'package:packup/widget/common/guide_shell.dart';

import '../provider/search/search_provider.dart';
import '../view/ai_recommend/detail/ai_recommend_detail.dart';
import '../view/alert_center/alert_center_list.dart';
import '../view/profile/setting_account/notice/notice_list.dart';
import '../view/profile/setting_account/notice/notice_view.dart';
import '../view/reply/reply_list.dart';
import '../view/home/home.dart';

GoRouter createRouter(AppModeProvider appMode, UserProvider userProvider) {
  return GoRouter(
    navigatorKey: Get.key,
    initialLocation: '/',
    refreshListenable: Listenable.merge([appMode, userProvider]),
    redirect: (context, state) {
      final isInitialized = userProvider.isInitialized;
      final accessToken = userProvider.accessToken;
      final hasToken = accessToken != null && accessToken.isNotEmpty;
      final hasDetail = userProvider.hasDetailInfo;
      final isLoading = userProvider.isLoading;

      final currentLoc = state.fullPath!;
      final current = state.fullPath ?? '/';

      final loc = state.uri.toString();

      final isGuideShell = loc == '/g' || loc.startsWith('/g/');

      if (appMode.mode == AppMode.guide && !isGuideShell) {
        if (loc == '/' || loc == '/index' || loc == '/home') {
          return '/g';
        }
      }
      if (appMode.mode == AppMode.user && isGuideShell) {
        return '/index';
      }

      // 회원 인증이 되어있는지 체크하려면 이게 빠져야..??
      // if (!isInitialized) return null;

      // 보호된 페이지 모두 나열 - 추가 시 반영 필요.
      final isProtected = [
        '/index',
        '/home',
        '/chat_room',
        '/notice_list',
        '/notice_view',
        '/chat_message',
        '/preference',
        '/guide/application/submit',
        '/g',
        '/g/todo',
        '/g/schedule',
        '/g/listing',
        '/g/chat',
        '/g/menu',
      ].any((path) => currentLoc.startsWith(path));

      if (!hasToken && isProtected) {
        return '/';
      }

      print('프린트할게요');
      print('userAge: ${userProvider.userModel?.userBirth}');
      print('userNation: ${userProvider.userModel?.userNation}');
      print('userGender: ${userProvider.userModel?.userGender}');
      print('nickname: ${userProvider.userModel?.nickname}');
      print('isDetailRegistered: ${userProvider.hasDetailInfo}');
      print('isLoading: ${userProvider.isLoading}');

      if (hasToken &&
          !hasDetail &&
          currentLoc != '/register-detail' &&
          !isLoading) {
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
          final TargetType targetType = TargetType.values.firstWhere(
            (e) => e.code == param,
          );

          return ReplyList(targetSeq: targetSeq, targetType: targetType);
        },
      ),
      GoRoute(
        path: '/reply_write/:targetSeq/:targetType',
        builder: (context, state) {
          final targetSeq = int.parse(state.pathParameters['targetSeq']!);
          final String param = state.pathParameters['targetType']!;
          final TargetType targetType = TargetType.values.firstWhere(
            (e) => e.code == param,
          );

          return ReplyWrite(targetSeq: targetSeq, targetType: targetType);
        },
      ),
      GoRoute(
        // 댓글 수정
        path: '/reply_write/:seq',
        builder: (context, state) {
          final seq = int.parse(state.pathParameters['seq']!);

          return ReplyWrite(seq: seq);
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
      GoRoute(
        path: '/tour/:id',
        name: 'tourDetail',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return const TourDetailPage();
        },
      ),
      GoRoute(
        path: '/reservation/list',
        name: 'reservationList',
        builder: (context, state) {
          return ReservationManage();
        },
      ),
      GoRoute(
        path: '/guide/application/submit',
        name: 'guideApplicationSubmit',
        builder: (context, state) => const GuideApplicationSubmitPage(),
      ),
      GoRoute(
        path: '/guide/:guideId',
        name: 'guideDetail',
        builder: (context, state) {
          final guideId = int.parse(state.pathParameters['guideId']!);
          return GuideDetailPage(guideId: guideId);
        },
      ),
      GoRoute(
        path: '/profile/profile_modify',
        name: 'profileModify',
        builder: (context, state) {
          return ProfileModify();
        },
      ),
      GoRoute(
        path: '/profile/setting_index',
        name: 'settingIndex',
        builder: (context, state) {
          return SettingIndex();
        },
      ),
      GoRoute(
        path: '/profile/setting-nation',
        name: 'settingNation',
        builder: (context, state) {
          return SettingNation();
        },
      ),
      GoRoute(
        path: '/profile/setting-language',
        name: 'settingLanguage',
        builder: (context, state) {
          return SettingLanguage();
        },
      ),
      GoRoute(
        path: '/profile/withdraw',
        name: 'withdraw',
        builder: (context, state) {
          return SettingWithdraw();
        },
      ),
      GoRoute(
        path: '/profile/withdraw-confirm',
        name: 'withdrawConfirm',
        builder: (context, state) {
          final userWithdrawModel = state.extra as UserWithDrawLogModel;
          return SettingWithdrawConfirm(
            userWithDrawLogModel: userWithdrawModel,
          );
        },
      ),
      GoRoute(
        path: '/error',
        name: 'error',
        builder: (context, state) {
          final msg =
              state.extra is String
                  ? state.extra as String
                  : '알 수 없는 오류가 발생했습니다.';
          return CustomError(message: msg);
        },
      ),

      // 가이드 전용 라우팅
      ShellRoute(
        builder: (context, state, child) => GuideShell(child: child),
        routes: [
          GoRoute(
            path: '/g/todo',
            builder: (context, state) => const AIRecommend(),
          ),
          GoRoute(path: '/g/schedule', builder: (context, state) => ChatRoom()),
          GoRoute(path: '/g/listing', builder: (context, state) => ChatRoom()),
          GoRoute(path: '/g/chat', builder: (context, state) => ChatRoom()),
          GoRoute(
            path: '/g/menu',
            builder: (context, state) => const GuideMenuPage(),
          ),
        ],
      ),
    ],
    // 라우트 에러 방지
    errorBuilder: (context, state) {
      Future.microtask(
        () => context.goNamed('error', extra: '유효하지 않은 경로 입니다.'),
      );
      return const SizedBox.shrink();
    },
  );
}
