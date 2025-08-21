import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/guide/guide_intro_provider.dart';

class GuideIntroReviewSection extends StatelessWidget {
  const GuideIntroReviewSection({super.key});

  String _preview(String s, {int max = 30}) {
    final t = s.trim();
    if (t.isEmpty) return '입력된 내용이 없어요';
    return t.length <= max ? t : '${t.substring(0, max)}…';
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GuideIntroProvider>();
    final d = p.data;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          CircleAvatar(
            radius: 36,
            backgroundColor: const Color(0xFFE5E7EB),
            child: const Icon(Icons.person, size: 32, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            '자격 사항 정보 입력하기',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            '호스트님에 대해 소개해 주세요.',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 20),

          _ReviewItemCard(
            leading: const Icon(Icons.timelapse_outlined, size: 24),
            title: '경력 연차',
            subtitle: '${(int.tryParse(d.years.trim()) ?? 0)}년',
            onTap: () => p.goTo(IntroStep.years),
          ),
          const SizedBox(height: 12),
          _ReviewItemCard(
            leading: const Icon(Icons.star_border_rounded, size: 24),
            title: '소개',
            subtitle: _preview(d.roleSummary),
            onTap: () => p.goTo(IntroStep.roleSummary),
          ),
          const SizedBox(height: 12),
          _ReviewItemCard(
            leading: const Icon(Icons.school_outlined, size: 24),
            title: '전문성',
            subtitle: _preview(d.expertise),
            onTap: () => p.goTo(IntroStep.expertise),
          ),
          const SizedBox(height: 12),
          _ReviewItemCard(
            leading: const Icon(Icons.add_rounded, size: 24),
            title: '수상 또는 언론 보도 이력 (선택 사항)',
            subtitle:
                d.achievement.trim().isEmpty
                    ? '직업적 성취를 입력해 주세요.'
                    : _preview(d.achievement),
            onTap: () => p.goTo(IntroStep.achievement),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ReviewItemCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ReviewItemCard({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: leading),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withOpacity(.65),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
