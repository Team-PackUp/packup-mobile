import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/widget/profile/setting_account/notice/notice_card.dart';

import '../../../../model/profile/notice/notice_model.dart';
import '../../../common/util_widget.dart';

class NoticeCardList extends StatelessWidget {
  final List<NoticeModel> notices;
  final ScrollController scrollController;

  const NoticeCardList({
    super.key,
    required this.notices,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: notices.length,
      itemBuilder: (context, index) {
        final notice = notices[index];

        return InkWell(
          onTap: () {
            final seq = notice.seq ?? 0;
            if (seq == 0) {
              CustomSnackBar.showError(context, '존재 하지 않는 공지사항 입니다.');
              return;
            }
            context.push('/notice_view/$seq');
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.01,
              vertical: MediaQuery.of(context).size.height * 0.002,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: double.infinity,
                child: NoticeCard(
                  index: index,
                  title: notice.title ?? '',
                  createdAt: notice.createdAt!,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

