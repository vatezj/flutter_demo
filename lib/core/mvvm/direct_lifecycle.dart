import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_demo/core/mvvm/tab_view_model.dart';

/// 直接生命周期管理 Hook
/// 使用 Navigator 事件监听，能够正确处理所有路由变化
class DirectLifecycleHook {
  static void useDirectLifecycle({
    required String pageName,
    VoidCallback? onPageShow,
    VoidCallback? onPageHide,
    VoidCallback? onInit,
    VoidCallback? onDispose,
    VoidCallback? onResume,
    VoidCallback? onInactive,
    VoidCallback? onHide,
    VoidCallback? onShow,
    VoidCallback? onPause,
    VoidCallback? onRestart,
    VoidCallback? onDetach,
  }) {
    final context = useContext();
    final mounted = useIsMounted();
    final hasShown = useRef(false);
    final isTabPage = useRef<bool?>(null);
    final lastRouteName = useRef<String?>(null);
    final isCurrentlyVisible = useRef(true);
    
    // 页面初始化
    useEffect(() {
      print('$pageName - 页面初始化');
      onInit?.call();
      
      return () {
        print('$pageName - 页面销毁');
        onDispose?.call();
      };
    }, []);

    // 应用生命周期监听
    useEffect(() {
      final observer = _DirectLifecycleObserver(
        context: context,
        pageName: pageName,
        callbacks: _DirectLifecycleCallbacks(
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

    // 页面可见性管理和路由监听
    useEffect(() {
      // 页面初始化时触发显示
      if (!hasShown.value) {
        hasShown.value = true;
        print('$pageName - 页面首次显示');
        onPageShow?.call();
      }
      
      // 检测页面类型
      Future.microtask(() {
        final routeName = ModalRoute.of(context)?.settings.name;
        final isTab = TabRoute.isTabRoute(routeName ?? '');
        isTabPage.value = isTab;
        lastRouteName.value = routeName;
        
        print('$pageName - 页面类型检测: ${isTab ? "Tab页面" : "普通页面"}');
        
        // 如果是 Tab 页面，注册 Tab 回调
        if (isTab) {
          TabViewModel.registerPageCallbacks(pageName,
            onPageShow: () {
              if (hasShown.value) {
                print('$pageName - Tab 页面显示（从其他Tab切换过来）');
                onPageShow?.call();
              }
            },
            onPageHide: () {
              print('$pageName - Tab 页面隐藏（切换到其他Tab）');
              onPageHide?.call();
            },
          );
        }
      });
      
      // 直接路由监听
      Timer? timer;
      timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
        if (mounted()) {
          final currentRoute = ModalRoute.of(context);
          final currentRouteName = currentRoute?.settings.name;
          final isCurrent = currentRoute?.isCurrent ?? false;
          
          // 检查路由状态变化
          if (isCurrent && !isCurrentlyVisible.value) {
            // 页面重新变为可见
            print('$pageName - 页面重新变为可见 (路由: $currentRouteName)');
            isCurrentlyVisible.value = true;
            onPageShow?.call();
          } else if (!isCurrent && isCurrentlyVisible.value) {
            // 页面变为不可见
            print('$pageName - 页面变为不可见 (路由: $currentRouteName)');
            isCurrentlyVisible.value = false;
            onPageHide?.call();
          }
          
          // 更新路由名称
          if (currentRouteName != lastRouteName.value) {
            print('$pageName - 路由名称变化: ${lastRouteName.value} -> $currentRouteName');
            lastRouteName.value = currentRouteName;
          }
        } else {
          timer.cancel();
        }
      });
      
      return () {
        timer?.cancel();
        // 如果是 Tab 页面，注销回调
        if (isTabPage.value == true) {
          TabViewModel.unregisterPageCallbacks(pageName);
        }
      };
    }, []);
  }
}

/// 直接生命周期回调
class _DirectLifecycleCallbacks {
  final VoidCallback? onResume;
  final VoidCallback? onInactive;
  final VoidCallback? onHide;
  final VoidCallback? onShow;
  final VoidCallback? onPause;
  final VoidCallback? onRestart;
  final VoidCallback? onDetach;

  const _DirectLifecycleCallbacks({
    this.onResume,
    this.onInactive,
    this.onHide,
    this.onShow,
    this.onPause,
    this.onRestart,
    this.onDetach,
  });
}

/// 直接生命周期观察者
class _DirectLifecycleObserver extends WidgetsBindingObserver {
  final BuildContext context;
  final String pageName;
  final _DirectLifecycleCallbacks callbacks;
  bool _wasResumed = true;

  _DirectLifecycleObserver({
    required this.context,
    required this.pageName,
    required this.callbacks,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        print('$pageName - 应用恢复 (onResume)');
        callbacks.onResume?.call();
        if (!_wasResumed) {
          print('$pageName - 应用从后台恢复 (onShow)');
          callbacks.onShow?.call();
        }
        _wasResumed = true;
        break;
      case AppLifecycleState.inactive:
        print('$pageName - 应用变为非活跃 (onInactive)');
        callbacks.onInactive?.call();
        break;
      case AppLifecycleState.paused:
        print('$pageName - 应用暂停 (onPause)');
        callbacks.onPause?.call();
        _wasResumed = false;
        break;
      case AppLifecycleState.detached:
        print('$pageName - 应用分离 (onDetach)');
        callbacks.onDetach?.call();
        _wasResumed = false;
        break;
      case AppLifecycleState.hidden:
        print('$pageName - 应用隐藏 (onHide)');
        callbacks.onHide?.call();
        _wasResumed = false;
        break;
    }
  }
} 