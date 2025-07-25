
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/user/user_provider.dart';

class ProfileDetailSection extends StatelessWidget {
  const ProfileDetailSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final user = context.watch<UserProvider>().userModel!;
    final List<String> interests = ['관심1', '관심2', '관심3'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('관심사'),
        ),
        SizedBox(height: h * 0.02),
        Wrap(
          spacing: w * 0.02,
          children: interests
              .map((interest) => Chip(
            label: Text(interest),
            deleteIcon: Icon(Icons.close),
            onDeleted: () {
              // 삭제 로직
            },
          )).toList(),
        ),
        SizedBox(height: h * 0.02),
        TextField(
          decoration: InputDecoration(
            hintText: '관심사 추가',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
