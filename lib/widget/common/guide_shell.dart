import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuideShell extends StatelessWidget {
  const GuideShell({super.key, required this.child});
  final Widget child;

  int _indexFrom(String loc) {
    if (loc.startsWith('/g/calendar')) return 1;
    if (loc.startsWith('/g/profile')) return 2;
    return 0; // /g
  }

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;

    final idx = _indexFrom(loc);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go('/g');
              break;
            case 1:
              context.go('/g/calendar');
              break;
            case 2:
              context.go('/g/profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            label: '투어',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            label: '스케줄',
          ),
          NavigationDestination(icon: Icon(Icons.person_outline), label: '마이'),
        ],
      ),
    );
  }
}
