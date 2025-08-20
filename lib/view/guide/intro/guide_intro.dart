import 'package:flutter/material.dart';
import 'package:packup/model/guide/guide_intro_model.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/guide/guide_intro_provider.dart';
import 'package:packup/service/guide/guide_service.dart';
import 'package:packup/widget/guide/intro/section/guide_intro_years_section.dart';

class GuideIntroPage extends StatelessWidget {
  const GuideIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GuideIntroProvider(GuideService())..load(),
      child: const _GuideIntroScaffold(),
    );
  }
}

class _GuideIntroScaffold extends StatelessWidget {
  const _GuideIntroScaffold();

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GuideIntroProvider>();

    if (p.loading && p.data == GuideIntroModel.empty()) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('호스트 소개 1단계'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
      body: const SafeArea(child: GuideIntroYearsSection()),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed:
                p.validateCurrent()
                    ? () {
                      p.next();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('연차가 저장되었습니다(임시). 다음 단계로 이동하세요.'),
                        ),
                      );
                    }
                    : null,
            child: const Text('다음'),
          ),
        ),
      ),
    );
  }
}
