import 'package:flutter/material.dart';
import 'package:packup/theme/typographies/app_typographies.dart';
import 'package:packup/const/color.dart';

class RewardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;

  const RewardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Container(
      width: screenW * 0.2,
      padding: EdgeInsets.all(screenH * 0.02),
      decoration: BoxDecoration(
        color: BACK_GROUND_COLOR_W,
        borderRadius: BorderRadius.circular(screenW * 0.02),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: SELECTED, size: 24),
              SizedBox(width: screenW * 0.02),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: title,
                      style: AppTypographies.get(
                        size: AppFontSize.lg,
                        weight: AppFontWeight.bold,
                        color: TEXT_COLOR_B,
                      ),
                    ),
                    TextSpan(text: ' '),
                    TextSpan(
                      text: subtitle,
                      style: AppTypographies.get(
                        size: AppFontSize.sm,
                        color: TEXT_COLOR_B2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenH * 0.01),
          Text(
            description,
            style: AppTypographies.get(
              size: AppFontSize.sm,
              color: TEXT_COLOR_B2,
            ),
          ),
        ],
      ),
    );
  }
}
