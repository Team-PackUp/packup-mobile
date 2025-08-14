import 'package:flutter/material.dart';

class GuideApplicationDetailCard extends StatelessWidget {
  const GuideApplicationDetailCard({
    super.key,
    required this.occupation,
    required this.expertise,
    required this.experienceYears,
    required this.expertiseDetail,
    required this.onChangeOccupation,
    required this.onChangeExpertise,
    required this.onChangeExperienceYears,
    required this.onChangeExpertiseDetail,
  });

  final String occupation, expertise, experienceYears, expertiseDetail;
  final ValueChanged<String> onChangeOccupation,
      onChangeExpertise,
      onChangeExperienceYears,
      onChangeExpertiseDetail;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);
    InputDecoration deco(String label, String hint) => InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: radius),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: Color(0xFF111827), width: 1.2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );

    InputDecoration d(String l, String h) => deco(l, h);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "가이드 상세 정보",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: onChangeOccupation,
            controller: TextEditingController(text: occupation)
              ..selection = TextSelection.collapsed(offset: occupation.length),
            decoration: d("직업", "예: 도시 가이드"),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: onChangeExpertise,
            controller: TextEditingController(text: expertise)
              ..selection = TextSelection.collapsed(offset: expertise.length),
            decoration: d("전문 분야", "예: 역사, 음식, 자연"),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: onChangeExperienceYears,
            controller: TextEditingController(text: experienceYears)
              ..selection = TextSelection.collapsed(
                offset: experienceYears.length,
              ),
            decoration: d("경력 연수", "예: 5년"),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: onChangeExpertiseDetail,
            controller: TextEditingController(text: expertiseDetail)
              ..selection = TextSelection.collapsed(
                offset: expertiseDetail.length,
              ),
            minLines: 4,
            maxLines: 6,
            decoration: d("전문 분야 상세 설명", "귀하의 전문 분야에 대해 자세히 설명해주세요."),
          ),
        ],
      ),
    );
  }
}
