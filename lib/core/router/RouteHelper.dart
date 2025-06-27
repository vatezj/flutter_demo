import 'package:flutter/material.dart';

/// 路由助手类
class RouteHelper {
  /// 辅助方法，将类名转换成字符串
  static String typeName(Type type) => type.toString();
  
  /// 路由类型转换辅助方式
  static Map<String, WidgetBuilder> routeDefine(Map<Type, WidgetBuilder> defines) {
    final target = <String, WidgetBuilder>{};
    defines.forEach((key, value) => target[typeName(key)] = value);
    return target;
  }
  
  /// 验证路由名称是否有效
  static bool isValidRouteName(String routeName) {
    return routeName.isNotEmpty && routeName != 'null';
  }
  
  /// 从路由名称获取类型
  static Type? getTypeFromName(String routeName, Map<Type, WidgetBuilder> routes) {
    for (final entry in routes.entries) {
      if (typeName(entry.key) == routeName) {
        return entry.key;
      }
    }
    return null;
  }
  
  /// 获取路由名称列表
  static List<String> getRouteNames(Map<Type, WidgetBuilder> routes) {
    return routes.keys.map((type) => typeName(type)).toList();
  }
  
  /// 检查路由是否存在
  static bool hasRoute(Type routeType, Map<Type, WidgetBuilder> routes) {
    return routes.containsKey(routeType);
  }
  
  /// 检查路由名称是否存在
  static bool hasRouteName(String routeName, Map<Type, WidgetBuilder> routes) {
    return routes.keys.any((type) => typeName(type) == routeName);
  }
}