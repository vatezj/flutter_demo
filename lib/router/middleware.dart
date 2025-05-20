import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/home/indexPage.dart';
import 'package:flutter_demo/pages/login/loginPage.dart';
import 'package:flutter_demo/pages/my/myPage.dart';
import 'package:flutter_demo/router/RouteHelper.dart';
import 'package:flutter_demo/router/context_extentison.dart';

/// 路由中间件基类
abstract class RouteMiddleware {
  /// 中间件优先级，数字越大优先级越高
  int get priority => 0;

  /// 处理路由请求
  /// 返回 true 表示继续执行下一个中间件
  /// 返回 false 表示中断路由
  Future<bool> handle(BuildContext context, RouteSettings settings);
}

/// 权限验证中间件
class AuthMiddleware extends RouteMiddleware {
  /// 白名单路由列表
  final Set<String> _whitelist = {
    RouteHelper.typeName(IndexPage),
    RouteHelper.typeName(LoginPage),
    RouteHelper.typeName(MyPage),
  };

  /// 白名单页面类型列表
  final Set<Type> _whitelistTypes = {
    LoginPage,
  };

  @override
  int get priority => 100;

  @override
  Future<bool> handle(BuildContext context, RouteSettings settings) async {
    // 检查是否在白名单中
    if (_isInWhitelist(settings)) {
      print('路由在白名单中，跳过权限验证');
      return true;
    }

    print('权限验证中间件');
    final bool isAuthenticated = await _checkAuth();
    if (!isAuthenticated) {
      // 未登录，跳转到登录页
      context.navigateTo(LoginPage);
      return false;
    }
    return true;
  }

  /// 检查路由是否在白名单中
  bool _isInWhitelist(RouteSettings settings) {
    print('检查路由是否在白名1单中');
    print('settings.name: ${settings.name}');
    print('settings.arguments: ${settings.arguments}');

    _whitelist.forEach((element) {
      print('element: $element');
    });
    // 检查路由名称
    if (settings.name != null && _whitelist.contains(settings.name)) {
      return true;
    }

    // 检查路由参数中的页面类型
    if (settings.arguments != null && settings.arguments is Type) {
      return _whitelistTypes.contains(settings.arguments as Type);
    }

    return false;
  }

  Future<bool> _checkAuth() async {
    // 这里实现实际的权限验证逻辑
    // 例如：检查 token、用户角色等
    return false;
  }
}

/// 路由中间件管理器
class MiddlewareManager {
  static final MiddlewareManager _instance = MiddlewareManager._internal();
  factory MiddlewareManager() => _instance;
  MiddlewareManager._internal();

  final List<RouteMiddleware> _middlewares = [];

  /// 注册中间件
  void register(RouteMiddleware middleware) {
    _middlewares.add(middleware);
    // 按优先级排序
    _middlewares.sort((a, b) => b.priority.compareTo(a.priority));
  }

  /// 执行中间件链
  Future<bool> handle(BuildContext context, RouteSettings settings) async {
    for (var middleware in _middlewares) {
      final result = await middleware.handle(context, settings);
      if (!result) return false;
    }
    return true;
  }
} 