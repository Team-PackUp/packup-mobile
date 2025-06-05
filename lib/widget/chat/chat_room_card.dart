import 'package:flutter/material.dart';

import '../../common/util.dart';

class ChatRoomCard extends StatelessWidget {
  final String title;
  final String unReadCount;
  final String? lastMessage;
  final DateTime? lastMessageDate;
  final String fileFlag;

  const ChatRoomCard({
    super.key,
    required this.title,
    required this.unReadCount,
    this.lastMessage,
    this.lastMessageDate,
    required this.fileFlag,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),

                // 마지막 메시지
                if (lastMessage != null && lastMessage!.trim().isNotEmpty)
                  fileFlag == 'Y' ?
                  Text(
                    '사진',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ) :
                  Text(
                    lastMessage!,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
              ],
            ),
          ),

          // 날짜 조건에 따라 포맷 변경 필요
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (lastMessageDate != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      convertToChatRoomDate(lastMessageDate!),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (unReadCount != "0")
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      unReadCount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String convertToChatRoomDate(DateTime lastMessageDate) {
    String lastDateString = '';
    final dateType = getDateType(lastMessageDate);

    switch (dateType) {
      case DateType.today:
        lastDateString = convertToHm(lastMessageDate);
        break;
      case DateType.yesterday:
        lastDateString = '어제';
        break;
      default:
        lastDateString = convertToYmd(lastMessageDate);
        break;
    }

    return lastDateString;
  }
}