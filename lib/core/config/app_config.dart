import 'package:flutter/material.dart';

/// 应用配置类
class AppConfig {
  // 应用信息
  static const String appName = 'Flutter Demo';
  static const String initialRoute = 'BottomMenuBarPage';
  
  // 主题配置
  static ThemeData get lightTheme => ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    useMaterial3: true,
  );
  
  static ThemeData get darkTheme => ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    useMaterial3: true,
  );
  
  // 国际化配置
  static const Locale defaultLocale = Locale("zh", "CN");
  static const List<Locale> supportedLocales = [
    Locale("zh", "CN"),
    Locale("en", "US"),
  ];
  
  // 路由配置
  static const String defaultRoute = 'IndexPage';
} 