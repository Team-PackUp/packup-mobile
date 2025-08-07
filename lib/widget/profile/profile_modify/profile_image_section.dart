
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../provider/user/user_provider.dart';
import '../../common/circle_profile_image.dart';

class ProfileImageSection extends StatefulWidget {
  final void Function(String imagePath) onImageChanged;

  const ProfileImageSection({super.key, required this.onImageChanged});

  @override
  State<ProfileImageSection> createState() => _ProfileImageSectionState();
}

class _ProfileImageSectionState extends State<ProfileImageSection> {
  final ImagePicker _picker = ImagePicker();
  String? _localImagePath;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    final user = context.watch<UserProvider>().userModel!;
    final nickname = user.nickname!;
    final displayImage = _localImagePath ?? user.profileImagePath;

    return Row(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              onTap: () {
                _pickImage();
              },
              child: CircleProfileImage(
                radius: screenH * 0.045,
                imagePath: displayImage,
              ),
            ),
          ],
        ),
        SizedBox(width: screenW * 0.05),
        Text(nickname, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _localImagePath = picked.path;
      });

      widget.onImageChanged(picked.path);
    }
  }
}
