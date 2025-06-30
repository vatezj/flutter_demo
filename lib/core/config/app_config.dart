import 'package:flutter/material.dart';

/// 应用配置类
class AppConfig {
  // 应用信息
  static const String appName = 'Flutter Demo';
  static const String initialRoute = 'BottomMenuBarPage';
  
  // 主题配置
  static ThemeData get theme => ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  
  // 国际化配置
  static const Locale defaultLocale = Locale("en");
  static const List<Locale> supportedLocales = [
    Locale("en"),
    Locale("zh"),
  ];
  
  // 路由配置
  static const String defaultRoute = 'IndexPage';
} 