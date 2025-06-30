import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo/core/provider/tab_provider.dart';

/// 应用级别的Provider管理器
class AppProviders {
  /// 获取所有providers
  static List<ChangeNotifierProvider> get providers => [
    ChangeNotifierProvider<TabProvider>(
      create: (_) => TabProvider(),
    ),
  ];

  /// 获取MultiProvider
  static MultiProvider getMultiProvider({required Widget child}) {
    return MultiProvider(
      providers: providers,
      child: child,
    );
  }
} 