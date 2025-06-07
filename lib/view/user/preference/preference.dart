import 'package:flutter/material.dart';
import 'package:packup/const/color.dart';
import 'package:go_router/go_router.dart';

class Preference extends StatefulWidget {
  const Preference({super.key});

  @override
  State<Preference> createState() => _PreferenceState();
}

class _PreferenceState extends State<Preference> {
  final List<String> categories = [
    '기사',
    '책',
    '여행 가이드',
    '블로그',
    '시각 콘텐츠',
    '오디오 콘텐츠',
  ];

  final Set<String> selected = {};

  final Map<String, String> categoryImageMap = {
    '기사': 'assets/image/preference/article.png',
    '책': 'assets/image/preference/article.png',
    '여행 가이드': 'assets/image/preference/article.png',
    '블로그': 'assets/image/preference/article.png',
    '시각 콘텐츠': 'assets/image/preference/article.png',
    '오디오 콘텐츠': 'assets/image/preference/article.png',
  };

  void toggleSelect(String category) {
    setState(() {
      if (selected.contains(category)) {
        selected.remove(category);
      } else {
        selected.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 일러스트 이미지 (옵션)
              // Center(
              //   child: Image.asset(
              //     'assets/images/preference_illustration.png',
              //     height: 160,
              //   ),
              // ),
              // const SizedBox(height: 24),
              const Text(
                '어떤 유형의 콘텐츠가 관심 있으신가요?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '가장 즐기는 형식을 선택하세요.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // 선택 카드들
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.8,
                  children:
                      categories.map((category) {
                        final isSelected = selected.contains(category);
                        return GestureDetector(
                          onTap: () => toggleSelect(category),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    isSelected
                                        ? SECONDARY_COLOR
                                        : Colors.grey.shade300,
                                width: 1.5,
                              ),
                              color:
                                  isSelected
                                      ? SECONDARY_COLOR.withOpacity(0.15)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  categoryImageMap[category]!,
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        isSelected
                                            ? SECONDARY_COLOR
                                            : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),

              const SizedBox(height: 8),
              const Divider(height: 1),

              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.go('/index'); // 건너뛰기 → 인덱스
                      },
                      child: const Text(
                        '건너뛰기',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print('선택된 항목: $selected');
                        // TODO: 서버 전송 필요 시 여기에 추가
                        context.go('/index');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SECONDARY_COLOR,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('다음'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
