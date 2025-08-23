import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user/user_provider.dart';

class CircleProfileImage extends StatelessWidget {
  final double radius;
  final String? imagePath;
  final bool profileAvatar;

  const CircleProfileImage({
    super.key,
    required this.radius,
    this.imagePath,
    this.profileAvatar = true,
  });

  @override
  Widget build(BuildContext context) {

    final String path = (() {
      final p = imagePath?.trim() ?? '';
      if (p.isNotEmpty) return p;

      if (profileAvatar) {
        final userPath = context.read<UserProvider>().userModel?.profileImagePath?.trim();
        if (userPath != null && userPath.isNotEmpty) return userPath;
      }
      return '';
    })();

    ImageProvider<Object>? bgImage;
    if (path.isNotEmpty) {
      if (path.startsWith('http')) {
        bgImage = NetworkImage(path);
      } else if (File(path).existsSync()) {
        bgImage = FileImage(File(path));
      } else {
        bgImage = null;
      }
    }

    // 3) 렌더링
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      backgroundImage: bgImage,
      child: (bgImage == null && profileAvatar)
          ? Icon(Icons.person, size: radius, color: Colors.grey[500])
          : null,
    );
  }
}
