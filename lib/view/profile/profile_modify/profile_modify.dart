import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:provider/provider.dart';

import '../../../provider/user/user_provider.dart';
import '../../../widget/common/circle_profile_image.dart';
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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: CustomAppbar(
        title: '프로필 수정',
        profile: CircleProfileImage(radius: h * 0.02,)
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                .copyWith(bottom: bottomInset + 100),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
