import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/profile/setting_account/notice/section/notice_list_section.dart';
import 'package:provider/provider.dart';
import '../../../../provider/profile/notice/notice_provider.dart';

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
  State<NoticeListContent> createState() => _NoticeListContentState();
}

class _NoticeListContentState extends State<NoticeListContent> {
  late NoticeProvider _noticeProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _noticeProvider = context.read<NoticeProvider>();
      await _noticeProvider.getNoticeList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: AppLocalizations.of(context)!.notice),
      body: const NoticeListSection(),
    );
  }
}
