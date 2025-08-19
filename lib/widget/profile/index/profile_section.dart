import 'package:packup/model/common/app_mode.dart';
import 'package:packup/provider/common/app_mode_provider.dart';
import 'package:packup/service/user/user_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileSection extends StatelessWidget {
  final String userName;
  final double w;
  final double h;

  const ProfileSection({
    super.key,
    required this.userName,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(w * 0.03),
          side: BorderSide(color: Colors.grey.shade50, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(w * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '대전 킹카 $userName',
                style: TextStyle(
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: h * 0.006),
              Text(
                'PACK UP에 오신 것을 환영합니다!',
                style: TextStyle(fontSize: w * 0.035),
              ),
              SizedBox(height: h * 0.018),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.edit, size: w * 0.045),
                      label: Text(
                        '프로필 수정',
                        style: TextStyle(fontSize: w * 0.035),
                      ),
                      onPressed: () {
                        context.push('/profile/profile_modify');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: h * 0.014),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.02),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(
                        Icons.refresh,
                        size: w * 0.05,
                        color: Colors.white,
                      ),
                      label: Text(
                        '가이드 모드로 전환',
                        style: TextStyle(
                          fontSize: w * 0.035,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        try {
                          final status =
                              await UserService().fetchMyGuideStatus();

                          if (status.isGuide ||
                              status.application.statusName == 'APPROVED') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("승인된 가이드입니다. 가이드 모드로 전환합니다!"),
                              ),
                            );

                            await context.read<AppModeProvider>().setMode(
                              AppMode.guide,
                            );
                            if (context.mounted) context.go('/g');
                            return;
                          }

                          final app = status.application;

                          if (!app.exists) {
                            if (context.mounted) {
                              context.push('/guide/application/submit');
                            }
                            return;
                          }

                          switch (app.statusName) {
                            case 'APPLIED':
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("신청이 완료되었습니다. 심사 중입니다."),
                                ),
                              );
                              break;

                            case 'REJECTED':
                              {
                                final reason =
                                    (app.rejectReason?.isNotEmpty ?? false)
                                        ? '반려 사유: ${app.rejectReason}'
                                        : '반려되었습니다. 내용을 보완해 다시 신청해주세요.';
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(reason)));
                                if (app.canReapply && context.mounted) {
                                  context.push('/guide/application/submit');
                                }
                                break;
                              }

                            case 'CANCELED':
                              if (app.canReapply && context.mounted) {
                                context.push('/guide/application/submit');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("신청이 취소되었습니다.")),
                                );
                              }
                              break;

                            default:
                              if (context.mounted)
                                context.push('/guide/application/submit');
                              break;
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("가이드 상태 확인에 실패했습니다.")),
                          );
                        }
                      },

                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        padding: EdgeInsets.symmetric(vertical: h * 0.014),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
