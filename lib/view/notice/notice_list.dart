import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/notice/notice_provider.dart';
import 'package:provider/provider.dart';
import 'package:packup/widget/search_bar/custom_search_bar.dart';

import '../../common/util.dart';

class NoticeList extends StatelessWidget {
  const NoticeList({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoticeProvider()),
      ],
      child: const NoticeListContent(),
    );
  }
}

class NoticeListContent extends StatefulWidget {
  const NoticeListContent({super.key});

  @override
  _NoticeListContentState createState() => _NoticeListContentState();
}

class _NoticeListContentState extends State<NoticeListContent> {

  late ScrollController _scrollController;
  late NoticeProvider noticeProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      noticeProvider = context.read<NoticeProvider>();
      await noticeProvider.getNoticeList();
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _scrollController.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
      getNoticeListMore();
    }
  }

  getNoticeListMore() async {
    noticeProvider.getNoticeList();
  }

  @override
  Widget build(BuildContext context) {

    noticeProvider = context.watch<NoticeProvider>();

    var filteredNoticeList = noticeProvider.noticeList;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: filteredNoticeList.length,
              itemBuilder: (context, index) {
                final notice = filteredNoticeList[index];

                return InkWell(
                  onTap: () async {
                    context.push('/notice_view/${notice.seq!}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8.0,
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: listWithDate(
                      title: notice.title!,
                      date: notice.createdAt!,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget listWithDate({
    required String title,
    DateTime? date,
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
            Text(
              convertToYmd(date!),
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
