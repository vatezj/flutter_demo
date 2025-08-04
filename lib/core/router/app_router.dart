import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/BottomMenuBarPage.dart';
import 'package:flutter_demo/core/router/router.dart';
import 'package:flutter_demo/core/mvvm/tab_view_model.dart';

/// 应用路由管理器
class AppRouter {
  /// 初始路由
  static const String initialRoute = 'BottomMenuBarPage';
  
  /// 生成应用路由
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    print('AppRouter onGenerateRoute: ${settings.name}, arguments: ${settings.arguments}');
    
    final routeName = settings.name ?? 'BottomMenuBarPage';
    
    // 检查是否是tabs页面
    if (TabRoute.isTabRoute(routeName)) {
      print('AppRouter: 创建BottomMenuBarPage，initialRoute: $routeName');
      // 如果是tabs页面，显示带底部导航栏的页面
      return MaterialPageRoute(
        builder: (context) => BottomMenuBarPage(initialRoute: routeName),
        settings: settings,
      );
    } else if (routeName == 'BottomMenuBarPage') {
      print('AppRouter: 创建BottomMenuBarPage作为初始路由，arguments: ${settings.arguments}');
      // 如果是BottomMenuBarPage本身，使用传递的参数作为initialRoute
      final initialRoute = settings.arguments as String? ?? 'IndexPage';
      return MaterialPageRoute(
        builder: (context) => BottomMenuBarPage(initialRoute: initialRoute),
        settings: settings,
      );
    } else {
      print('AppRouter: 创建普通页面，routeName: $routeName');
      // 如果不是tabs页面，不显示底部导航栏
      final builder = CoreRouter.ROUTES[routeName];
      if (builder != null) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: builder.call(context),
          ),
          settings: settings,
        );
      }
      // 默认显示首页
      return MaterialPageRoute(
        builder: (context) => const BottomMenuBarPage(initialRoute: 'IndexPage'),
        settings: const RouteSettings(name: 'IndexPage'),
      );
    }
  }
} 