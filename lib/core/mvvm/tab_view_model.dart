import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tab 页面路由配置
class TabRoute {
  static const String indexPage = 'IndexPage';
  static const String categoryPage = 'CategoryPage';
  static const String cartPage = 'CartPage';
  static const String myPage = 'MyPage';

  static const List<String> tabRoutes = [
    indexPage,
    categoryPage,
    cartPage,
    myPage,
  ];

  /// 检查是否为 Tab 路由
  static bool isTabRoute(String route) {
    return tabRoutes.contains(route);
  }

  /// 根据索引获取路由名称
  static String getRouteFromIndex(int index) {
    if (index >= 0 && index < tabRoutes.length) {
      return tabRoutes[index];
    }
    return indexPage;
  }

  /// 根据路由名称获取索引
  static int getIndexFromRoute(String route) {
    return tabRoutes.indexOf(route);
  }
}

/// Tab 状态类
class TabState {
  final int currentIndex;
  final String currentRoute;
  final bool isInitialized;

  const TabState({
    required this.currentIndex,
    required this.currentRoute,
    this.isInitialized = false,
  });

  factory TabState.initial() => const TabState(
        currentIndex: 0,
        currentRoute: TabRoute.indexPage,
      );

  TabState copyWith({
    int? currentIndex,
    String? currentRoute,
    bool? isInitialized,
  }) {
    return TabState(
      currentIndex: currentIndex ?? this.currentIndex,
      currentRoute: currentRoute ?? this.currentRoute,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TabState &&
        other.currentIndex == currentIndex &&
        other.currentRoute == currentRoute &&
        other.isInitialized == isInitialized;
  }

  @override
  int get hashCode => currentIndex.hashCode ^ currentRoute.hashCode ^ isInitialized.hashCode;
}

/// Tab ViewModel
class TabViewModel extends StateNotifier<TabState> {
  TabViewModel() : super(TabState.initial());

  /// 切换到指定索引的 Tab
  void switchTab(int index) {
    if (index >= 0 && index < TabRoute.tabRoutes.length) {
      final route = TabRoute.getRouteFromIndex(index);
      state = state.copyWith(
        currentIndex: index,
        currentRoute: route,
        isInitialized: true,
      );
      debugPrint('TabViewModel: 切换到 Tab $index - $route');
    }
  }

  /// 切换到指定路由的 Tab
  void switchToRoute(String route) {
    final index = TabRoute.getIndexFromRoute(route);
    if (index >= 0) {
      switchTab(index);
    }
  }

  /// 重置状态
  void reset() {
    state = TabState.initial();
  }

  /// 初始化 Tab
  void initialize(String? initialRoute) {
    final route = initialRoute ?? TabRoute.indexPage;
    final index = TabRoute.getIndexFromRoute(route);
    state = state.copyWith(
      currentIndex: index,
      currentRoute: route,
      isInitialized: true,
    );
    debugPrint('TabViewModel: 初始化 Tab $index - $route');
  }
}

/// Tab ViewModel Provider
final tabViewModelProvider = StateNotifierProvider<TabViewModel, TabState>((ref) {
  return TabViewModel();
});

/// Tab 状态 Provider
final tabStateProvider = Provider<TabState>((ref) {
  return ref.watch(tabViewModelProvider);
});

/// 当前 Tab 索引 Provider
final currentTabIndexProvider = Provider<int>((ref) {
  return ref.watch(tabStateProvider).currentIndex;
});

/// 当前 Tab 路由 Provider
final currentTabRouteProvider = Provider<String>((ref) {
  return ref.watch(tabStateProvider).currentRoute;
}); 