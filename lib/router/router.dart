// 为了更方便直观的修改，将路由定义提前
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/home/indexPage.dart';
import 'package:flutter_demo/pages/login/loginPage.dart';
import 'package:flutter_demo/pages/my/myPage.dart';
import 'package:flutter_demo/router/RouteHelper.dart';
import 'package:flutter_demo/router/middleware.dart';

const Type _HOME_ = IndexPage;


final _routes = RouteHelper.routeDefine({
  IndexPage: (_) => IndexPage(),
  MyPage: (_) => MyPage(),
  LoginPage: (_) => LoginPage(),

});

/// 这里我们需要将路由管理类改造成单例模式
class MyRouter {
  
  // 设置成私有构造，
  MyRouter._();
  
  // 临时变量用于保存路由参数
  // ------------------------- 
  Object? _arguments;
  String? _routeName;
  BuildContext? _context;
  // ------------------------- 
  
  /// 路由定义
  static final ROUTES = _routes;
  
  /// 单实例对象
  static final MyRouter _instance = MyRouter._();
  
  /// 对外部公开首页的路由名
  static final String INDEX = RouteHelper.typeName(_HOME_);
                                           
  /// 中间件管理器
  static final MiddlewareManager middlewareManager = MiddlewareManager();
  
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
  
  /// 重置临时变量
  void _resetVariables() {
    _context = null;
    _arguments = null;
    _routeName = null;
  }
  
  /// 携带参数跳转
  Future<T?> to<T>() {
    assert(_context != null);
    assert(_routeName != null);
    return Navigator.pushNamed<T>(
      _context!,
      _routeName!,
      arguments: _arguments,
    ).whenComplete(_resetVariables);
  }

  /// 静态设置参数，这个方法主要是用于在路由跳转时调用
  /// 然后通过上面设置的临时变量进行保存，最后调用 to 时传递过去
  static MyRouter _withArguments(dynamic arguments) {
    _instance._arguments = arguments;
    return _instance;
  }

  /// 这里就是确定路由参数的核心
  /// 由于定义路由时是通过：(_) => Page() 这种方式；
  /// 所以这里可以利用这种规则，我们先对这个函数调用一次，这样的话可以获取到对应页面的实例对象；
  /// 因为页面在混入 RouterBridge 类时就已经确定好了参数类型，所以我们这里我们直接返回
  /// 具体的页面实例对象，就可以调用 RouterBridge 混入类中的 arguments 方法，
  /// 而当我们调用 arguments 方法时，内部又是返回的 MyRouter 单例对象，所以就将外部设置的
  /// 参数又传回来了，然后保存到上面声明的临时变量中。
  static RT of<RT extends RouterBridge>(BuildContext context) {
    assert(RT != RouterBridge<dynamic>,
        "You must specify the route type, for example: of<Page>(context)");
    final name = RouteHelper.typeName(RT);
    assert(ROUTES.containsKey(name), "Route \"$RT\" is not registered.");
    _instance._context = context; // 临时保存 context
    _instance._routeName = name; // 临时保存路由名
    var builder = ROUTES[name]!; // 取得 WidgetBuilder 对象
    // 这里调用一次就可以获得对应的页面实例对象
    // 既然获得了实例对象，上面的页面又混入了对应的 RouterBridge，在后续调用 arguments 方法时
    // 就能唯一的确定具体路由需要的参数类型
    return builder.call(context) as RT;
  }
                                           
  /// 不带任何参数的路由跳转
  static Future<T?> routeTo<T>(BuildContext context, Type router) {
    final name = RouteHelper.typeName(router);
    assert(ROUTES.containsKey(name), "Route \"$router\" is not registered.");
    return Navigator.pushNamed<T>(context, name);
  }



  
  // 这个是在 MaterialApp 定义路由中需要使用的
  static Route<T> onGenerateRoute<T>(RouteSettings settings) {
    final builder = ROUTES[settings.name] ?? ROUTES[INDEX]!;
    return MaterialPageRoute<T>(
      builder: builder,
      settings: settings,
    );
  }

  /// 保留当前页面，跳转到应用内的某个页面
  static Future<T?> navigateTo<T>(BuildContext context, Type router, {Object? arguments}) async {
    final name = RouteHelper.typeName(router);
    assert(ROUTES.containsKey(name), "Route \"$router\" is not registered.");
    
    // 执行中间件
    final settings = RouteSettings(name: name, arguments: arguments);
    final canProceed = await middlewareManager.handle(context, settings);
    if (!canProceed) return null;

    return Navigator.push<T>(
      context,
      MaterialPageRoute<T>(
        builder: (context) => ROUTES[name]!(context),
        settings: settings,
      ),
    );
  }

  /// 关闭当前页面，跳转到应用内的某个页面
  static Future<T?> redirectTo<T, TO>(BuildContext context, Type router, {Object? arguments, TO? result}) async {
    final name = RouteHelper.typeName(router);
    assert(ROUTES.containsKey(name), "Route \"$router\" is not registered.");
    
    // 执行中间件
    final settings = RouteSettings(name: name, arguments: arguments);
    final canProceed = await middlewareManager.handle(context, settings);
    if (!canProceed) return null;

    return Navigator.pushReplacement<T, TO>(
      context,
      MaterialPageRoute<T>(
        builder: (context) => ROUTES[name]!(context),
        settings: settings,
      ),
      result: result,
    );
  }

  /// 关闭所有页面，打开到应用内的某个页面
  static Future<T?> reLaunch<T>(BuildContext context, Type router, {Object? arguments}) async {
    final name = RouteHelper.typeName(router);
    assert(ROUTES.containsKey(name), "Route \"$router\" is not registered.");
    
    // 执行中间件
    final settings = RouteSettings(name: name, arguments: arguments);
    final canProceed = await middlewareManager.handle(context, settings);
    if (!canProceed) return null;

    return Navigator.pushAndRemoveUntil<T>(
      context,
      MaterialPageRoute<T>(
        builder: (context) => ROUTES[name]!(context),
        settings: settings,
      ),
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
        Navigator.popUntil(context, (route) {
          return route.isFirst;
        });
      }
    } else {
      // 如果没有可返回的页面，则跳转到首页
      reLaunch(context, _HOME_);
    }
  }
}

/// 路由信息类
class RouteInfo {
  final String name;
  final Object? arguments;
  final bool isFirst;
  final bool isCurrent;

  RouteInfo({
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

// 混入类一定要放在和 MyRouter 同一级，这样才可以隐藏 MyRouter._withArguments 的实现
// 避免对外部暴露不需要的方法
mixin RouterBridge<T> {
  T? argumentOf(BuildContext context) {
    final settings = ModalRoute.of(context)?.settings;
    if (settings == null) return null;
    return settings.arguments as T?;
  }
}                               