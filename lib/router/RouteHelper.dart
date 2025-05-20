import 'package:flutter/material.dart';

class RouteHelper {
  /// 辅助方法，将类名转换成字符串（本义还是使用字符串，不过换了一种方式）
  static String typeName(Type type) => type.toString();
  
  /// 路由类型转换辅助方式
  static Map<String, WidgetBuilder> routeDefine(Map<Type, WidgetBuilder> defines) {
   final target = <String, WidgetBuilder> {};
    defines.forEach((key, value) => target[ typeName(key) ] = value);
    return target;
  }
}