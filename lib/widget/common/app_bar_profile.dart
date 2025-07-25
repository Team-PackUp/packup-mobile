import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user/user_provider.dart';

class CircleProfileImage extends StatelessWidget {
  final double radius;

  const CircleProfileImage({
    super.key,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().userModel!;
    final profileUrl = user.profileImagePath;

    return CircleAvatar(
      backgroundImage: profileUrl != null && profileUrl.isNotEmpty
          ? NetworkImage(profileUrl)
          : null,
      radius: radius,
    );
  }
}
