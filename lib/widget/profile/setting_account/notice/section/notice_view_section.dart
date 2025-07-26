import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/editor/editor.dart';
import 'package:packup/provider/profile/notice/notice_provider.dart';
import 'package:packup/common/util.dart';
import 'package:provider/provider.dart';

import '../../../../../provider/common/editor_provider.dart';

class NoticeViewSection extends StatelessWidget {
  const NoticeViewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    final notice = context.watch<NoticeProvider>().noticeModel;

    return Scaffold(
      appBar: CustomAppbar(title: notice.title ?? '공지사항'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(screenW * 0.05),
            child: Text(convertToYmd(notice.createdAt!)),
          ),
          Expanded(
            child: Editor(
              key: ValueKey(notice.content),
              content: notice.content ?? '',
              type: EditorType.view,
            ),
          ),
        ],
      ),
    );
  }
}
