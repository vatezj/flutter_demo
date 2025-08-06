import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_demo/core/mvvm/direct_lifecycle.dart';

/// 公用 Layout 组件的生命周期回调
class LayoutLifecycleCallbacks {
  final VoidCallback? onInit;
  final VoidCallback? onDispose;
  final VoidCallback? onResume;
  final VoidCallback? onInactive;
  final VoidCallback? onHide;
  final VoidCallback? onShow;
  final VoidCallback? onPause;
  final VoidCallback? onRestart;
  final VoidCallback? onDetach;
  final VoidCallback? onPageShow;
  final VoidCallback? onPageHide;

  const LayoutLifecycleCallbacks({
    this.onInit,
    this.onDispose,
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

/// 公用 Layout 组件
class BaseLayout extends HookConsumerWidget {
  final Widget child;
  final String pageName;
  final LayoutLifecycleCallbacks? lifecycleCallbacks;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;

  const BaseLayout({
    Key? key,
    required this.child,
    required this.pageName,
    this.lifecycleCallbacks,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用直接生命周期管理
    DirectLifecycleHook.useDirectLifecycle(
      pageName: pageName,
      onInit: lifecycleCallbacks?.onInit,
      onDispose: lifecycleCallbacks?.onDispose,
      onResume: lifecycleCallbacks?.onResume,
      onInactive: lifecycleCallbacks?.onInactive,
      onHide: lifecycleCallbacks?.onHide,
      onShow: lifecycleCallbacks?.onShow,
      onPause: lifecycleCallbacks?.onPause,
      onRestart: lifecycleCallbacks?.onRestart,
      onDetach: lifecycleCallbacks?.onDetach,
      onPageShow: lifecycleCallbacks?.onPageShow,
      onPageHide: lifecycleCallbacks?.onPageHide,
    );

    return Scaffold(
      appBar: appBar,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: primary,
      drawerDragStartBehavior: drawerDragStartBehavior,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
    );
  }
}

/// 简化的 Layout 组件（无 AppBar）
class SimpleLayout extends HookConsumerWidget {
  final Widget child;
  final String pageName;
  final LayoutLifecycleCallbacks? lifecycleCallbacks;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;

  const SimpleLayout({
    Key? key,
    required this.child,
    required this.pageName,
    this.lifecycleCallbacks,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用直接生命周期管理
    DirectLifecycleHook.useDirectLifecycle(
      pageName: pageName,
      onInit: lifecycleCallbacks?.onInit,
      onDispose: lifecycleCallbacks?.onDispose,
      onResume: lifecycleCallbacks?.onResume,
      onInactive: lifecycleCallbacks?.onInactive,
      onHide: lifecycleCallbacks?.onHide,
      onShow: lifecycleCallbacks?.onShow,
      onPause: lifecycleCallbacks?.onPause,
      onRestart: lifecycleCallbacks?.onRestart,
      onDetach: lifecycleCallbacks?.onDetach,
      onPageShow: lifecycleCallbacks?.onPageShow,
      onPageHide: lifecycleCallbacks?.onPageHide,
    );

    return Scaffold(
      body: child,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}

/// 带 AppBar 的 Layout 组件
class AppBarLayout extends HookConsumerWidget {
  final Widget child;
  final String pageName;
  final LayoutLifecycleCallbacks? lifecycleCallbacks;
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool? resizeToAvoidBottomInset;

  const AppBarLayout({
    Key? key,
    required this.child,
    required this.pageName,
    this.lifecycleCallbacks,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.resizeToAvoidBottomInset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用直接生命周期管理
    DirectLifecycleHook.useDirectLifecycle(
      pageName: pageName,
      onInit: lifecycleCallbacks?.onInit,
      onDispose: lifecycleCallbacks?.onDispose,
      onResume: lifecycleCallbacks?.onResume,
      onInactive: lifecycleCallbacks?.onInactive,
      onHide: lifecycleCallbacks?.onHide,
      onShow: lifecycleCallbacks?.onShow,
      onPause: lifecycleCallbacks?.onPause,
      onRestart: lifecycleCallbacks?.onRestart,
      onDetach: lifecycleCallbacks?.onDetach,
      onPageShow: lifecycleCallbacks?.onPageShow,
      onPageHide: lifecycleCallbacks?.onPageHide,
    );

    return Scaffold(
      appBar: AppBar(
        title: title != null ? Text(title!) : null,
        actions: actions,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: elevation,
      ),
      body: child,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
} 