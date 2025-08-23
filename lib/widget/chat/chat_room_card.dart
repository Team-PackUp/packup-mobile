import 'dart:async';
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

class _ChatRoomCardState extends State<ChatRoomCard> {
  String? _avatar;

  String _timeLabel = '';
  Timer? _midnightTimer;

  static const double _hPad = 12;
  static const double _vPad = 10;
  static const double _avatarRadius = 24;
  static const double _gap = 12;
  static const double _badgeRadius = 14;

  @override
  void initState() {
    super.initState();
    _avatar = widget.profileImagePath;

    _refreshTimeLabelAndSchedule();
  }

  @override
  void didUpdateWidget(covariant ChatRoomCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.lastMessageDate != widget.lastMessageDate) {
      _refreshTimeLabelAndSchedule();
    }
  }

  @override
  void dispose() {
    _midnightTimer?.cancel();
    super.dispose();
  }

  void _refreshTimeLabelAndSchedule() {
    _midnightTimer?.cancel();

    final newLabel = (widget.lastMessageDate == null)
        ? ''
        : convertToChatRoomDate(widget.lastMessageDate!);

    if (newLabel != _timeLabel) {
      setState(() {
        _timeLabel = newLabel;
      });
    }

    if (widget.lastMessageDate != null) {
      final now = DateTime.now();
      final last = widget.lastMessageDate!;
      final isToday = _isSameDay(last, now);
      final isYesterday = _isSameDay(last, now.subtract(const Duration(days: 1)));

      if (isToday || isYesterday) {
        print("자정 테스트");
        final nextMidnight = DateTime(now.year, now.month, now.day + 1);
        final delay = nextMidnight.difference(now);
        _midnightTimer = Timer(delay, () {
          if (!mounted) return;
          _refreshTimeLabelAndSchedule();
        });
      }
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

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

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _hPad, vertical: _vPad),
          child: Row(
            children: [
              CircleProfileImage(
                radius: _avatarRadius,
                imagePath: _avatar,
                profileAvatar: false,
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
                            _timeLabel,
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
}
