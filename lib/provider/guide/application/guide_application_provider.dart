import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/common/loading_service.dart';
import 'package:packup/service/guide/guide_service.dart';

class GuideApplicationProvider extends LoadingProvider {
  GuideApplicationProvider({GuideService? service})
    : _service = service ?? GuideService();

  final GuideService _service;

  String selfIntro = "";
  XFile? idImage;
  String? pickedFileName;
  bool submitting = false;

  bool get isValid => selfIntro.trim().isNotEmpty && idImage != null;

  void setSelfIntro(String v) {
    selfIntro = v;
    notifyListeners();
  }

  void setPickedXFile(XFile file) {
    idImage = file;
    pickedFileName = file.name;
    notifyListeners();
  }

  void reset() {
    selfIntro = "";
    idImage = null;
    pickedFileName = null;
    submitting = false;
    notifyListeners();
  }

  Future<void> submit(BuildContext context) async {
    if (!isValid || submitting) return;

    submitting = true;
    notifyListeners();

    await LoadingService.run(() async {
          await _service.submitApplication(
            selfIntro: selfIntro,
            idImage: idImage!,
          );
        })
        .then((_) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("지원서가 제출되었습니다.")));
            Navigator.of(context).pop();
          }
        })
        .catchError((err) {
          final msg = "제출 중 오류가 발생했습니다.";
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(msg)));
          }
        });

    submitting = false;
    notifyListeners();
  }
}
