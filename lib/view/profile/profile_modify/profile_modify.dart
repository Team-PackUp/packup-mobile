import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import '../../../widget/common/circle_profile_image.dart';
import '../../../widget/profile/profile_modify/profile_detail_section.dart';
import '../../../widget/profile/profile_modify/profile_image_section.dart';
import '../../../widget/profile/profile_modify/profile_info_section.dart';

class ProfileModify extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();


  ProfileModify({super.key});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: CustomAppbar(
        title: '프로필 수정',
        profile: CircleProfileImage(radius: screenH * 0.02,)
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
            padding: EdgeInsets.symmetric(
                horizontal: screenW * 0.05,
                vertical: screenH * 0.01,
            ).copyWith(bottom: bottomInset + 100),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              ProfileImageSection(),
              SizedBox(height: screenH * 0.03),
              ProfileInfoSection(),
              SizedBox(height: screenH * 0.02),
              ProfileDetailSection(),
              SizedBox(height: screenH * 0.02),
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
