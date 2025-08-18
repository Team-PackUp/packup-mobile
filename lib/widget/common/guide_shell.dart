import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuideShell extends StatelessWidget {
  const GuideShell({super.key, required this.child});
  final Widget child;

  int _indexFrom(String loc) {
    if (loc.startsWith('/g/message')) return 1;
    if (loc.startsWith('/g/profile')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    final idx = _indexFrom(loc);
    final barRadius = 10.0;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(7, 0, 7, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(barRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(barRadius),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: idx,
            onTap: (i) {
              switch (i) {
                case 0:
                  context.go('/g'); // 리스팅
                  break;
                case 1:
                  context.go('/g/message'); // 메시지
                  break;
                case 2:
                  context.go('/g/profile'); // 마이페이지
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined),
                label: '리스팅',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                label: '메시지',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: '마이',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
