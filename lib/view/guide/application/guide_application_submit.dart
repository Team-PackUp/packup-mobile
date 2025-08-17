import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:packup/provider/guide/application/guide_application_provider.dart';
import 'package:provider/provider.dart';

import 'package:packup/service/guide/guide_service.dart';

import 'package:packup/widget/guide/application/section/guide_application_self_intro_section.dart';
import 'package:packup/widget/guide/application/section/guide_application_id_upload_section.dart';
import 'package:packup/widget/guide/application/section/guide_application_submit_section.dart';

class GuideApplicationSubmitPage extends StatelessWidget {
  const GuideApplicationSubmitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GuideApplicationProvider(service: GuideService()),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GuideApplicationProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GuideApplicationSelfIntroSection(
                      value: p.selfIntro,
                      onChanged:
                          context.read<GuideApplicationProvider>().setSelfIntro,
                    ),

                    GuideApplicationIdUploadSection(
                      pickedFileName: p.pickedFileName,
                      onPickPressed: () async {
                        final picker = ImagePicker();
                        final x = await picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 85,
                        );
                        if (x != null) {
                          context
                              .read<GuideApplicationProvider>()
                              .setPickedXFile(x);
                          HapticFeedback.selectionClick();
                        }
                      },
                    ),

                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),

            GuideApplicationSubmitSection(
              enabled: p.isValid && !p.submitting,
              onSubmit: () {
                HapticFeedback.lightImpact();
                context.read<GuideApplicationProvider>().submit(context);
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
