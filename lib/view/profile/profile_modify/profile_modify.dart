import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/model/common/file_model.dart';
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
  XFile? newProfileImage;
  String newNickName = '';
  String newLanguage = '';
  String newGender = '';
  String newAge = '';
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().userModel!;
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
              onImageChanged: (path) {
                setState(() {
                  newProfileImage = XFile(path);
                });
              },
            ),
            SizedBox(height: screenH * 0.03),
            ProfileInfoSection(
              detailInfoChange: (nickName, languageCode, age, genderCode) {
                setState(() {
                  newNickName = nickName;
                  newLanguage = languageCode;
                  newAge = age;
                  newGender = genderCode;
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
                  newProfileImage: newProfileImage,
                  newNickName: newNickName,
                  newAge: newAge,
                  newGender: newGender,
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
    XFile? newProfileImage,
    required String newNickName,
    required String newAge,
    required String newGender,
    required String newLanguage,
    required List<String> selectedCategories,
  }) async {
    try {
      if (!validator()) return;

      final user = context.read<UserProvider>();

      String? imagePathToSave;

      if (newProfileImage != null) {
        FileModel uploaded = await user.updateUserProfileImage(newProfileImage);
        imagePathToSave = '${uploaded.path!}/${uploaded.encodedName!}';
      }

      final model = UserProfileModel(
        profileImagePath: imagePathToSave,
        nickName: newNickName,
        age: newAge,
        gender: newGender,
        language: newLanguage,
        preference: selectedCategories,
      );

      if (!mounted) return;
      await user.updateUserProfile(model);
      CustomSnackBar.showResult(context, "수정 되었습니다");
    } catch (e) {
      if (!mounted) return;
      CustomErrorHandler.run(context, e);
    }
  }

  bool validator() {
    if (newNickName.isEmpty) {
      CustomSnackBar.showResult(context, "닉네임을 입력해주세요");
      return false;
    }

    if (newAge.isEmpty) {
      CustomSnackBar.showResult(context, "나이를 입력해주세요");
      return false;
    }

    if (newGender.isEmpty) {
      CustomSnackBar.showResult(context, "성별을 입력해주세요");
      return false;
    }

    if (newLanguage.isEmpty) {
      CustomSnackBar.showResult(context, "언어를 선택해주세요");
      return false;
    }

    return true;
  }
}
