import 'package:flutter/material.dart';
import 'package:packup/const/color.dart';
import 'package:packup/model/common/user_model.dart';
import 'package:packup/widget/common/circle_profile_image.dart';

import '../../common/util.dart';

class ChatRoomCard extends StatelessWidget {
  final String title;
  final String unReadCount;
  final String? profileImagePath;
  final String? lastMessage;
  final DateTime? lastMessageDate;
  final String fileFlag;

  const ChatRoomCard({
    super.key,
    required this.title,
    required this.unReadCount,
    this.profileImagePath,
    this.lastMessage,
    this.lastMessageDate,
    required this.fileFlag,
  });

  @override
  Widget build(BuildContext context) {

    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenW * 0.02,
              vertical: screenH * 0.015
          ),
          child: Row(
            children: [
              CircleProfileImage(
                radius: screenW * 0.065,
                imagePath: profileImagePath,
              ),
              SizedBox(width: screenW * 0.05),
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
                        if (lastMessageDate != null) SizedBox(width: screenW * 0.05),
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
                          SizedBox(width: screenW * 0.02),
                          CircleAvatar(
                            backgroundColor: SELECTED,
                            radius: screenW * 0.04,
                            child: Text(
                              unReadCount,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenW * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: screenW * 0.01),
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
