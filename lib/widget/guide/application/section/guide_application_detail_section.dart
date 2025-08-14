import 'package:flutter/material.dart';
import 'package:packup/widget/guide/application/detail_card.dart';

class GuideApplicationDetailSection extends StatelessWidget {
  const GuideApplicationDetailSection({
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: GuideApplicationDetailCard(
        occupation: occupation,
        expertise: expertise,
        experienceYears: experienceYears,
        expertiseDetail: expertiseDetail,
        onChangeOccupation: onChangeOccupation,
        onChangeExpertise: onChangeExpertise,
        onChangeExperienceYears: onChangeExperienceYears,
        onChangeExpertiseDetail: onChangeExpertiseDetail,
      ),
    );
  }
}
