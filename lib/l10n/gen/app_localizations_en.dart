// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

  @override
  String get setLanguage => 'Set the language';

  @override
  String get followSystem => 'Automatic';

  @override
  String get languageFollowSystemDescription =>
      'Note: System presets only support languages from the list below.';

  @override
  String get appTitle => 'Flutter Demo';

  @override
  String get welcome => 'Welcome';
}
