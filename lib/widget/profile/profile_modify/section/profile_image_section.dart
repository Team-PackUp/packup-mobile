import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:packup/widget/common/util_widget.dart';
import 'package:provider/provider.dart';

import '../../../../provider/user/user_provider.dart';
import '../../../common/circle_profile_image.dart';
import '../../../common/slide_text.dart';

class ProfileImageSection extends StatefulWidget {
  final void Function(String imagePath) onImageChanged;
  const ProfileImageSection({super.key, required this.onImageChanged});

  @override
  State<ProfileImageSection> createState() => _ProfileImageSectionState();
}

class _ProfileImageSectionState extends State<ProfileImageSection> {
  final ImagePicker _picker = ImagePicker();
  String? _localImagePath;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _localImagePath = picked.path);
      widget.onImageChanged(picked.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().userModel!;
    final email = user.email ?? '';
    final nickname = user.nickname ?? '';
    final displayImage = _localImagePath ?? user.profileImagePath;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 아바타 + 카메라 배지
        SizedBox(
          width: 84,
          height: 84,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleProfileImage(
                    radius: 42, // 84 / 2
                    imagePath: displayImage,
                  ),
                ),
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: InkWell(
                  onTap: _pickImage,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // 닉네임 / 계정
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nickname,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // 계정 (읽기 전용 + 복사 버튼)
              Row(
                children: [
                  const Icon(Icons.email_outlined, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: SlideText(
                      title: email,
                    ),
                  ),
                  IconButton(
                    tooltip: '이메일 복사',
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: email));
                      CustomSnackBar.showResult(context, '계정이 복사되었어요');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
