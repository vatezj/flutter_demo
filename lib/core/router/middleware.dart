import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/home/indexPage.dart';
import 'package:flutter_demo/pages/login/loginPage.dart';
import 'package:flutter_demo/pages/my/myPage.dart';
import 'package:flutter_demo/core/router/route_helper.dart';
import 'package:flutter_demo/core/router/context_extension.dart';

/// 路由中间件基类
abstract class RouteMiddleware {
  /// 中间件优先级，数字越大优先级越高
  int get priority => 0;

  /// 中间件名称，用于调试
  String get name => runtimeType.toString();

  /// 处理路由请求
  /// 返回 true 表示继续执行下一个中间件
  /// 返回 false 表示中断路由
  Future<bool> handle(BuildContext context, RouteSettings settings);
  
  /// 中间件执行前的回调
  void onBeforeHandle(BuildContext context, RouteSettings settings) {
    // 子类可以重写此方法
  }
  
  /// 中间件执行后的回调
  void onAfterHandle(BuildContext context, RouteSettings settings, bool result) {
    // 子类可以重写此方法
  }
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
  String get name => 'AuthMiddleware';

  @override
  Future<bool> handle(BuildContext context, RouteSettings settings) async {
    // 检查是否在白名单中
    if (_isInWhitelist(settings)) {
      print('[$name] 路由在白名单中，跳过权限验证: ${settings.name}');
      return true;
    }

    // print('[$name] 开始权限验证');
    // final bool isAuthenticated = await _checkAuth();
    // if (!isAuthenticated) {
    //   print('[$name] 权限验证失败，跳转到登录页');
    //   // 未登录，跳转到登录页
    //   context.navigateTo(LoginPage);
    //   return false;
    // }
    
    // print('[$name] 权限验证通过');
    return true;
  }

  /// 检查路由是否在白名单中
  bool _isInWhitelist(RouteSettings settings) {
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
    // 模拟网络请求延迟
    await Future.delayed(Duration(milliseconds: 100));
    return false; // 暂时返回 false 用于测试
  }
}

/// 日志中间件
class LoggingMiddleware extends RouteMiddleware {
  @override
  int get priority => 50;
  
  @override
  String get name => 'LoggingMiddleware';

  @override
  Future<bool> handle(BuildContext context, RouteSettings settings) async {
    print('[$name] 路由跳转: ${settings.name}');
    if (settings.arguments != null) {
      print('[$name] 路由参数: ${settings.arguments}');
    }
    return true;
  }
}

/// 路由中间件管理器
class MiddlewareManager {
  static final MiddlewareManager _instance = MiddlewareManager._internal();
  factory MiddlewareManager() => _instance;
  MiddlewareManager._internal();

  final List<RouteMiddleware> _middlewares = [];
  bool _isInitialized = false;

  /// 初始化默认中间件
  void initialize() {
    if (_isInitialized) return;
    
    // 注册默认中间件
    register(LoggingMiddleware());
    register(AuthMiddleware());
    
    _isInitialized = true;
    print('MiddlewareManager: 中间件管理器已初始化，共注册 ${_middlewares.length} 个中间件');
  }

  /// 注册中间件
  void register(RouteMiddleware middleware) {
    if (_middlewares.any((m) => m.runtimeType == middleware.runtimeType)) {
      print('MiddlewareManager: 中间件 ${middleware.name} 已存在，将被替换');
      _middlewares.removeWhere((m) => m.runtimeType == middleware.runtimeType);
    }
    
    _middlewares.add(middleware);
    // 按优先级排序
    _middlewares.sort((a, b) => b.priority.compareTo(a.priority));
    
    print('MiddlewareManager: 注册中间件 ${middleware.name}，优先级: ${middleware.priority}');
  }

  /// 移除中间件
  void unregister(Type middlewareType) {
    final initialCount = _middlewares.length;
    _middlewares.removeWhere((m) => m.runtimeType == middlewareType);
    final removedCount = initialCount - _middlewares.length;
    if (removedCount > 0) {
      print('MiddlewareManager: 移除中间件 $middlewareType');
    }
  }

  /// 获取所有中间件
  List<RouteMiddleware> get middlewares => List.unmodifiable(_middlewares);

  /// 执行中间件链
  Future<bool> handle(BuildContext context, RouteSettings settings) async {
    // 确保已初始化
    if (!_isInitialized) {
      initialize();
    }
    
    if (_middlewares.isEmpty) {
      print('MiddlewareManager: 没有注册的中间件，直接通过');
      return true;
    }

    print('MiddlewareManager: 开始执行中间件链，共 ${_middlewares.length} 个中间件');
    
    for (var i = 0; i < _middlewares.length; i++) {
      final middleware = _middlewares[i];
      final startTime = DateTime.now();
      
      try {
        // 执行前回调
        middleware.onBeforeHandle(context, settings);
        
        // 执行中间件
        final result = await middleware.handle(context, settings);
        
        // 执行后回调
        middleware.onAfterHandle(context, settings, result);
        
        final duration = DateTime.now().difference(startTime);
        print('MiddlewareManager: [${i + 1}/${_middlewares.length}] ${middleware.name} 执行完成，耗时: ${duration.inMilliseconds}ms，结果: $result');
        
        if (!result) {
          print('MiddlewareManager: 中间件 ${middleware.name} 中断了路由链');
          return false;
        }
      } catch (e, stackTrace) {
        print('MiddlewareManager: 中间件 ${middleware.name} 执行出错: $e');
        print('MiddlewareManager: 错误堆栈: $stackTrace');
        return false;
      }
    }
    
    print('MiddlewareManager: 所有中间件执行完成，路由通过');
    return true;
  }
  
  /// 清空所有中间件
  void clear() {
    _middlewares.clear();
    _isInitialized = false;
    print('MiddlewareManager: 已清空所有中间件');
  }
} 