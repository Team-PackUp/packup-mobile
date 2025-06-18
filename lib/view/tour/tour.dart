import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/tour/tour_provider.dart';

import 'package:packup/model/tour/tour_model.dart';
import 'guide/edit/edit.dart';

class Tour extends StatelessWidget {
  const Tour({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TourProvider()..getTourList(),
      child: const TourBody(),
    );
  }
}

class TourBody extends StatefulWidget {
  const TourBody({super.key});

  @override
  State<TourBody> createState() => _TourBodyState();
}

class _TourBodyState extends State<TourBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

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

  @override
  void dispose() {
    _scrollController.dispose(); // 메모리 누수 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TourProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("투어 목록")),
      body: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            itemCount: provider.tourList.length + 1, // 로딩 인디케이터를 위해 +1
            itemBuilder: (context, index) {
              if (index < provider.tourList.length) {
                final tour = provider.tourList[index];
                return ListTile(
                  title: Text('${tour.seq} - ${tour.tourTitle ?? '제목 없음'}'),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TourEditPage(tour: tour),
                      ),
                    );

                    if (result == true) {
                      // 예: Provider 또는 상태 갱신을 통한 새로고침
                      await provider.getTourList(
                        refresh: true,
                      ); // Provider 사용 중이라면
                      // setState(() {}); // 필요하면 이것도 추가
                    }
                  },
                );
              } else {
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

                if (result == true) {
                  // 예: Provider 또는 상태 갱신을 통한 새로고침
                  await provider.getTourList(
                    refresh: true,
                  ); // Provider 사용 중이라면
                  // setState(() {}); // 필요하면 이것도 추가
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
