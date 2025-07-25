
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../../provider/user/user_provider.dart';
import '../../common/app_bar_profile.dart';

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection({super.key});


  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final user = context.watch<UserProvider>().userModel!;
    final nickname = user.nickname;

    return Row(
      children: [
        // 상단 이미지 + 이름
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleProfileImage(radius: h * 0.045,),
            IconButton(
              icon: Icon(Icons.camera_alt, size: 20),
              onPressed: () {
                // 사진 변경 기능
              },
            ),
          ],
        ),
        SizedBox(width: w * 0.03),
        Text(nickname!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

}