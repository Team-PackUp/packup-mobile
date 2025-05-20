import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill/quill_delta.dart';
import 'package:packup/provider/notice/notice_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../service/common/quill_view_service.dart';

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
  QuillController? _quillController;

  @override
  void initState() {
    super.initState();
    noticeProvider = context.read<NoticeProvider>();
    noticeProvider.getNoticeView(widget.noticeSeq).then((_) {
      final notice = noticeProvider.noticeModel;

      if (notice.content != null) {
        QuillViewService().quillInitiate(notice.content!);
        _quillController = QuillViewService().quillController;
      }

    });
  }

  @override
  void dispose() {
    _quillController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    noticeProvider = context.watch<NoticeProvider>();
    final notice = noticeProvider.noticeModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(notice.title!),
      ),
      body: QuillEditor.basic(
          controller: _quillController!,
        ),
    );
  }
}
