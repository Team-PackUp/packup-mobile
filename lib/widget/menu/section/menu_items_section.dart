import 'package:flutter/material.dart';
import 'package:packup/widget/menu/menu_items_list.dart';

class MenuItemsSection extends StatelessWidget {
  const MenuItemsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: MenuItemsList(),
    );
  }
}
