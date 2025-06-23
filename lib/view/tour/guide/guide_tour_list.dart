import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/tour_provider.dart';

import 'package:packup/model/tour/tour_model.dart';
import 'package:packup/view/tour/guide/edit/edit.dart';

/// 투어 목록 화면 (무한 스크롤 및 편집/추가 기능 포함)
class GuideTourList extends StatelessWidget {
  const GuideTourList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TourProvider()..getTourList(), // 화면 진입 시 리스트 초기 호출
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
          ListView.builder(
            controller: _scrollController,
            itemCount: provider.tourList.length + 1, // 마지막에 로딩 인디케이터 추가
            itemBuilder: (context, index) {
              if (index < provider.tourList.length) {
                final tour = provider.tourList[index];
                return ListTile(
                  title: Text('${tour.seq} - ${tour.tourTitle ?? '제목 없음'}'),
                  onTap: () async {
                    // 투어 수정 화면으로 이동
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TourEditPage(tour: tour),
                      ),
                    );

                    // 수정 완료 후 목록 새로고침
                    if (result == true) {
                      await provider.getTourList(refresh: true);
                      // 필요시 setState()로 강제 리렌더링
                    }
                  },
                );
              } else {
                // 하단 로딩 인디케이터
                return Visibility(
                  visible: provider.isLoading,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
            },
          ),

          /// 우측 상단 '추가' 버튼 - 신규 투어 등록용
          Positioned(
            top: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TourEditPage(tour: TourModel.empty()),
                  ),
                );

                // 추가 완료 후 목록 새로고침
                if (result == true) {
                  await provider.getTourList(refresh: true);
                }
              },
              child: const Text('추가'),
            ),
          ),
        ],
      ),
    );
  }
}
