import 'package:flutter/material.dart';
import 'package:packup/Const/color.dart';

class HomeBanner extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onTap;

  const HomeBanner({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            imagePath,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
          ),

          Container(
            width: double.infinity,
            height: 180,
            color: Colors.black.withOpacity(0.3),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenH * 0.03),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenH * 0.02),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SELECTED,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: screenW * 0.02),
                    ),
                    onPressed: onTap,
                    child: Text(
                      buttonText,
                      style: const TextStyle(fontSize: 14),
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
}
