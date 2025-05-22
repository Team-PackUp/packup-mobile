import 'package:flutter/material.dart';
import 'package:packup/common/util.dart';
import 'package:packup/provider/notice/notice_provider.dart';
import 'package:packup/widget/editor/editor.dart';
import 'package:provider/provider.dart';

import '../../provider/common/editor_provider.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    noticeProvider = context.watch<NoticeProvider>();
    final notice = noticeProvider.noticeModel;

    // editor에 값이 세팅 되는데 딜레이가 있는 것으로 보임
    if (notice.title!.isEmpty || notice.content!.isEmpty) {
      return SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(notice.title!),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(convertToYmd(notice.createdAt!)),
          ),
          Expanded(
            child: Editor(
              content: notice.content!,
              type: EditorType.view,
            ),
          ),
        ],
      ),
    );
  }
}
