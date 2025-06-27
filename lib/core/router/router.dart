// 为了更方便直观的修改，将路由定义提前
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/home/indexPage.dart';
import 'package:flutter_demo/pages/login/loginPage.dart';
import 'package:flutter_demo/pages/my/myPage.dart';
import 'package:flutter_demo/core/router/RouteHelper.dart';
import 'package:flutter_demo/core/router/middleware.dart';

const Type _HOME_ = IndexPage;

final _routes = RouteHelper.routeDefine({
  IndexPage: (_) => IndexPage(),
  MyPage: (_) => MyPage(),
  LoginPage: (_) => LoginPage(),
});

/// 路由管理核心类 - 单例模式
class CoreRouter {
  // 私有构造函数
  CoreRouter._();
  
  // 单例实例
  static final CoreRouter _instance = CoreRouter._();
  
  /// 路由定义
  static final Map<String, WidgetBuilder> ROUTES = _routes;
  
  /// 对外部公开首页的路由名
  static const String INDEX = 'IndexPage';
                                           
  /// 中间件管理器
  static final MiddlewareManager middlewareManager = MiddlewareManager();
  
  /// 路由跳转状态
  static final Map<String, Object?> _pendingArguments = {};
  static final Map<String, BuildContext> _pendingContexts = {};
  
  /// 获取当前页面栈信息
  static List<RouteInfo> getRouteStack(BuildContext context) {
    final List<RouteInfo> stack = [];
    Navigator.of(context).popUntil((route) {
      stack.add(RouteInfo(
        name: route.settings.name ?? '',
        arguments: route.settings.arguments,
        isFirst: route.isFirst,
        isCurrent: route.isCurrent,
      ));
      return route.isFirst;
    });
    return stack.reversed.toList();
  }

  /// 打印当前页面栈信息
  static void printRouteStack(BuildContext context) {
    final stack = getRouteStack(context);
    print('当前页面栈信息：');
    for (var i = 0; i < stack.length; i++) {
      final route = stack[i];
      print('[$i] ${route.name} ${route.isCurrent ? '(当前)' : ''} ${route.isFirst ? '(首页)' : ''}');
      if (route.arguments != null) {
        print('    参数: ${route.arguments}');
      }
    }
  }
  
  /// 清理待处理的路由状态
  static void _clearPendingState(String routeName) {
    _pendingArguments.remove(routeName);
    _pendingContexts.remove(routeName);
  }
  
  /// 验证路由是否存在
  static bool _validateRoute(Type router) {
    final name = RouteHelper.typeName(router);
    if (!ROUTES.containsKey(name)) {
      throw ArgumentError('Route "$router" is not registered.');
    }
    return true;
  }
  
  /// 执行中间件检查
  static Future<bool> _executeMiddleware(BuildContext context, String routeName, Object? arguments) async {
    final settings = RouteSettings(name: routeName, arguments: arguments);
    return await middlewareManager.handle(context, settings);
  }
  
  /// 创建路由页面
  static Route<T> _createRoute<T>(String routeName, Object? arguments) {
    final builder = ROUTES[routeName] ?? ROUTES[INDEX]!;
    return MaterialPageRoute<T>(
      builder: builder,
      settings: RouteSettings(name: routeName, arguments: arguments),
    );
  }

  /// 不带任何参数的路由跳转
  static Future<T?> routeTo<T>(BuildContext context, Type router) {
    _validateRoute(router);
    final name = RouteHelper.typeName(router);
    return Navigator.pushNamed<T>(context, name);
  }

  /// 保留当前页面，跳转到应用内的某个页面
  static Future<T?> navigateTo<T>(BuildContext context, Type router, {Object? arguments}) async {
    _validateRoute(router);
    final name = RouteHelper.typeName(router);
    
    // 执行中间件检查
    final canProceed = await _executeMiddleware(context, name, arguments);
    if (!canProceed) return null;

    return Navigator.push<T>(
      context,
      _createRoute<T>(name, arguments),
    );
  }

  /// 关闭当前页面，跳转到应用内的某个页面
  static Future<T?> redirectTo<T, TO>(BuildContext context, Type router, {Object? arguments, TO? result}) async {
    _validateRoute(router);
    final name = RouteHelper.typeName(router);
    
    // 执行中间件检查
    final canProceed = await _executeMiddleware(context, name, arguments);
    if (!canProceed) return null;

    return Navigator.pushReplacement<T, TO>(
      context,
      _createRoute<T>(name, arguments),
      result: result,
    );
  }

  /// 关闭所有页面，打开到应用内的某个页面
  static Future<T?> reLaunch<T>(BuildContext context, Type router, {Object? arguments}) async {
    _validateRoute(router);
    final name = RouteHelper.typeName(router);
    
    // 执行中间件检查
    final canProceed = await _executeMiddleware(context, name, arguments);
    if (!canProceed) return null;

    return Navigator.pushAndRemoveUntil<T>(
      context,
      _createRoute<T>(name, arguments),
      (route) => false,
    );
  }

  /// 关闭当前页面，返回上一页面或多级页面
  /// 如果返回前面没有页面就跳转首页
  static void navigateBack(BuildContext context, {int delta = 1}) {
    if (Navigator.canPop(context)) {
      if (delta == 1) {
        Navigator.pop(context);
      } else {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } else {
      // 如果没有可返回的页面，则跳转到首页
      reLaunch(context, _HOME_);
    }
  }
  
  /// 这个是在 MaterialApp 定义路由中需要使用的
  static Route<T> onGenerateRoute<T>(RouteSettings settings) {
    final builder = ROUTES[settings.name] ?? ROUTES[INDEX]!;
    return MaterialPageRoute<T>(
      builder: builder,
      settings: settings,
    );
  }

  /// 获取路由实例（用于链式调用）
  static RT of<RT extends RouterBridge>(BuildContext context) {
    assert(RT != RouterBridge<dynamic>,
        "You must specify the route type, for example: of<Page>(context)");
    
    final name = RouteHelper.typeName(RT);
    if (!ROUTES.containsKey(name)) {
      throw ArgumentError('Route "$RT" is not registered.');
    }
    
    // 保存上下文和路由名
    _pendingContexts[name] = context;
    
    final builder = ROUTES[name]!;
    return builder.call(context) as RT;
  }
  
  /// 设置路由参数（链式调用）
  static CoreRouter arguments(Object? arguments) {
    // 找到最近的路由名
    final routeName = _pendingContexts.keys.lastOrNull;
    if (routeName != null) {
      _pendingArguments[routeName] = arguments;
    }
    return _instance;
  }
  
  /// 执行路由跳转（链式调用）
  Future<T?> to<T>() {
    final routeName = _pendingArguments.keys.lastOrNull;
    final context = _pendingContexts[routeName];
    
    if (routeName == null || context == null) {
      throw StateError('No pending route found. Call of<Page>() first.');
    }
    
    final arguments = _pendingArguments[routeName];
    _clearPendingState(routeName);
    
    return Navigator.pushNamed<T>(
      context,
      routeName,
      arguments: arguments,
    );
  }
}

/// 路由信息类
class RouteInfo {
  final String name;
  final Object? arguments;
  final bool isFirst;
  final bool isCurrent;

  const RouteInfo({
    required this.name,
    this.arguments,
    required this.isFirst,
    required this.isCurrent,
  });

  @override
  String toString() {
    return 'RouteInfo(name: $name, arguments: $arguments, isFirst: $isFirst, isCurrent: $isCurrent)';
  }
}

/// 路由桥接混入类
mixin RouterBridge<T> {
  /// 获取路由参数
  T? argumentOf(BuildContext context) {
    final settings = ModalRoute.of(context)?.settings;
    return settings?.arguments as T?;
  }
  
  /// 获取路由名称
  String? routeNameOf(BuildContext context) {
    return ModalRoute.of(context)?.settings.name;
  }
}                               