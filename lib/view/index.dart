import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/view/chat/chat_room.dart';

import 'package:packup/view/home/home.dart';
import 'package:packup/view/profile/profile.dart';
import 'package:packup/view/schedule/schedule.dart';

import '../widget/editor/editor.dart';

class Index extends StatefulWidget {
  final int? index;
  final int? myPageIndex;

  const Index({
    super.key,
    this.index,
    this.myPageIndex,
  });

  @override
  State<StatefulWidget> createState() => _IndexState();
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
    {'icon': Icons.card_travel, 'label': 'AI추천'},
    {'icon': Icons.chat_bubble, 'label': '예약'},
    {'icon': Icons.home, 'label': '홈'},
    {'icon': Icons.airline_seat_recline_normal, 'label': '메시지'},
    {'icon': Icons.supervised_user_circle, 'label': 'MY'},
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 10,
        ),
        body: IndexedStack(
            index: _currentIndex,
            children: _pages
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: PRIMARY_COLOR,
          items: List.generate(
            bottomNavItems.length,
                (index) => BottomNavigationBarItem(
              icon: SizedBox(
                height: 10,
                child: Icon(bottomNavItems[index]['icon']),
              ),
              label: bottomNavItems[index]['label'],
            ),
          ),
        ),
      ),
    );
  }

  final List<Widget> _pages = [
    const Schedule(),
    const Home(),
    const Profile(),
    const ChatRoom(),
    const Profile(),
  ];


  // Widget _buildCurrentWidget() {
  //   switch (_currentIndex) {
  //     case 0:
  //       return const Schedule();
  //     case 1:
  //       return const ChatRoom();
  //       // return const SizedBox();
  //     case 2:
  //     return const Home();
  //     case 3:
  //       return const Profile();
  //     default:
  //       return Profile();
  //   }
  // }
}
