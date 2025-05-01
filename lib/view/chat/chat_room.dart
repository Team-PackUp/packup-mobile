import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/chat/chat_provider.dart';
import 'package:packup/provider/search_bar/custom_search_bar_provider.dart';
import 'package:provider/provider.dart';
import 'package:packup/widget/search_bar/custom_search_bar.dart';
import 'package:packup/const/color.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => SearchBarProvider()),
      ],
      child: const ChatRoomContent(),
    );
  }
}

class ChatRoomContent extends StatefulWidget {
  const ChatRoomContent({super.key});

  @override
  _ChatRoomContentState createState() => _ChatRoomContentState();
}

class _ChatRoomContentState extends State<ChatRoomContent> {
  late ScrollController _scrollController;
  late int page = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().getRoom();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
      // 스크롤이 끝에 도달했을 때의 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatProvider, SearchBarProvider>(
      builder: (context, chatProvider, searchProvider, child) {
        var filteredChatRooms = chatProvider.chatRoom;

        // 검색 필터
        if (searchProvider.searchText.isNotEmpty) {
          filteredChatRooms = filteredChatRooms.where((room) {
            return room.seq.toString().contains(searchProvider.searchText);
          }).toList();
        }

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 10,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: const CustomSearchBar(),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: filteredChatRooms.length,
                  itemBuilder: (context, index) {
                    final room = filteredChatRooms[index];

                    return InkWell(
                      onTap: () {
                        context.push('/chat_message/${room.seq}');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: _buildCard(
                          title: room.seq.toString(),
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
              style: const TextStyle(
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
