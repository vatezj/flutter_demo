# Flutter 路由系统使用指南

## 概述

这是一个基于 Flutter 的现代化路由系统，提供了类型安全的路由跳转、中间件支持、参数传递等功能。

## 主要特性

- ✅ 类型安全的路由跳转
- ✅ 中间件系统支持
- ✅ 参数传递和返回
- ✅ 链式调用支持
- ✅ 路由栈管理
- ✅ 权限验证
- ✅ 日志记录

## 基本使用

### 1. 路由跳转

```dart
// 基本跳转
context.navigateTo(MyPage);

// 带参数跳转
context.navigateTo(
  MyPage,
  arguments: PageArgs(id: 1, name: '测试'),
);

// 等待返回结果
final result = await context.navigateTo<Map<String, dynamic>>(
  MyPage,
  arguments: PageArgs(id: 1, name: '测试'),
);
```

### 2. 不同类型的跳转

```dart
// 保留当前页面，跳转到新页面
context.navigateTo(MyPage);

// 关闭当前页面，跳转到新页面
context.redirectTo(MyPage);

// 关闭所有页面，跳转到新页面
context.reLaunch(MyPage);

// 返回上一页面
context.navigateBack();

// 返回并传递结果
context.navigateBack({'status': 'success'});
```

### 3. 链式调用

```dart
// 链式调用方式
context.routeOf<MyPage>()
  .arguments(PageArgs(id: 1, name: '测试'))
  .to();
```

### 4. 获取路由参数

```dart
class MyPage extends StatefulWidget with RouterBridge<PageArgs> {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  PageArgs? _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args = widget.argumentOf(context);
  }
}
```

## 中间件系统

### 1. 创建自定义中间件

```dart
class CustomMiddleware extends RouteMiddleware {
  @override
  int get priority => 75;
  
  @override
  String get name => 'CustomMiddleware';

  @override
  Future<bool> handle(BuildContext context, RouteSettings settings) async {
    // 你的中间件逻辑
    print('执行自定义中间件: ${settings.name}');
    return true; // 返回 true 继续执行，false 中断路由
  }
}
```

### 2. 注册中间件

```dart
// 在应用启动时注册
CoreRouter.middlewareManager.register(CustomMiddleware());
```

### 3. 内置中间件

- **LoggingMiddleware**: 日志记录中间件
- **AuthMiddleware**: 权限验证中间件

## 路由栈管理

### 1. 获取路由栈信息

```dart
final stack = context.getRouteStack();
for (final route in stack) {
  print('路由: ${route.name}, 是否当前: ${route.isCurrent}');
}
```

### 2. 打印路由栈

```dart
CoreRouter.printRouteStack(context);
```

## 错误处理

路由系统提供了完善的错误处理机制：

- 路由不存在时会抛出 `ArgumentError`
- 中间件执行出错时会记录错误日志
- 链式调用状态错误时会抛出 `StateError`

## 最佳实践

1. **类型安全**: 始终使用泛型来确保类型安全
2. **参数传递**: 使用强类型的参数对象而不是 Map
3. **中间件**: 合理设置中间件优先级
4. **错误处理**: 在路由跳转时添加适当的错误处理
5. **日志**: 利用内置的日志中间件进行调试

## 示例代码

完整的示例代码请参考 `lib/pages/` 目录下的页面文件。
