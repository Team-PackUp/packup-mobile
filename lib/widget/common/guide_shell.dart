import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuideShell extends StatelessWidget {
  const GuideShell({super.key, required this.child});
  final Widget child;

  int _indexFrom(String loc) {
    if (loc.startsWith('/g/todo')) return 0;
    if (loc.startsWith('/g/schedule')) return 1;
    if (loc.startsWith('/g/listing')) return 2;
    if (loc.startsWith('/g/chat')) return 3;
    if (loc.startsWith('/g/menu')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    final idx = _indexFrom(loc);
    const barRadius = 10.0;

    const pink = Color(0xFFF06292);
    const gray = Color(0xFF9CA3AF);
    const labelSize = 11.0;

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
            backgroundColor: Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: idx,
            selectedItemColor: pink,
            unselectedItemColor: gray,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontSize: labelSize,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: labelSize),
            onTap: (i) {
              switch (i) {
                case 0:
                  context.go('/g/todo');
                  break;
                case 1:
                  context.go('/g/schedule');
                  break;
                case 2:
                  context.go('/g/listing');
                  break;
                case 3:
                  context.go('/g/chat');
                  break;
                case 4:
                  context.go('/g/menu');
                  break;
              }
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_border),
                activeIcon: Icon(Icons.bookmark),
                label: 'TO DO',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                activeIcon: Icon(Icons.calendar_today),
                label: '일정',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_outlined),
                activeIcon: Icon(Icons.inventory_2),
                label: '리스팅',
              ),
              BottomNavigationBarItem(
                icon: _DotIcon(base: Icons.chat_bubble_outline),
                activeIcon: _DotIcon(base: Icons.chat_bubble, isActive: true),
                label: '메시지',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: '메뉴',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 메시지 탭에 빨간 점만 찍는 아이콘
class _DotIcon extends StatelessWidget {
  const _DotIcon({required this.base, this.isActive = false});

  final IconData base;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFFF06292) : const Color(0xFF9CA3AF);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(base, color: color),
        Positioned(
          right: -1,
          top: -1,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
