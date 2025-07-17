import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final String userName;
  final double w;
  final double h;

  const ProfileSection({super.key, required this.userName, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(w * 0.03),
          side: BorderSide(
            color: Colors.grey.shade50,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(w * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '대전 킹카 $userName',
                style: TextStyle(
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: h * 0.006),
              Text(
                'PACK UP에 오신 것을 환영합니다!',
                style: TextStyle(fontSize: w * 0.035),
              ),
              SizedBox(height: h * 0.018),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.edit, size: w * 0.045),
                      label: Text('프로필 수정', style: TextStyle(fontSize: w * 0.035)),
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: h * 0.014),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.02),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.refresh, size: w * 0.05, color: Colors.white),
                      label: Text('호스트 모드로 전환', style: TextStyle(fontSize: w * 0.035, color: Colors.white)),
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        padding: EdgeInsets.symmetric(vertical: h * 0.014),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
