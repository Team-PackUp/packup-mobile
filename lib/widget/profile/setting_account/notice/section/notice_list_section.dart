import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/profile/notice/notice_provider.dart';

import '../../../../common/custom_empty_list.dart';
import '../notice_list_card.dart';

class NoticeListSection extends StatefulWidget {
  const NoticeListSection({super.key});

  @override
  State<NoticeListSection> createState() => _NoticeListSectionState();
}

class _NoticeListSectionState extends State<NoticeListSection> {
  late final ScrollController _scrollController;
  late NoticeProvider _noticeProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
      _noticeProvider.getNoticeList();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _noticeProvider = context.watch<NoticeProvider>();
    final noticeList = _noticeProvider.noticeList;

    if (noticeList.isEmpty && !_noticeProvider.isFetching) {
      return const CustomEmptyList(
        message: '공지사항이 존재하지 않습니다.',
        icon: Icons.notifications_none_outlined,
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: noticeList.length,
      itemBuilder: (context, index) {
        return NoticeListCard(
          index: index,
          notice: noticeList[index],
        );
      },
    );
  }
}
