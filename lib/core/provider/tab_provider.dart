import 'package:flutter/material.dart';

/// 底部导航栏状态管理
class TabProvider extends ChangeNotifier {
  // 当前激活的tab索引
  int _currentIndex = 0;
  
  // 定义tabs页面路由名称
  static const Set<String> _tabRoutes = {
    'IndexPage',
    'CategoryPage',
    'CartPage',
    'MyPage',
  };

  /// 获取当前激活的tab索引
  int get currentIndex => _currentIndex;

  /// 获取所有tabs页面路由
  static Set<String> get tabRoutes => _tabRoutes;

  /// 根据路由名称获取tab索引
  int getIndexFromRoute(String route) {
    switch (route) {
      case 'IndexPage':
        return 0;
      case 'CategoryPage':
        return 1;
      case 'CartPage':
        return 2;
      case 'MyPage':
        return 3;
      default:
        return 0;
    }
  }

  /// 根据索引获取路由名称
  String getRouteFromIndex(int index) {
    switch (index) {
      case 0:
        return 'IndexPage';
      case 1:
        return 'CategoryPage';
      case 2:
        return 'CartPage';
      case 3:
        return 'MyPage';
      default:
        return 'IndexPage';
    }
  }

  /// 切换tab
  void switchTab(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      print('TabProvider: 切换到tab: ${getRouteFromIndex(index)}');
      notifyListeners();
    }
  }

  /// 重置TabProvider状态
  void reset() {
    _currentIndex = 0;
    print('TabProvider: 重置状态到首页');
    notifyListeners();
  }

  /// 根据路由名称切换tab
  void switchTabByRoute(String route) {
    final index = getIndexFromRoute(route);
    switchTab(index);
  }

  /// 检查是否是tabs页面
  static bool isTabRoute(String routeName) {
    return _tabRoutes.contains(routeName);
  }
} 