// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppL10nZh extends AppL10n {
  AppL10nZh([String locale = 'zh']) : super(locale);

  @override
  String get language => '多语言';

  @override
  String get setLanguage => '设置语言';

  @override
  String get followSystem => '跟随系统';

  @override
  String get languageFollowSystemDescription => '注意：跟随系统仅支持以下列表中的语言。';

  @override
  String get appTitle => 'Flutter 示例';

  @override
  String get welcome => '欢迎';
}
