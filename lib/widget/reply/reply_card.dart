import 'package:flutter/material.dart';
import 'package:packup/common/util.dart';
import 'package:packup/widget/common/circle_profile_image.dart';

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

    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // CircleProfileImage(radius: screenW * 0.05, imagePath: avatarUrl,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenW * 0.02,
                      height: screenH * 0.007,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              nickName,
                              style: TextStyle(
                                fontSize: screenH * 0.018,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: screenW * 0.02),
                            Text(
                              getDayMonthYear(createdAt),
                              style: TextStyle(
                                fontSize: screenH * 0.015,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        CustomPointInput(
                          initialPoint: point,
                          mode: PointMode.view,
                          size: screenW * 0.05,
                          filledColor: Colors.amber,
                          unfilledColor: Colors.grey,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenH * 0.02),
          Text(
            content,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.017,
              height: screenH * 0.0015,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
    );
  }
}
