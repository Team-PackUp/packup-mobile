import 'package:flutter/material.dart';
import 'package:packup/const/color.dart';

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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (lastMessageDate != null) const SizedBox(width: 20),
                        if (lastMessageDate != null)
                          Text(
                            convertToChatRoomDate(lastMessageDate!),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (unReadCount != "0") ...[
                          const SizedBox(width: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                            decoration: BoxDecoration(
                              color: SELECTED,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              unReadCount,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fileFlag == 'Y'
                          ? '사진'
                          : (lastMessage?.trim().isNotEmpty ?? false ? lastMessage! : ''),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }


  String convertToChatRoomDate(DateTime date) {
    final type = getDateType(date);
    switch (type) {
      case DateType.today:
        return convertToHm(date);
      case DateType.yesterday:
        return '어제';
      default:
        return convertToYmd(date);
    }
  }
}
