import 'package:flutter/material.dart';
import 'package:packup/model/guide/guide_intro_model.dart';
import 'package:packup/widget/guide/intro/section/guide_intro_role_section.dart';
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

  String _title(IntroStep s) {
    switch (s) {
      case IntroStep.years:
        return '몇 년 동안 활동하셨나요?';
      case IntroStep.roleSummary:
        return '어떤 일을 하시나요?';
      case IntroStep.expertise:
        return '경력을 소개해 주세요';
      case IntroStep.achievement:
        return '직업적 성취를 입력해 주세요';
      case IntroStep.summary:
        return '요약을 입력해 주세요';
      case IntroStep.review:
        return '자격 사항 정보 입력하기';
    }
  }

  Widget _bodyByStep(IntroStep s) {
    switch (s) {
      case IntroStep.years:
        return const GuideIntroYearsSection();
      case IntroStep.roleSummary:
        return const GuideIntroRoleSection();
      case IntroStep.expertise:
      case IntroStep.achievement:
      case IntroStep.summary:
      case IntroStep.review:
        return const Center(child: Text('다음 단계 준비 중'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GuideIntroProvider>();

    if (p.loading && p.data == GuideIntroModel.empty()) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (p.step == IntroStep.years)
                Navigator.of(context).maybePop();
              else
                p.back();
            },
          ),
          title: Text(_title(p.step)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
        body: SafeArea(child: _bodyByStep(p.step)),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed:
                  p.validateCurrent()
                      ? () {
                        if (p.step == IntroStep.review) {
                          p.submit().then((ok) {
                            if (ok) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('저장되었습니다.')),
                              );
                              Navigator.pop(context);
                            }
                          });
                        } else {
                          p.next();
                        }
                      }
                      : null,
              child: Text(p.step == IntroStep.review ? '저장' : '다음'),
            ),
          ),
        ),
      ),
    );
  }
}
