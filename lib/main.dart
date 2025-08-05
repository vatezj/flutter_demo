import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/core/router/app_router.dart';
import 'package:flutter_demo/core/config/app_config.dart';
import 'package:flutter_demo/core/init/app_init.dart';
import 'package:flutter_demo/core/mvvm/route_aware_lifecycle.dart';
import 'package:flutter_demo/l10n/gen/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化应用
  AppInit.init();
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: AppConfig.lightTheme,
      darkTheme: AppConfig.darkTheme,
      themeMode: ThemeMode.system,
      
      // 本地化配置
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      
      // 路由配置
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.initialRoute,
      
      // 添加全局路由观察者
      navigatorObservers: [globalRouteObserver],
      
      debugShowCheckedModeBanner: false,
    );
  }
}
