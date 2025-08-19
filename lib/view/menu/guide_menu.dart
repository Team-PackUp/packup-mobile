import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:packup/widget/menu/section/menu_intro_section.dart';
import 'package:packup/widget/menu/section/menu_items_section.dart';
import 'package:packup/widget/menu/section/menu_switch_mode_section.dart';

import 'package:packup/widget/common/custom_sliver_appbar.dart';
import 'package:packup/widget/common/alert_bell.dart';
import 'package:packup/widget/common/circle_profile_image.dart';

import 'package:packup/provider/alert_center/alert_center_provider.dart';
import 'package:packup/provider/user/user_provider.dart';

class GuideMenuPage extends StatefulWidget {
  const GuideMenuPage({super.key});

  @override
  State<GuideMenuPage> createState() => _GuideMenuPageState();
}

class _GuideMenuPageState extends State<GuideMenuPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AlertCenterProvider>().initProvider();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    final profileUrl =
        context.watch<UserProvider>().userModel?.profileImagePath;

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder:
              (context, _) => [
                CustomSliverAppBar(
                  title: '메뉴',
                  arrowFlag: false,
                  alert: const AlertBell(),
                  profile: CircleProfileImage(radius: screenH * 0.02),
                ),
              ],
          body: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: screenW * 0.03,
              vertical: screenH * 0.01,
            ),
            children: [
              MenuIntroSection(),
              SizedBox(height: screenH * 0.03),
              MenuItemsSection(),
              SizedBox(height: 120),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenW * 0.03,
          vertical: screenH * 0.01,
        ),
        child: MenuSwitchModeSection(),
      ),
    );
  }
}
