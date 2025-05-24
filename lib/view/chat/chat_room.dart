import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/chat/chat_room_provider.dart';
import 'package:packup/provider/search_bar/custom_search_bar_provider.dart';
import 'package:packup/widget/search_bar/custom_search_bar.dart';
import 'package:packup/const/color.dart';
import 'package:packup/common/util.dart';
import 'package:packup/service/common/socket_service.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatRoomProvider()),
        ChangeNotifierProvider(create: (_) => SearchBarProvider()),
      ],
      child: const ChatRoomContent(),
    );
  }
}

class ChatRoomContent extends StatefulWidget {
  const ChatRoomContent({super.key});

  @override
  State<ChatRoomContent> createState() => _ChatRoomContentState();
}

class _ChatRoomContentState extends State<ChatRoomContent> {
  final _socketService = SocketService();
  final ScrollController _scrollController = ScrollController();
  late ChatRoomProvider _chatRoomProvider;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _chatRoomProvider = context.read<ChatRoomProvider>();
      await _chatRoomProvider.getRoom();

      _chatRoomProvider.subscribeChatRoom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _chatRoomProvider.unSubscribeChatRoom();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<ChatRoomProvider>().getRoom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatRoomProvider = context.watch<ChatRoomProvider>();
    final searchProvider = context.watch<SearchBarProvider>();

    final chatRooms = chatRoomProvider.chatRoom.where((room) {
      final search = searchProvider.searchText;
      return search.isEmpty || room.seq.toString().contains(search);
    }).toList();

    return Scaffold(
      appBar: AppBar(toolbarHeight: 10),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: CustomSearchBar(),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                final room = chatRooms[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: InkWell(
                    onTap: () async {
                      final userSeq = await decodeTokenInfo();
                      context.push('/chat_message/${room.seq}/$userSeq');
                    },
                    child: ChatRoomCard(title: room.seq.toString()),
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
        onPressed: () => Navigator.pushNamed(context, "/friend"),
        child: Icon(Icons.add, color: TEXT_COLOR_W),
      ),
    );
  }
}

class ChatRoomCard extends StatelessWidget {
  final String title;

  const ChatRoomCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
