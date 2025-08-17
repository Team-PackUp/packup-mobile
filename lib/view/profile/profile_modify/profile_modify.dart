import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/model/user/profile/user_profile_model.dart';
import 'package:packup/widget/common/alert_bell.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../../../provider/user/user_provider.dart';
import '../../../widget/common/custom_error_handler.dart';
import '../../../widget/common/util_widget.dart';
import '../../../widget/profile/profile_modify/section/profile_detail_section.dart';
import '../../../widget/profile/profile_modify/section/profile_image_section.dart';
import '../../../widget/profile/profile_modify/section/profile_info_section.dart';

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
  String newBirth = '';
  List<String> selectedCategories = [];

  bool _inited = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inited) return;
    _inited = true;

    final user = context.read<UserProvider>().userModel!;
    newNickName = user.nickname ?? '';
    newLanguage = user.userLanguage ?? '';   // ✅ 언어 초기값도 채워둠
    newGender   = user.userGender ?? '';         // 있으면 채우기
    newBirth    = user.userBirth  ?? '';         // 있으면 채우기
    selectedCategories = List<String>.from(user.preferCategorySeqJson ?? []);
    // setState() 필요 없음: 첫 build 전에 값만 준비
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: const CustomAppbar(
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
                setState(() => newProfileImage = XFile(path));
              },
            ),
            SizedBox(height: screenH * 0.03),
            ProfileInfoSection(
              detailInfoChange: (nickName, languageCode, birth, genderCode) {
                setState(() {
                  newNickName = nickName;
                  newLanguage = languageCode;
                  newBirth = birth;
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
                  newBirth: newBirth,
                  newGender: newGender,
                  selectedCategories: selectedCategories,
                );
              },
              backgroundColor: PRIMARY_COLOR,
              label: '저장하기',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile({
    XFile? newProfileImage,
    required String newNickName,
    required String newBirth,
    required String newGender,
    required List<String> selectedCategories,
  }) async {
    try {
      if (!validator()) return;

      final user = context.read<UserProvider>();

      String? imagePathToSave;
      if (newProfileImage != null) {
        final uploaded = await user.updateUserProfileImage(newProfileImage);
        imagePathToSave = '${uploaded.path!}/${uploaded.encodedName!}';
      }

      final model = UserProfileModel(
        profileImagePath: imagePathToSave,
        nickName: newNickName,
        birth: newBirth,
        gender: newGender,
        preference: selectedCategories,
      );

      await user.updateUserProfile(model);

      if (!mounted) return;
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
    if (newBirth.isEmpty) {
      CustomSnackBar.showResult(context, "나이를 입력해주세요");
      return false;
    }
    if (newGender.isEmpty) {
      CustomSnackBar.showResult(context, "성별을 입력해주세요");
      return false;
    }

    return true;
  }
}
