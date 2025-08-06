import 'package:flutter/material.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/model/user/profile/user_profile_model.dart';
import 'package:packup/widget/common/alert_bell.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../../../provider/user/user_provider.dart';
import '../../../widget/common/custom_error_handler.dart';
import '../../../widget/common/util_widget.dart';
import '../../../widget/profile/profile_modify/profile_detail_section.dart';
import '../../../widget/profile/profile_modify/profile_image_section.dart';
import '../../../widget/profile/profile_modify/profile_info_section.dart';

class ProfileModify extends StatefulWidget {
  const ProfileModify({super.key});

  @override
  State<ProfileModify> createState() => _ProfileModifyState();
}


class _ProfileModifyState extends State<ProfileModify> {
  String newProfileImagePath = '';
  String newNickName = '';
  String newLanguage = '';
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().userModel!;
    newProfileImagePath = user.profileImagePath ?? '';
    newNickName = user.nickname ?? '';
    // newLanguage = user.language ?? '';
    selectedCategories = List<String>.from(user.preferCategorySeqJson ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: CustomAppbar(
        title: '프로필 수정',
        alert: AlertBell(),
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
            ProfileImageSection(
              onImageChanged: (newImagePath) {
                setState(() {
                  newProfileImagePath = newImagePath;
                });
              },
            ),
            SizedBox(height: screenH * 0.03),
            ProfileInfoSection(
              detailInfoChange: (nickName, language) {
                setState(() {
                  newNickName = nickName;
                  newLanguage = language;
                });
              },
            ),
            SizedBox(height: screenH * 0.02),
            ProfileDetailSection(
              preferenceChange: (pref) {
                setState(() {
                  selectedCategories = pref;
                });
              },
            ),
            SizedBox(height: screenH * 0.02),
            CustomButton.textButton(
              context: context,
              onPressed: () {
                FocusScope.of(context).unfocus();
                _updateProfile(
                  newProfileImagePath: newProfileImagePath,
                  newNickName: newNickName,
                  newLanguage: newLanguage,
                  selectedCategories: selectedCategories,
                );
              },
              backgroundColor: PRIMARY_COLOR,
              label: '저장하기',
            )
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile({
    required String newProfileImagePath,
    required String newNickName,
    required String newLanguage,
    required List<String> selectedCategories,
  }) async {
    try {
      if (!validator()) return;

      final model = UserProfileModel(
        profileImagePath: newProfileImagePath,
        language: newLanguage,
        nickName: newNickName,
        preference: selectedCategories
      );

      await context.read<UserProvider>().updateUserProfile(model);
      CustomSnackBar.showResult(context, "수정 되었습니다");
    } catch (e) {
      CustomErrorHandler.run(context, e);
    }
  }

  validator() {
    if(newProfileImagePath.isEmpty) {
      CustomSnackBar.showResult(context, "프로필 이미지를 선택해주세요");
      return false;
    }

    if(newNickName.isEmpty) {
      CustomSnackBar.showResult(context, "닉네임을 입력해주세요");
      return false;
    }

    if(newLanguage.isEmpty) {
      CustomSnackBar.showResult(context, "언어를 선택해주세요");
      return false;
    }

    return true;
  }
}
