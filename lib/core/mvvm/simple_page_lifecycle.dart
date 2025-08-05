import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 简单页面生命周期管理 Hook
class SimplePageLifecycleHook {
  static void useSimplePageLifecycle({
    required String pageName,
    VoidCallback? onPageShow,
    VoidCallback? onPageHide,
    VoidCallback? onInit,
    VoidCallback? onDispose,
  }) {
    final context = useContext();
    final mounted = useIsMounted();
    final hasShown = useRef(false);
    
    // 页面初始化
    useEffect(() {
      print('$pageName - 页面初始化');
      onInit?.call();
      
      return () {
        print('$pageName - 页面销毁');
        onDispose?.call();
      };
    }, []);

    // 检测页面可见性变化
    useEffect(() {
      // 页面初始化时触发显示
      if (!hasShown.value) {
        hasShown.value = true;
        print('$pageName - 页面首次显示');
        onPageShow?.call();
      }
      
      return () {
        if (mounted()) {
          print('$pageName - 页面隐藏');
          onPageHide?.call();
        }
      };
    }, []);

    // 监听路由变化（页面返回时触发）
    useEffect(() {
      // 使用 Future.microtask 避免在 initState 中访问 context
      Future.microtask(() {
        final route = ModalRoute.of(context);
        if (route != null && hasShown.value) {
          // 页面重新变为可见（从其他页面返回）
          print('$pageName - 页面重新显示（从其他页面返回）');
          onPageShow?.call();
        }
      });
      return null;
    }, []);
  }
}

/// 增强版简单页面生命周期 Hook
class EnhancedSimplePageLifecycleHook {
  static void useEnhancedSimplePageLifecycle({
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
    final hasShown = useRef(false);
    
    // 应用生命周期管理
    useEffect(() {
      print('$pageName - useEnhancedSimplePageLifecycle init');
      onInit?.call();
      onShow?.call();
      
      return () {
        if (mounted()) {
          print('$pageName - useEnhancedSimplePageLifecycle dispose');
          onDispose?.call();
        }
      };
    }, []);

    // 应用生命周期监听
    useEffect(() {
      final observer = _SimpleLifecycleObserver(
        context: context,
        callbacks: _SimpleLifecycleCallbacks(
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

    // 页面可见性检测
    useEffect(() {
      // 页面初始化时触发显示
      if (!hasShown.value) {
        hasShown.value = true;
        print('$pageName - 页面首次显示');
        onPageShow?.call();
      }
      
      return () {
        if (mounted()) {
          print('$pageName - 页面隐藏');
          onPageHide?.call();
        }
      };
    }, []);

    // 监听路由变化（页面返回时触发）
    useEffect(() {
      // 使用 Future.microtask 避免在 initState 中访问 context
      Future.microtask(() {
        final route = ModalRoute.of(context);
        if (route != null && hasShown.value) {
          // 页面重新变为可见（从其他页面返回）
          print('$pageName - 页面重新显示（从其他页面返回）');
          onPageShow?.call();
        }
      });
      return null;
    }, []);
  }
}

/// 简单生命周期回调
class _SimpleLifecycleCallbacks {
  final VoidCallback? onResume;
  final VoidCallback? onInactive;
  final VoidCallback? onHide;
  final VoidCallback? onShow;
  final VoidCallback? onPause;
  final VoidCallback? onRestart;
  final VoidCallback? onDetach;

  const _SimpleLifecycleCallbacks({
    this.onResume,
    this.onInactive,
    this.onHide,
    this.onShow,
    this.onPause,
    this.onRestart,
    this.onDetach,
  });
}

/// 简单生命周期观察者
class _SimpleLifecycleObserver extends WidgetsBindingObserver {
  final BuildContext context;
  final _SimpleLifecycleCallbacks callbacks;
  bool _wasResumed = true;

  _SimpleLifecycleObserver({
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