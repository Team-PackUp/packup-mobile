import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/view/tour/guide/edit/tour_guide_edit_controller.dart';

class Edit extends StatelessWidget {
  const Edit({super.key}); // ✅ 최신 Dart 스타일

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TourGuideEditController>();

    return Scaffold(
      appBar: AppBar(title: Text('Edit User')),
      body: Column(
        children: [
          TextField(
            controller: controller.nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          ElevatedButton(
            onPressed: controller.save,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
