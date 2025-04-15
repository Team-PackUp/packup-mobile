// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get login => '로그인';

  @override
  String get id => '아이디';

  @override
  String get password => '비밀번호';

  @override
  String get join => '회원가입';

  @override
  String profile(Object name) {
    return '$name님의 개인 정보';
  }

  @override
  String get empty_id => '아이디를 입력해주세요';

  @override
  String get empty_password => '비밀번호를 입력해주세요';

  @override
  String get invalid_credentials => '아이디 또는 비밀번호가 잘못되었습니다';
}
