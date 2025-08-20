import 'package:flutter/material.dart';
import 'reply_card.dart'; // 스타일 컨테이너 재사용 (없으면 Container로 대체해도 OK)

class ReplyReadCard extends StatelessWidget {
  final String nickName;
  final String? avatarUrl;
  final String content;
  final int point;               // 0~5
  final DateTime? createdAt;     // 있으면 포맷해서 표시
  final String? createdAtLabel;  // createdAt 대신 직접 문자열로 표시하고 싶을 때
  final List<String>? imageUrls; // 선택: 본문 아래 썸네일들
  final Widget? trailing;        // 선택: 우측 상단 액션(메뉴 버튼 등)

  const ReplyReadCard({
    super.key,
    required this.nickName,
    required this.content,
    required this.point,
    this.avatarUrl,
    this.createdAt,
    this.createdAtLabel,
    this.imageUrls,
    this.trailing,
  });

  String _fmtDate(DateTime d) {
    // 간단 포맷: yyyy.MM.dd
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y.$m.$day';
  }

  @override
  Widget build(BuildContext context) {
    final dateText = createdAtLabel ??
        (createdAt != null ? _fmtDate(createdAt!) : null);

    return ReplyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFE9EEF3),
                backgroundImage:
                (avatarUrl != null && avatarUrl!.isNotEmpty)
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: (avatarUrl == null || avatarUrl!.isEmpty)
                    ? const Icon(Icons.person, color: Color(0xFF8E98A8))
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nickName,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (i) {
                          final filled = i < point;
                          return Icon(
                            filled
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            size: 18,
                            color: filled
                                ? Colors.amber
                                : Colors.grey.shade400,
                          );
                        }),
                        if (dateText != null) ...[
                          const SizedBox(width: 8),
                          Text('· $dateText',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              )),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),

          const SizedBox(height: 12),

          // 본문
          Text(
            content,
            style: const TextStyle(fontSize: 14, color: Color(0xFF111111)),
          ),

          // 이미지 썸네일 (옵션)
          if (imageUrls != null && imageUrls!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: imageUrls!.map((url) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    url,
                    width: 84,
                    height: 84,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
