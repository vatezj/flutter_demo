import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/home/indexPage.dart';
import 'package:flutter_demo/pages/login/loginPage.dart';
import 'package:flutter_demo/router/router.dart';
import 'package:flutter_demo/router/middleware.dart';

import 'package:flutter_demo/l10n/gen/app_localizations.dart';

void main() {
  // 注册中间件
  MyRouter.middlewareManager.register(AuthMiddleware());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IndexPage(),
      routes: MyRouter.ROUTES,

      locale: const Locale("en"), // "zh" | "zh", "TW"
      supportedLocales: AppL10n.supportedLocales,
      localizationsDelegates: AppL10n.localizationsDelegates,
    );
  }
}
