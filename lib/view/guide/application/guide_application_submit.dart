import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:packup/widget/guide/application/section/guide_application_detail_section.dart';
import 'package:packup/widget/guide/application/section/guide_application_self_intro_section.dart';
import 'package:packup/widget/guide/application/section/guide_application_id_upload_section.dart';
import 'package:packup/widget/guide/application/section/guide_application_submit_section.dart';

class GuideApplicationSubmitPage extends StatefulWidget {
  const GuideApplicationSubmitPage({super.key});
  @override
  State<GuideApplicationSubmitPage> createState() => _State();
}

class _State extends State<GuideApplicationSubmitPage> {
  String occupation = "",
      expertise = "",
      experienceYears = "",
      expertiseDetail = "",
      selfIntro = "";
  String? pickedFileName;

  bool get isValid =>
      occupation.isNotEmpty &&
      expertise.isNotEmpty &&
      experienceYears.isNotEmpty &&
      expertiseDetail.isNotEmpty &&
      selfIntro.isNotEmpty &&
      pickedFileName != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GuideApplicationDetailSection(
                      occupation: occupation,
                      expertise: expertise,
                      experienceYears: experienceYears,
                      expertiseDetail: expertiseDetail,
                      onChangeOccupation: (v) => setState(() => occupation = v),
                      onChangeExpertise: (v) => setState(() => expertise = v),
                      onChangeExperienceYears:
                          (v) => setState(() => experienceYears = v),
                      onChangeExpertiseDetail:
                          (v) => setState(() => expertiseDetail = v),
                    ),
                    GuideApplicationSelfIntroSection(
                      value: selfIntro,
                      onChanged:
                          (v) => setState(
                            () => selfIntro = v.characters.take(500).toString(),
                          ),
                    ),
                    GuideApplicationIdUploadSection(
                      pickedFileName: pickedFileName,
                      onPickPressed:
                          () =>
                              setState(() => pickedFileName = "my_id_card.png"),
                    ),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
            GuideApplicationSubmitSection(
              enabled: isValid,
              onSubmit: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("정보 제출 (디자인 미리보기)")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        "가이드 지원서",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
      ),
    );
  }
}
