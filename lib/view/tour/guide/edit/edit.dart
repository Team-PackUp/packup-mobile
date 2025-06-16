import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_model.dart';
import 'package:packup/service/tour/tour_service.dart';
import 'package:packup/service/common/loading_service.dart';

class TourEditPage extends StatefulWidget {
  final TourModel tour;

  const TourEditPage({super.key, required this.tour});

  @override
  State<TourEditPage> createState() => _TourEditPageState();
}

class _TourEditPageState extends State<TourEditPage> {
  final _formKey = GlobalKey<FormState>();
  final TourService _tourService = TourService();

  // 폼 필드 컨트롤러
  late TextEditingController titleController;
  late TextEditingController introduceController;
  late TextEditingController minPeopleController;
  late TextEditingController maxPeopleController;
  late TextEditingController locationController;
  late TextEditingController titleImagePathController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.tour.tourTitle);
    introduceController = TextEditingController(text: widget.tour.tourIntroduce);
    minPeopleController = TextEditingController(text: widget.tour.minPeople.toString());
    maxPeopleController = TextEditingController(text: widget.tour.maxPeople.toString());
    locationController = TextEditingController(text: widget.tour.tourLocation);
    titleImagePathController = TextEditingController(text: widget.tour.titleImagePath ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    introduceController.dispose();
    minPeopleController.dispose();
    maxPeopleController.dispose();
    locationController.dispose();
    titleImagePathController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final body = {
      "minPeople": int.parse(minPeopleController.text),
      "maxPeople": int.parse(maxPeopleController.text),
      "applyStartDate": widget.tour.applyStartDate?.toIso8601String(),
      "applyEndDate": widget.tour.applyEndDate?.toIso8601String(),
      "tourStartDate": widget.tour.tourStartDate?.toIso8601String(),
      "tourEndDate": widget.tour.tourEndDate?.toIso8601String(),
      "tourTitle": titleController.text,
      "tourIntroduce": introduceController.text,
      "tourStatusCode": widget.tour.tourStatusCode,
      "tourLocation": locationController.text,
      "titleImagePath": titleImagePathController.text,
    };

    await LoadingService.run(() async {
      await _tourService.updateTour(widget.tour.seq!, body);
      if (mounted) Navigator.pop(context, true); // 성공 후 이전 페이지로
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("투어 정보 수정")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: '투어 제목'),
                validator: (val) => val!.isEmpty ? '필수 입력' : null,
              ),
              TextFormField(
                controller: introduceController,
                decoration: const InputDecoration(labelText: '투어 소개'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: minPeopleController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: '최소 인원'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: maxPeopleController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: '최대 인원'),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(labelText: '투어 위치'),
              ),
              TextFormField(
                controller: titleImagePathController,
                decoration: const InputDecoration(labelText: '대표 이미지 경로'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('저장'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
