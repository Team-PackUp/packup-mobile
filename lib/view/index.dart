import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:packup/const/packup_icons.dart';
import 'package:packup/view/chat/chat_room.dart';
import 'package:packup/view/home/home.dart';
import 'package:packup/view/profile/profile_index.dart';
import 'package:packup/view/tour/user/tour.dart';

import '../common/deep_link/handle_router.dart';
import 'ai_recommend/ai_recommend.dart';

class Index extends StatefulWidget {
  final int? index;
  final int? myPageIndex;

  const Index({super.key, this.index, this.myPageIndex});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _currentIndex = 0;
  late int _myPageIndex;
  List<int> _history = [0];

  final Map<int, Map<String, dynamic>?> _tabPayloads = {};

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      _currentIndex = widget.index!;
    }
    if (widget.myPageIndex != null) {
      _myPageIndex = widget.myPageIndex!;
    }

    DeepLinkRouter.registerNavigator((int index, {payload}) {
      setState(() {
        _currentIndex = index;
        _tabPayloads[index] = payload;
      });
    });
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
    final payload = _tabPayloads[index];

    switch (index) {
      case 0:
        return const AIRecommend();
      case 1:
        return const Home();
      case 2:
        return const Tour(); // 나중에 이름 Home 으로 바꾸는게 직관적
      case 3:
        final chatRoomId = payload?['chatRoomId'];
        return ChatRoom(chatRoomId: chatRoomId);
      case 4:
        return const ProfileIndex();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final barRadius = 25.0;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: buildPage(_currentIndex),
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
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              items: List.generate(
                bottomNavItems.length,
                    (index) => BottomNavigationBarItem(
                  icon: SizedBox(
                    height: MediaQuery.of(context).size.height * .022,
                    child: Icon(bottomNavItems[index]['icon']),
                  ),
                  label: bottomNavItems[index]['label'],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
