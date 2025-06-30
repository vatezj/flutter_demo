import 'package:flutter_demo/core/router/router.dart';
import 'package:flutter_demo/core/router/middleware.dart';

/// 应用初始化类
class AppInit {
  /// 初始化应用
  static void init() {
    _registerMiddlewares();
  }
  
  /// 注册中间件
  static void _registerMiddlewares() {
    CoreRouter.middlewareManager.register(AuthMiddleware());
  }
} 