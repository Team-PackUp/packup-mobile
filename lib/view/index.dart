import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:packup/const/packup_icons.dart';
import 'package:packup/view/chat/chat_room.dart';
import 'package:packup/view/home/home.dart';
import 'package:packup/view/profile/profile.dart';
import 'package:packup/view/schedule/schedule.dart';
import 'package:packup/view/tour/tour.dart';

class Index extends StatefulWidget {
  final int? index;
  final int? myPageIndex;

  const Index({
    super.key,
    this.index,
    this.myPageIndex,
  });

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _currentIndex = 0;
  late int _myPageIndex;
  List<int> _history = [0];

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      _currentIndex = widget.index!;
    }
    if (widget.myPageIndex != null) {
      _myPageIndex = widget.myPageIndex!;
    }
  }

  Future<bool> _onWillPop() async {
    if (_history.length > 1 && _currentIndex != 0) {
      _history.removeLast();
      setState(() {
        _currentIndex = _history.last;
      });
      return false;
    } else {
      if (_currentIndex == 0) {
        SystemNavigator.pop();
        return false;
      } else {
        setState(() {
          _currentIndex = 0;
        });
        return false;
      }
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_history.isEmpty || _history.last != index) {
        _history.add(index);
      }
    });
  }

  final List<Map<String, dynamic>> bottomNavItems = [
    {'icon': Icons.search_rounded, 'label': 'AI추천'},
    {'icon': PackupIcons.favorite, 'label': '예약'},
    {'icon': PackupIcons.group_1, 'label': '홈'},
    {'icon': PackupIcons.group, 'label': '메시지'},
    {'icon': Icons.account_circle_outlined, 'label': 'MY'},
  ];

  Widget buildPage(int index) {
    switch (index) {
      case 0:
        return const Schedule(); // AI추천
      case 1:
        return const Home(); // 예약
      case 2:
        return Tour(); // 홈
      case 3:
        return const ChatRoom(deepLinkFlag: false,); // 메시지
      case 4:
        return const Profile(); // MY
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 10,
        ),
        body: buildPage(_currentIndex), // ✅ 동적 위젯 생성
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          items: List.generate(
            bottomNavItems.length,
                (index) => BottomNavigationBarItem(
              icon: SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
                child: Icon(bottomNavItems[index]['icon']),
              ),
              label: bottomNavItems[index]['label'],
            ),
          ),
        ),
      ),
    );
  }
}
