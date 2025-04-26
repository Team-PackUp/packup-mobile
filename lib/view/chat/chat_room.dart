import 'package:flutter/material.dart';
import 'package:packup/provider/chat/chat_provider.dart';
import 'package:packup/widget/search/custom_search_view_model.dart';
import 'package:provider/provider.dart';

import 'package:packup/const/color.dart';
import 'package:packup/widget/search/custom_search_bar.dart';
import 'message.dart';

class ChatRoom extends StatefulWidget {

  const ChatRoom({super.key});

  @override
  _ChatRoom createState() => _ChatRoom();
}

class _ChatRoom extends State<ChatRoom> {
  late ScrollController _scrollController;
  late int page = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    // 최초 데이터 조회
    Provider.of<ChatProvider>(context, listen: false).getRoom();
  }

  _scrollListener() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      // 추가 데이터 조회
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomSearchViewModel(),
      child: Consumer<CustomSearchViewModel>(
        builder: (context, searchViewModel, child) {
          final chatViewModel = context.watch<ChatProvider>();
          var filteredChatRooms = chatViewModel.getRoom();

          // 방 리스트 검색 필터링
          if (searchViewModel.searchText.isNotEmpty) {
            filteredChatRooms = filteredChatRooms.where((room) {
              return room["chatRoomId"]
                  .toString()
                  .contains(searchViewModel.searchText);
            }).toList();
          }

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 10,
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: CustomSearchBar(),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: filteredChatRooms.length,
                    itemBuilder: (context, index) {
                      final room = filteredChatRooms[index];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Message(chatRoomId: room["chatRoomId"]),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: _buildCard(
                            title: room["chatRoomId"].toString(),
                            content: 1,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: "member",
              backgroundColor: PRIMARY_COLOR,
              onPressed: () {
                Navigator.pushNamed(context, "/friend");
              },
              child: Icon(Icons.add, color: TEXT_COLOR_W),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({
    required String title,
    int? content,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
