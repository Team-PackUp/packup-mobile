import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:provider/provider.dart';

import '../../../provider/user/user_provider.dart';
import '../../../widget/common/app_bar_profile.dart';
import '../../../widget/profile/profile_modify/profile_detail_section.dart';
import '../../../widget/profile/profile_modify/profile_image_section.dart';
import '../../../widget/profile/profile_modify/profile_info_section.dart';

class ProfileModify extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();


  ProfileModify({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppbar(
        title: '프로필 수정',
        profile: CircleProfileImage(radius: h * 0.02,)
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ProfileImageSection(),
            SizedBox(height: h * 0.03),
            ProfileInfoSection(),
            SizedBox(height: h * 0.02),
            ProfileDetailSection(),
            SizedBox(height: h * 0.02),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 저장 로직
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text('저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
