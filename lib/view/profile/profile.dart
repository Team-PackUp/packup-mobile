import 'package:flutter/material.dart';
import 'package:packup/l10n/app_localizations.dart';

import 'package:packup/const/color.dart';
import 'package:packup/theme/theme.dart';

class Profile extends StatefulWidget {

  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: PRIMARY_COLOR,
        title: Text(
          AppLocalizations.of(context)!.profile('홍길동'),
            style: TextStyle(color: TEXT_COLOR_W)
        ),
        actions: const [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: switchThemeMode,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: PRIMARY_COLOR,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}