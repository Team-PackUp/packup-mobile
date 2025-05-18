import 'package:flutter/material.dart';
import 'package:packup/provider/notice/noticet.dart';
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
      child: NoticeView(noticeSeq: noticeSeq,),
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
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    noticeProvider = context.watch<NoticeProvider>();

    final notice = noticeProvider.notice;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
      ),
      body: Column(
        children: [
          Expanded(
            child: Text(
                notice.title!
            ),
          ),
          Expanded(
            child: Text(
                notice.content!
            ),
          ),
        ],
      ),
    );
  }
}
