import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/view/login/login_view_model.dart';
import 'package:provider/provider.dart';
import 'package:packup/l10n/app_localizations.dart';

import 'package:packup/widget/common/custom_dialog.dart';

import 'package:packup/const/color.dart';
import 'package:packup/common/util.dart';

import 'package:packup/widget/login/social_login_btn.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _userIdErrorText = '';
  String _userPasswordErrorText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: PRIMARY_COLOR,
        title: Text(
            AppLocalizations.of(context)!.login,
            style: TextStyle(color: TEXT_COLOR_W)
        ),
      ),
      body: Consumer<UserViewModel>(
        builder: (context, viewModel, child) {
          // if (viewModel.isLoading) {
          //   return const Center(child: CircularProgressIndicator());
          // }
          return Padding(
            padding: EdgeInsets.only(
              top:  MediaQuery.of(context).size.height * 0.05,
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialLoginButton(
                  type: SocialLoginType.kakao,
                  onPressed: () => handleKakaoLogin(viewModel),
                ),
                SocialLoginButton(
                  type: SocialLoginType.google,
                  onPressed: () => handleGoogleLogin(viewModel),
                ),
                // 아이디 입력 필드
                // TextField(
                //   controller: _userIdController,
                //   obscureText: false,
                //   decoration: InputDecoration(
                //     labelText: AppLocalizations.of(context)!.id,
                //     errorText: _userIdErrorText.isNotEmpty ? _userIdErrorText : null,
                //   ),
                // ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                // TextField(
                //   controller: _passwordController,
                //   obscureText: true,
                //   decoration: InputDecoration(
                //     labelText: AppLocalizations.of(context)!.password,
                //     errorText: _userPasswordErrorText.isNotEmpty ? _userPasswordErrorText : null,
                //   ),
                // ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.1),
                // ElevatedButton(
                //   onPressed: () {
                //     login(_userIdController.text, _passwordController.text, context, viewModel);
                //   },
                //   style: ButtonStyle(backgroundColor: MaterialStateProperty.all(PRIMARY_COLOR)),
                //   child: SizedBox(
                //     width: MediaQuery.of(context).size.width * 0.5,
                //     child: Text(
                //         AppLocalizations.of(context)!.login,
                //       textAlign: TextAlign.center,
                //       style: TextStyle(color: TEXT_COLOR_W),
                //     ),
                //   ),
                // ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.1),
                ElevatedButton(
                  onPressed: () {
                    login(_userIdController.text, _passwordController.text, context, viewModel);
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(PRIMARY_COLOR)),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      AppLocalizations.of(context)!.login,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: TEXT_COLOR_W),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                // 회원가입 버튼
                ElevatedButton(
                  onPressed: () {
                    context.go('/index');
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(PRIMARY_COLOR)),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      '인덱스로 바로가기',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: TEXT_COLOR_W),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  login(String userId, String password, BuildContext context, UserViewModel viewModel) async {
    // validation(userId, password);
    await viewModel.getUserInfo(2);

    if (userId.isNotEmpty && password.isNotEmpty) {
      logger("로그인중입니다.");

      await viewModel.getUserInfo(2);

      if (viewModel.resultModel?.statusCode == 1) {
        if (context.mounted) {
          context.push('/index');
        }
      } else {
        context.push('/index');
        // setState(() {
        //   _userIdErrorText = AppLocalizations.of(context)!.invalid_credentials;
        //   _userPasswordErrorText = AppLocalizations.of(context)!.invalid_credentials;
        // });
      }
    }
  }

  Future<void> handleSocialLogin(SocialLoginType type, UserViewModel viewModel) async {
    await viewModel.checkLogin(type);

    if (!context.mounted) return;

    if (viewModel.accessToken == '' && viewModel.isLoading == false) {
      showDialog(
        context: context,
        builder: (context) => const CustomDialog(
          type: DialogType.modal,
          message: '로그인에 실패하였습니다.',
        ),
      );
    }
  }



  Future<void> handleKakaoLogin(UserViewModel viewModel) async {
    await handleSocialLogin(SocialLoginType.kakao, viewModel);
  }

  Future<void> handleGoogleLogin(UserViewModel viewModel) async {
    await handleSocialLogin(SocialLoginType.google, viewModel);
  }

  validation(String userId, String password) {
    setState(() {
      _userIdErrorText = userId.isEmpty ? AppLocalizations.of(context)!.empty_id : '';
      _userPasswordErrorText = password.isEmpty ? AppLocalizations.of(context)!.empty_password : '';
    });
  }
}
