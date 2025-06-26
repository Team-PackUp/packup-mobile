// lib/pages/ai_recommend/ai_recommend.dart
// ----------------------------------------------------
// AI Recommend Home Page (투어 버전) - 최초 진입 시 API 호출
// ----------------------------------------------------
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/widget/search_bar/custom_search_bar.dart';

import '../../provider/ai_recommend/ai_recommend_provider.dart';
import '../../provider/user/user_provider.dart';

import '../../widget/ai_recommend/category_chip.dart';
import '../../widget/ai_recommend/section.dart';
import '../../widget/ai_recommend/tour_card.dart';
import '../../model/ai_recommend/recommend_tour_model.dart';

class AIRecommend extends StatelessWidget {
  static const routeName = 'ai_recommend';

  const AIRecommend({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider 생성만 하고, API 호출은 Content 의 initState 에서 트리거
    return ChangeNotifierProvider(
      create: (_) => AIRecommendProvider(),
      child: const AIRecommendContent(),
    );
  }
}

class AIRecommendContent extends StatefulWidget {
  const AIRecommendContent({super.key});

  @override
  State<AIRecommendContent> createState() => _AIRecommendContentState();
}

class _AIRecommendContentState extends State<AIRecommendContent> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<AIRecommendProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AIRecommendProvider>();
    final userProvider = context.watch<UserProvider>();
    final profileUrl = userProvider.userModel?.profileImagePath;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('AI 추천', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
            color: Colors.black,
          ),
          CircleAvatar(
            radius: 16,
            backgroundImage: (profileUrl != null && profileUrl.isNotEmpty)
                ? NetworkImage(profileUrl)
                : null,
          ),
          const SizedBox(width: 8),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const CustomSearchBar(),
          const SizedBox(height: 16),
          // AI 추천 투어
          SectionHeader(
            icon: '🔥',
            title: 'AI가 추천하는 여행입니다!',
            onSeeMore: () {},
          ),
          _TourList(tours: provider.tourList),
          const SizedBox(height: 24),
          // 카테고리
          SectionHeader(
            icon: '🔍',
            title: '종류별 탐색 진행',
            onSeeMore: () {},
          ),
          CategoryChips(categories: provider.categories),
          const SizedBox(height: 24),
          // 인기 투어
          SectionHeader(
            icon: '⭐',
            title: '인기 투어 모아보기',
            onSeeMore: () {},
          ),
          _TourList(tours: provider.popular),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// 수평 스크롤 투어 카드 리스트
class _TourList extends StatelessWidget {
  final List<RecommendTourModel> tours;
  const _TourList({super.key, required this.tours});

  @override
  Widget build(BuildContext context) {
    if (tours.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tours.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => TourCard(tour: tours[index]),
      ),
    );
  }
}