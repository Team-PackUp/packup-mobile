// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'LOGIN';

  @override
  String get id => 'id';

  @override
  String get password => 'password';

  @override
  String get join => 'JOIN';

  @override
  String profile(Object name) {
    return 'Profile of $name';
  }

  @override
  String get empty_id => 'Empty ID';

  @override
  String get empty_password => 'Empty password';

  @override
  String get invalid_credentials => 'Wrong ID or password';
}
