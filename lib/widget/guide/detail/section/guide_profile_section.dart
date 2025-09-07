import 'package:flutter/material.dart';
import 'package:packup/provider/guide/guide_provider.dart';
import 'package:packup/widget/guide/detail/guide_profile_card.dart';
import 'package:provider/provider.dart';

class GuideProfileSection extends StatefulWidget {
  final int guideSeq;
  const GuideProfileSection({super.key, required this.guideSeq});

  @override
  State<GuideProfileSection> createState() => _GuideProfileSectionState();
}

class _GuideProfileSectionState extends State<GuideProfileSection> {
  late final GuideProvider _provider;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _provider = GuideProvider.create(guideSeq: widget.guideSeq);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _loaded) return;
      _loaded = true;
      await _provider.getGuideDetail();
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
    return ChangeNotifierProvider<GuideProvider>.value(
      value: _provider,
      child: Consumer<GuideProvider>(
        builder: (_, p, __) {
          if (p.guideModel == null) return const SizedBox.shrink();
          return GuideProfileCard(guide: p.guideModel!);
        },
      ),
    );
  }
}
