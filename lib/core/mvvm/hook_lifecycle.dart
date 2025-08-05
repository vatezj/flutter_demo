import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'page_lifecycle.dart';

/// Hook 生命周期回调接口
class HookLifecycleCallbacks {
  final VoidCallback? onResume;
  final VoidCallback? onInactive;
  final VoidCallback? onHide;
  final VoidCallback? onShow;
  final VoidCallback? onPause;
  final VoidCallback? onRestart;
  final VoidCallback? onDetach;
  final VoidCallback? onInit;
  final VoidCallback? onDispose;

  const HookLifecycleCallbacks({
    this.onResume,
    this.onInactive,
    this.onHide,
    this.onShow,
    this.onPause,
    this.onRestart,
    this.onDetach,
    this.onInit,
    this.onDispose,
  });
}

/// 使用生命周期管理的 Hook
void useLifecycle(HookLifecycleCallbacks callbacks) {
  final context = useContext();
  final mounted = useIsMounted();
  
  // 初始化
  useEffect(() {
    print('${context.widget.runtimeType} - useLifecycle init');
    callbacks.onInit?.call();
    // 页面初始化时触发 onShow
    callbacks.onShow?.call();
    return () {
      if (mounted()) {
        print('${context.widget.runtimeType} - useLifecycle dispose');
        callbacks.onDispose?.call();
      }
    };
  }, []);

  // 应用生命周期监听
  useEffect(() {
    final observer = _LifecycleObserver(
      context: context,
      callbacks: callbacks,
    );
    
    WidgetsBinding.instance.addObserver(observer);
    
    return () {
      WidgetsBinding.instance.removeObserver(observer);
    };
  }, []);
}

/// 内部生命周期观察者
class _LifecycleObserver extends WidgetsBindingObserver {
  final BuildContext context;
  final HookLifecycleCallbacks callbacks;
  bool _wasResumed = true;

  _LifecycleObserver({
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
        // 如果之前不是 resumed 状态，则触发 onShow
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

/// 页面可见性 Hook
bool usePageVisibility() {
  final isVisible = useState(true);
  
  useEffect(() {
    final observer = _VisibilityObserver(
      onShow: () => isVisible.value = true,
      onHide: () => isVisible.value = false,
    );
    
    WidgetsBinding.instance.addObserver(observer);
    
    return () {
      WidgetsBinding.instance.removeObserver(observer);
    };
  }, []);
  
  return isVisible.value;
}

/// 页面可见性检测 Hook（更精确的版本）
void usePageVisibilityDetection({
  required VoidCallback onShow,
  required VoidCallback onHide,
}) {
  final context = useContext();
  
  useEffect(() {
    final observer = _PageVisibilityObserver(
      context: context,
      onShow: onShow,
      onHide: onHide,
    );
    
    WidgetsBinding.instance.addObserver(observer);
    
    return () {
      WidgetsBinding.instance.removeObserver(observer);
    };
  }, []);
}

/// 内部可见性观察者
class _VisibilityObserver extends WidgetsBindingObserver {
  final VoidCallback onShow;
  final VoidCallback onHide;
  bool _wasVisible = true;

  _VisibilityObserver({
    required this.onShow,
    required this.onHide,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    final isVisible = state == AppLifecycleState.resumed;
    
    if (isVisible && !_wasVisible) {
      onShow();
    } else if (!isVisible && _wasVisible) {
      onHide();
    }
    
    _wasVisible = isVisible;
  }
}

/// 页面可见性观察者（更精确的版本）
class _PageVisibilityObserver extends WidgetsBindingObserver {
  final BuildContext context;
  final VoidCallback onShow;
  final VoidCallback onHide;
  bool _wasVisible = true;

  _PageVisibilityObserver({
    required this.context,
    required this.onShow,
    required this.onHide,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    final isVisible = state == AppLifecycleState.resumed;
    
    if (isVisible && !_wasVisible) {
      print('${context.widget.runtimeType} - 页面变为可见');
      onShow();
    } else if (!isVisible && _wasVisible) {
      print('${context.widget.runtimeType} - 页面变为不可见');
      onHide();
    }
    
    _wasVisible = isVisible;
  }
}

/// 生命周期管理 Hook
class LifecycleHook {
  static void usePageLifecycle({
    VoidCallback? onResume,
    VoidCallback? onInactive,
    VoidCallback? onHide,
    VoidCallback? onShow,
    VoidCallback? onPause,
    VoidCallback? onRestart,
    VoidCallback? onDetach,
    VoidCallback? onInit,
    VoidCallback? onDispose,
  }) {
    useLifecycle(HookLifecycleCallbacks(
      onResume: onResume,
      onInactive: onInactive,
      onHide: onHide,
      onShow: onShow,
      onPause: onPause,
      onRestart: onRestart,
      onDetach: onDetach,
      onInit: onInit,
      onDispose: onDispose,
    ));
  }

  /// 增强版生命周期管理，包含页面可见性检测
  static void useEnhancedPageLifecycle({
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
      print('${context.widget.runtimeType} - useEnhancedLifecycle init');
      onInit?.call();
      onShow?.call();
      onPageShow?.call(); // 页面初始化时触发页面显示
      
      return () {
        if (mounted()) {
          print('${context.widget.runtimeType} - useEnhancedLifecycle dispose');
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
          onPageShow: onPageShow,
          onPageHide: onPageHide,
        ),
      );
      
      WidgetsBinding.instance.addObserver(observer);
      
      return () {
        WidgetsBinding.instance.removeObserver(observer);
      };
    }, []);

    // 页面可见性检测（使用 Future.microtask 避免 initState 错误）
    useEffect(() {
      Future.microtask(() {
        // 页面初始化时触发显示
        onPageShow?.call();
      });
      return null;
    }, []);
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
  final VoidCallback? onPageShow;
  final VoidCallback? onPageHide;

  const _EnhancedLifecycleCallbacks({
    this.onResume,
    this.onInactive,
    this.onHide,
    this.onShow,
    this.onPause,
    this.onRestart,
    this.onDetach,
    this.onPageShow,
    this.onPageHide,
  });
}

/// 增强版生命周期观察者
class _EnhancedLifecycleObserver extends WidgetsBindingObserver {
  final BuildContext context;
  final _EnhancedLifecycleCallbacks callbacks;
  bool _wasResumed = true;
  bool _wasVisible = true;

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
          print('${context.widget.runtimeType} - onPageShow (页面重新可见)');
          callbacks.onPageShow?.call();
        }
        _wasResumed = true;
        _wasVisible = true;
        break;
      case AppLifecycleState.inactive:
        print('${context.widget.runtimeType} - onInactive');
        callbacks.onInactive?.call();
        break;
      case AppLifecycleState.paused:
        print('${context.widget.runtimeType} - onPause');
        callbacks.onPause?.call();
        if (_wasVisible) {
          print('${context.widget.runtimeType} - onPageHide (页面变为不可见)');
          callbacks.onPageHide?.call();
        }
        _wasResumed = false;
        _wasVisible = false;
        break;
      case AppLifecycleState.detached:
        print('${context.widget.runtimeType} - onDetach');
        callbacks.onDetach?.call();
        if (_wasVisible) {
          print('${context.widget.runtimeType} - onPageHide (页面分离)');
          callbacks.onPageHide?.call();
        }
        _wasResumed = false;
        _wasVisible = false;
        break;
      case AppLifecycleState.hidden:
        print('${context.widget.runtimeType} - onHide');
        callbacks.onHide?.call();
        if (_wasVisible) {
          print('${context.widget.runtimeType} - onPageHide (页面隐藏)');
          callbacks.onPageHide?.call();
        }
        _wasResumed = false;
        _wasVisible = false;
        break;
    }
  }
} 