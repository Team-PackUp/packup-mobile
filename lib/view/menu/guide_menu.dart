import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/common/alert_bell.dart';

import 'package:packup/widget/menu/section/menu_intro_section.dart';
import 'package:packup/widget/menu/section/menu_items_section.dart';
import 'package:packup/widget/menu/section/menu_switch_mode_section.dart';

import 'package:packup/provider/alert_center/alert_center_provider.dart';

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
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppbar(title: '메뉴', alert: const AlertBell()),
      body: ListView(
        padding: EdgeInsets.fromLTRB(w * 0.03, h * 0.01, w * 0.03, 0),
        children: const [
          MenuIntroSection(),
          SizedBox(height: 24),
          MenuItemsSection(),
          SizedBox(height: 120),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(w * 0.03, 0, w * 0.03, h * 0.01),
        child: const MenuSwitchModeSection(),
      ),
    );
  }
}
