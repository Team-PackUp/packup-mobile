import 'package:flutter/material.dart';
import 'package:packup/widget/menu/section/menu_intro_section.dart';
import 'package:packup/widget/menu/section/menu_items_section.dart';
import 'package:packup/widget/menu/section/menu_switch_mode_section.dart';

class GuideMenuPage extends StatelessWidget {
  const GuideMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: const [
            SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(child: MenuIntroSection()),
            SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(child: MenuItemsSection()),
            SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      bottomNavigationBar: const MenuSwitchModeSection(),
    );
  }
}
