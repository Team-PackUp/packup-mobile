import 'package:flutter/material.dart';
import 'package:packup/widget/tour/tour_card.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/tour_provider.dart';

import 'package:packup/model/tour/tour_model.dart';
import 'guide/edit/edit.dart';

/// 투어 목록 화면 (무한 스크롤 및 편집/추가 기능 포함)
class Tour extends StatelessWidget {
  const Tour({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TourProvider(),
      child: const TourBody(),
    );
  }
}

/// 투어 목록을 그리는 Stateful 위젯
class TourBody extends StatefulWidget {
  const TourBody({super.key});

  @override
  State<TourBody> createState() => _TourBodyState();
}

class _TourBodyState extends State<TourBody> {
  // 스크롤 위치 추적을 위한 컨트롤러 (무한 스크롤 용도)
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // 화면이 완전히 그려진 후 초기 투어 목록 요청
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TourProvider>().getTourList();
    });

    // 스크롤 하단 도달 시 다음 페이지 데이터 요청
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        final provider = context.read<TourProvider>();
        if (provider.hasNextPage && !provider.isLoading) {
          provider.getTourList();
        }
      }
    });
  }

  /// ScrollController는 반드시 해제해야 메모리 누수 방지 가능
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TourProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("투어 목록")),
      body: Stack(
        children: [
          /// 투어 리스트 렌더링
          GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2열 구성
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.54, // 카드의 가로:세로 비율 조정 (필요 시 튜닝)
            ),
            itemCount: provider.tourList.length + (provider.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < provider.tourList.length) {
                final tour = provider.tourList[index];
                return TourCard(
                  tour: tour,
                  isFavorite: false,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TourEditPage(tour: tour),
                      ),
                    );
                    if (result == true) {
                      await provider.getTourList(refresh: true);
                    }
                  },
                  onFavoriteToggle: () {},
                );
              } else {
                // 하단 로딩 인디케이터 (GridView에도 대응)
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
