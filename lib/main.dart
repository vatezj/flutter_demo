import 'package:flutter/material.dart';
import 'package:flutter_demo/core/init/app_init.dart';
import 'package:flutter_demo/core/router/app_router.dart';
import 'package:flutter_demo/core/config/app_config.dart';
import 'package:flutter_demo/core/provider/app_providers.dart';
import 'package:flutter_demo/l10n/gen/app_localizations.dart';

void main() {
  // 初始化应用
  AppInit.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders.getMultiProvider(
      child: MaterialApp(
        title: AppConfig.appName,
        theme: AppConfig.theme,
        initialRoute: AppConfig.initialRoute,
        onGenerateRoute: AppRouter.onGenerateRoute,
        locale: AppConfig.defaultLocale,
        supportedLocales: AppL10n.supportedLocales,
        localizationsDelegates: AppL10n.localizationsDelegates,
      ),
    );
  }
}
