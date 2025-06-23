import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_model.dart';
import 'package:packup/service/common/loading_service.dart';
import 'package:packup/service/tour/tour_service.dart';
import 'package:packup/const/tour/tour_status_code.dart';

/// 투어 정보를 수정하거나 새로 생성하는 페이지입니다.
/// 기존 `TourModel` 인스턴스를 받아와 수정하거나,
/// `seq`가 null인 경우 신규 투어로 간주합니다.
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

  // 선택된 투어 상태
  late TourStatusCode selectedStatus;

  /// 상태 초기화 및 컨트롤러 초기값 설정
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.tour.tourTitle);
    introduceController = TextEditingController(text: widget.tour.tourIntroduce);
    minPeopleController = TextEditingController(text: widget.tour.minPeople.toString());
    maxPeopleController = TextEditingController(text: widget.tour.maxPeople.toString());
    locationController = TextEditingController(text: widget.tour.tourLocation);
    titleImagePathController = TextEditingController(text: widget.tour.titleImagePath ?? '');

    selectedStatus = widget.tour.seq == null
        ? TourStatusCode.temp
        : TourStatusCodeExtension.fromCode(widget.tour.tourStatusCode ?? '');
  }

  /// 컨트롤러 해제
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

  /// 폼 제출 처리 함수
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
      "tourStatusCode": selectedStatus.code,
      "tourLocation": locationController.text,
      "titleImagePath": titleImagePathController.text,
    };

    // 로딩 처리와 함께 API 호출 실행
    await LoadingService.run(() async {
      if (widget.tour.seq == null) {
        // 신규 생성
        await _tourService.createTour(body);
      } else {
        // 기존 투어 수정
        await _tourService.updateTour(widget.tour.seq!, body);
      }

      if (mounted) Navigator.pop(context, true); // 완료 후 이전 화면으로
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
              /// 투어 제목 입력 필드
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: '투어 제목'),
                validator: (val) => val!.isEmpty ? '필수 입력' : null,
              ),

              /// 투어 소개 입력 필드
              TextFormField(
                controller: introduceController,
                decoration: const InputDecoration(labelText: '투어 소개'),
              ),

              /// 최소/최대 인원 수 입력 필드
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

              /// 위치 입력 필드
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(labelText: '투어 위치'),
              ),

              /// 대표 이미지 경로 입력 필드
              TextFormField(
                controller: titleImagePathController,
                decoration: const InputDecoration(labelText: '대표 이미지 경로'),
              ),

              const SizedBox(height: 20),

              /// 상태 드롭다운 (기존 투어만 수정 가능)
              DropdownButtonFormField<TourStatusCode>(
                value: selectedStatus,
                onChanged: widget.tour.seq == null
                    ? null // 신규 투어는 상태 고정
                    : (val) {
                  if (val != null) {
                    setState(() => selectedStatus = val);
                  }
                },
                decoration: const InputDecoration(labelText: '투어 상태'),
                items: TourStatusCode.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.label),
                  );
                }).toList(),
              ),

              /// 저장 버튼
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
