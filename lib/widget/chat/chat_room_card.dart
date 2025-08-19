import 'package:flutter/material.dart';
import 'package:packup/const/color.dart';
import 'package:packup/common/util.dart';
import 'package:packup/widget/common/circle_profile_image.dart';

class ChatRoomCard extends StatefulWidget {
  final String title;
  final String unReadCount;
  final String? profileImagePath;
  final String? lastMessage;
  final DateTime? lastMessageDate;
  final String fileFlag;

  final bool freezeProfileImage;

  const ChatRoomCard({
    super.key,
    required this.title,
    required this.unReadCount,
    this.profileImagePath,
    this.lastMessage,
    this.lastMessageDate,
    required this.fileFlag,
    this.freezeProfileImage = true,
  });

  @override
  State<ChatRoomCard> createState() => _ChatRoomCardState();
}

class _ChatRoomCardState extends State<ChatRoomCard>
    with AutomaticKeepAliveClientMixin {
  String? _avatar;

  static const double _hPad = 12;
  static const double _vPad = 10;
  static const double _avatarRadius = 24;
  static const double _gap = 12;
  static const double _badgeRadius = 14;

  @override
  void initState() {
    super.initState();
    _avatar = widget.profileImagePath;
  }

  @override
  void didUpdateWidget(covariant ChatRoomCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.freezeProfileImage) {
      _avatar = widget.profileImagePath;
      return;
    }

    if (_avatar == null && widget.profileImagePath != null) {
      _avatar = widget.profileImagePath;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _hPad, vertical: _vPad),
          child: Row(
            children: [
              CircleProfileImage(
                radius: _avatarRadius,
                imagePath: _avatar,
              ),
              const SizedBox(width: _gap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.lastMessageDate != null) ...[
                          const SizedBox(width: 12),
                          Text(
                            convertToChatRoomDate(widget.lastMessageDate!),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        if (widget.unReadCount != "0") ...[
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: SELECTED,
                            radius: _badgeRadius,
                            child: Text(
                              widget.unReadCount,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.fileFlag == 'Y'
                          ? '사진'
                          : ((widget.lastMessage?.trim().isNotEmpty ?? false)
                          ? widget.lastMessage!
                          : ''),
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
