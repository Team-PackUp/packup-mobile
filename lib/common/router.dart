import 'package:go_router/go_router.dart';
import 'package:packup/view/home/home.dart';
import 'package:packup/view/login/login.dart';
import 'package:packup/view/index.dart';

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
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => const Login()
    ),
    GoRoute(
        path: '/index',
        builder: (context, state) => const Index()
    ),
    GoRoute(
        path: '/home',
        builder: (context, state) => const Home()
    ),
  ],
);
