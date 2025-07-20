import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/profile/notice/notice_provider.dart';
import '../../../../widget/profile/setting_account/notice/section/notice_view_section.dart';

class NoticeView extends StatelessWidget {
  final int noticeSeq;

  const NoticeView({
    super.key,
    required this.noticeSeq
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoticeProvider(),
      child: NoticeViewContent(noticeSeq: noticeSeq),
    );
  }
}

class NoticeViewContent extends StatefulWidget {
  final int noticeSeq;

  const NoticeViewContent({super.key, required this.noticeSeq});

  @override
  State<NoticeViewContent> createState() => _NoticeViewContentState();
}

class _NoticeViewContentState extends State<NoticeViewContent> {
  late NoticeProvider _noticeProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _noticeProvider = context.read<NoticeProvider>();
      await _noticeProvider.getNoticeView(widget.noticeSeq);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const NoticeViewSection();
  }
}
