import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/tour_provider.dart';
import 'package:packup/widget/guide/detail/guide_tour_list.dart';
import 'package:packup/widget/guide/detail/section.dart';

class GuideTourSection extends StatefulWidget {
  final int guideSeq;
  const GuideTourSection({super.key, required this.guideSeq});

  @override
  State<GuideTourSection> createState() => _GuideTourSectionState();
}

class _GuideTourSectionState extends State<GuideTourSection> {
  late final TourProvider _provider;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _provider = TourProvider();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _loaded) return;
      _loaded = true;

      await _provider.getTourListByGuide(guideSeq: widget.guideSeq);
      if (!mounted) return;
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TourProvider>.value(
      value: _provider,
      child: Consumer<TourProvider>(
        builder: (_, p, __) {
          final tourList = p.tourListByGuide;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                icon: '🌟',
                title: 'Tour Detail',
                subTitle: '가이드가 운영하는 투어입니다!',
              ),
              if (tourList.isEmpty)
                const Text('등록된 투어가 없습니다.')
              else
                GuideTourList(
                  tours: tourList,
                  onTap: (_) {},
                ),
            ],
          );
        },
      ),
    );
  }
}
