import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 基于 RouteAware 的页面生命周期管理
class RouteAwareLifecycle extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPageShow;
  final VoidCallback? onPageHide;
  final RouteObserver<ModalRoute<dynamic>> routeObserver;

  const RouteAwareLifecycle({
    super.key,
    required this.child,
    required this.routeObserver,
    this.onPageShow,
    this.onPageHide,
  });

  @override
  State<RouteAwareLifecycle> createState() => _RouteAwareLifecycleState();
}

class _RouteAwareLifecycleState extends State<RouteAwareLifecycle> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 注册路由监听
    final route = ModalRoute.of(context);
    if (route != null) {
      widget.routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    // 取消注册
    final route = ModalRoute.of(context);
    if (route != null) {
      widget.routeObserver.unsubscribe(this);
    }
    super.dispose();
  }

  @override
  void didPush() {
    super.didPush();
    print('${widget.runtimeType} - didPush (页面推入)');
    widget.onPageShow?.call();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    print('${widget.runtimeType} - didPopNext (页面重新可见)');
    widget.onPageShow?.call();
  }

  @override
  void didPop() {
    super.didPop();
    print('${widget.runtimeType} - didPop (页面弹出)');
    widget.onPageHide?.call();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    print('${widget.runtimeType} - didPushNext (页面被覆盖)');
    widget.onPageHide?.call();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// 全局路由观察者
final globalRouteObserver = RouteObserver<ModalRoute<dynamic>>();

/// 页面生命周期管理 Hook
class RouteAwareLifecycleHook {
  static void useRouteAwareLifecycle({
    required String pageName,
    VoidCallback? onPageShow,
    VoidCallback? onPageHide,
    VoidCallback? onInit,
    VoidCallback? onDispose,
  }) {
    final context = useContext();
    final mounted = useIsMounted();
    
    // 页面初始化
    useEffect(() {
      print('$pageName - 页面初始化');
      onInit?.call();
      
      return () {
        print('$pageName - 页面销毁');
        onDispose?.call();
      };
    }, []);

    // 使用 RouteAware 监听路由变化
    useEffect(() {
      final route = ModalRoute.of(context);
      if (route != null) {
        final observer = _RouteAwareObserver(
          context: context,
          pageName: pageName,
          onPageShow: onPageShow,
          onPageHide: onPageHide,
        );
        
        globalRouteObserver.subscribe(observer, route);
        
        return () {
          globalRouteObserver.unsubscribe(observer);
        };
      }
      return null;
    }, []);
  }
}

/// 内部 RouteAware 观察者
class _RouteAwareObserver extends RouteAware {
  final BuildContext context;
  final String pageName;
  final VoidCallback? onPageShow;
  final VoidCallback? onPageHide;

  _RouteAwareObserver({
    required this.context,
    required this.pageName,
    this.onPageShow,
    this.onPageHide,
  });

  @override
  void didPush() {
    super.didPush();
    print('$pageName - didPush (页面推入)');
    onPageShow?.call();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    print('$pageName - didPopNext (页面重新可见)');
    onPageShow?.call();
  }

  @override
  void didPop() {
    super.didPop();
    print('$pageName - didPop (页面弹出)');
    onPageHide?.call();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    print('$pageName - didPushNext (页面被覆盖)');
    onPageHide?.call();
  }
}

/// 增强版页面生命周期 Hook
class EnhancedRouteAwareLifecycleHook {
  static void useEnhancedRouteAwareLifecycle({
    required String pageName,
    VoidCallback? onResume,
    VoidCallback? onInactive,
    VoidCallback? onHide,
    VoidCallback? onShow,
    VoidCallback? onPause,
    VoidCallback? onRestart,
    VoidCallback? onDetach,
    VoidCallback? onInit,
    VoidCallback? onDispose,
    VoidCallback? onPageShow,    // 页面级别的显示
    VoidCallback? onPageHide,    // 页面级别的隐藏
  }) {
    final context = useContext();
    final mounted = useIsMounted();
    
    // 应用生命周期管理
    useEffect(() {
      print('$pageName - useEnhancedRouteAwareLifecycle init');
      onInit?.call();
      onShow?.call();
      
      return () {
        if (mounted()) {
          print('$pageName - useEnhancedRouteAwareLifecycle dispose');
          onDispose?.call();
        }
      };
    }, []);

    // 应用生命周期监听
    useEffect(() {
      final observer = _EnhancedLifecycleObserver(
        context: context,
        callbacks: _EnhancedLifecycleCallbacks(
          onResume: onResume,
          onInactive: onInactive,
          onHide: onHide,
          onShow: onShow,
          onPause: onPause,
          onRestart: onRestart,
          onDetach: onDetach,
        ),
      );
      
      WidgetsBinding.instance.addObserver(observer);
      
      return () {
        WidgetsBinding.instance.removeObserver(observer);
      };
    }, []);

    // RouteAware 页面生命周期监听
    RouteAwareLifecycleHook.useRouteAwareLifecycle(
      pageName: pageName,
      onPageShow: onPageShow,
      onPageHide: onPageHide,
    );
  }
}

/// 增强版生命周期回调
class _EnhancedLifecycleCallbacks {
  final VoidCallback? onResume;
  final VoidCallback? onInactive;
  final VoidCallback? onHide;
  final VoidCallback? onShow;
  final VoidCallback? onPause;
  final VoidCallback? onRestart;
  final VoidCallback? onDetach;

  const _EnhancedLifecycleCallbacks({
    this.onResume,
    this.onInactive,
    this.onHide,
    this.onShow,
    this.onPause,
    this.onRestart,
    this.onDetach,
  });
}

/// 增强版生命周期观察者
class _EnhancedLifecycleObserver extends WidgetsBindingObserver {
  final BuildContext context;
  final _EnhancedLifecycleCallbacks callbacks;
  bool _wasResumed = true;

  _EnhancedLifecycleObserver({
    required this.context,
    required this.callbacks,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        print('${context.widget.runtimeType} - onResume');
        callbacks.onResume?.call();
        if (!_wasResumed) {
          print('${context.widget.runtimeType} - onShow (从后台恢复)');
          callbacks.onShow?.call();
        }
        _wasResumed = true;
        break;
      case AppLifecycleState.inactive:
        print('${context.widget.runtimeType} - onInactive');
        callbacks.onInactive?.call();
        break;
      case AppLifecycleState.paused:
        print('${context.widget.runtimeType} - onPause');
        callbacks.onPause?.call();
        _wasResumed = false;
        break;
      case AppLifecycleState.detached:
        print('${context.widget.runtimeType} - onDetach');
        callbacks.onDetach?.call();
        _wasResumed = false;
        break;
      case AppLifecycleState.hidden:
        print('${context.widget.runtimeType} - onHide');
        callbacks.onHide?.call();
        _wasResumed = false;
        break;
    }
  }
} 