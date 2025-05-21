import 'package:flutter/material.dart';
import 'package:packup/provider/notice/notice_provider.dart';
import 'package:packup/widget/editor/editor.dart';
import 'package:provider/provider.dart';

class NoticeView extends StatelessWidget {
  final int noticeSeq;

  const NoticeView({
    super.key,
    required this.noticeSeq
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoticeProvider()),
      ],
      child: NoticeViewContent(noticeSeq: noticeSeq),
    );
  }
}

class NoticeViewContent extends StatefulWidget {
  final int noticeSeq;

  const NoticeViewContent({
    super.key,
    required this.noticeSeq
  });

  @override
  NoticeViewContentState createState() => NoticeViewContentState();
}

class NoticeViewContentState extends State<NoticeViewContent> {
  late NoticeProvider noticeProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      noticeProvider = context.read<NoticeProvider>();
      await noticeProvider.getNoticeView(widget.noticeSeq);
    });
  }

  @override
  void dispose() {
    super.dispose();

    // noticeProvider.dispose();
  }

  @override
  Widget build(BuildContext context) {
    noticeProvider = context.watch<NoticeProvider>();
    final notice = noticeProvider.noticeModel;

    if (notice.title == null || notice.content == null || notice.content!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(notice.title!),
      ),
      body: Editor(content: notice.content!),
    );
  }
}
