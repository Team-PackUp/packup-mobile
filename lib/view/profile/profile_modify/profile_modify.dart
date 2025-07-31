import 'package:flutter/material.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/widget/common/alert_bell.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import '../../../widget/common/circle_profile_image.dart';
import '../../../widget/common/util_widget.dart';
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
        alert: AlertBell()
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
              CustomButton.textButton(
                  context: context,
                  onPressed: _updateProfile,
                  backgroundColor: PRIMARY_COLOR,
                  label: '저장하기'
              )
            ],
          ),
      ),
    );
  }

  void _updateProfile() {

  }
}
