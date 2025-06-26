import 'package:flutter/material.dart';
import 'package:packup/common/util.dart';

import '../common/custom_point_input.dart';

class ReplyCard extends StatelessWidget {
  final String nickName;
  final String? avatarUrl;
  final String content;
  final int point;
  final DateTime createdAt;

  const ReplyCard({
    super.key,
    required this.nickName,
    required this.content,
    required this.point,
    required this.createdAt,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: MediaQuery.of(context).size.height * 0.03,
                backgroundImage:
                    avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                child:
                    avatarUrl == null
                        ? Text(
                          nickName.characters.first.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                        : null,
              ),
              SizedBox(width: MediaQuery.of(context).size.height * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nickName,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.height * 0.02,
                      height: MediaQuery.of(context).size.height * 0.007,
                    ),
                    Row(
                      children: [
                        Text(
                          getMonthYear(createdAt),
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.1,),
                        CustomPointInput(
                          initialPoint: point,
                          mode: PointMode.view,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            content,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.017,
              height: MediaQuery.of(context).size.height * 0.0015,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
