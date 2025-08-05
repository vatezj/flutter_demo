import 'package:flutter/material.dart';

/// 页面生命周期回调接口
class PageLifecycleCallbacks {
  final VoidCallback? onResume;
  final VoidCallback? onInactive;
  final VoidCallback? onHide;
  final VoidCallback? onShow;
  final VoidCallback? onPause;
  final VoidCallback? onRestart;
  final VoidCallback? onDetach;

  const PageLifecycleCallbacks({
    this.onResume,
    this.onInactive,
    this.onHide,
    this.onShow,
    this.onPause,
    this.onRestart,
    this.onDetach,
  });
}

/// 页面生命周期管理基类
abstract class PageLifecycleMixin<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver {
  /// 生命周期回调
  PageLifecycleCallbacks get lifecycleCallbacks;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print('${runtimeType} - initState');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print('${runtimeType} - dispose');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        print('${runtimeType} - onResume');
        lifecycleCallbacks.onResume?.call();
        break;
      case AppLifecycleState.inactive:
        print('${runtimeType} - onInactive');
        lifecycleCallbacks.onInactive?.call();
        break;
      case AppLifecycleState.paused:
        print('${runtimeType} - onPause');
        lifecycleCallbacks.onPause?.call();
        break;
      case AppLifecycleState.detached:
        print('${runtimeType} - onDetach');
        lifecycleCallbacks.onDetach?.call();
        break;
      case AppLifecycleState.hidden:
        print('${runtimeType} - onHide');
        lifecycleCallbacks.onHide?.call();
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('${runtimeType} - didChangeDependencies');
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('${runtimeType} - didUpdateWidget');
  }

  @override
  void reassemble() {
    super.reassemble();
    print('${runtimeType} - reassemble');
  }

  @override
  void deactivate() {
    print('${runtimeType} - deactivate');
    super.deactivate();
  }
}

/// 页面可见性管理
mixin PageVisibilityMixin<T extends StatefulWidget> on State<T> {
  bool _isVisible = false;

  bool get isVisible => _isVisible;

  @override
  void initState() {
    super.initState();
    _isVisible = true;
  }

  @override
  void dispose() {
    _isVisible = false;
    super.dispose();
  }

  /// 页面变为可见时调用
  void onPageShow() {
    if (!_isVisible) {
      _isVisible = true;
      print('${runtimeType} - onShow');
    }
  }

  /// 页面变为不可见时调用
  void onPageHide() {
    if (_isVisible) {
      _isVisible = false;
      print('${runtimeType} - onHide');
    }
  }
}

/// 生命周期管理工具类
class LifecycleManager {
  static final Map<String, List<VoidCallback>> _listeners = {};

  /// 添加生命周期监听器
  static void addListener(String pageName, VoidCallback callback) {
    _listeners[pageName] ??= [];
    _listeners[pageName]!.add(callback);
  }

  /// 移除生命周期监听器
  static void removeListener(String pageName, VoidCallback callback) {
    _listeners[pageName]?.remove(callback);
  }

  /// 通知所有监听器
  static void notifyListeners(String pageName) {
    _listeners[pageName]?.forEach((callback) => callback());
  }

  /// 清理指定页面的监听器
  static void clearListeners(String pageName) {
    _listeners.remove(pageName);
  }

  /// 清理所有监听器
  static void clearAllListeners() {
    _listeners.clear();
  }
} 