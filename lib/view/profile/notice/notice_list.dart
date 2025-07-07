import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../../../provider/profile/notice/notice_provider.dart';
import '../../../widget/profile/notice/notice_card.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoticeList extends StatelessWidget {
  const NoticeList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoticeProvider(),
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
  late NoticeProvider _noticeProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _noticeProvider = context.read<NoticeProvider>();
      await _noticeProvider.getNoticeList();
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
    _noticeProvider.getNoticeList();
  }

  @override
  Widget build(BuildContext context) {

    _noticeProvider = context.watch<NoticeProvider>();

    var filteredNoticeList = _noticeProvider.noticeList;

    return Scaffold(
      appBar: CustomAppbar(title: AppLocalizations.of(context)!.notice),
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
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.01,
                      vertical: MediaQuery.of(context).size.height * 0.002,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: NoticeCard(
                              index: index,
                              title: notice.title!,
                              createdAt: notice.createdAt!,
                            ),
                          ),
                        ],
                      ),
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
}
