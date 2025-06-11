
import 'package:flutter/cupertino.dart';

class TourGuideEditController {
  final nameController = TextEditingController();

  void dispose() {
    nameController.dispose();
  }

  void save() {
    // 저장 로직 (ex: Provider에 전달)
    print("Saving: ${nameController.text}");
  }
}
