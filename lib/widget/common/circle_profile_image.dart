import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user/user_provider.dart';

class CircleProfileImage extends StatelessWidget {
  final double radius;
  final String? imagePath;

  const CircleProfileImage({
    super.key,
    required this.radius,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {

    final rawPath = imagePath?.isNotEmpty == true
        ? imagePath!
        : context.watch<UserProvider>().userModel!.profileImagePath ?? '';

    ImageProvider<Object>? bgImage;
    if (rawPath.isNotEmpty) {
      if (rawPath.startsWith('http')) {
        bgImage = NetworkImage(rawPath) as ImageProvider<Object>;
      } else {
        bgImage = FileImage(File(rawPath)) as ImageProvider<Object>;
      }
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: bgImage,
      backgroundColor: Colors.grey[200],
    );
  }
}
