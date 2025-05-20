# Flutter 路由系统

一个优雅的 Flutter 路由系统，支持参数传递、返回值处理、中间件拦截等功能。

## 功能特点

- 类型安全的路由参数传递
- 支持页面返回值处理
- 中间件系统（支持权限验证等）
- 路由白名单
- 页面栈管理
- 支持多种导航方式（push、replace、reLaunch）

## 基本使用

### 1. 页面定义

```dart
// 定义页面参数类
class PageArgs {
  final int id;
  final String name;

  PageArgs({this.id = 0, this.name = ''});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

// 页面类
class MyPage extends StatefulWidget with RouterBridge<PageArgs> {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  PageArgs? _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 获取路由参数
    _args = widget.argumentOf(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我的页面')),
      body: Center(
        child: Column(
          children: [
            Text('接收到的ID: ${_args?.id ?? '无'}'),
            Text('接收到的名称: ${_args?.name ?? '无'}'),
            ElevatedButton(
              onPressed: () {
                // 返回结果
                context.navigateBack<Map<String, dynamic>>({
                  'status': 'success',
                  'message': '操作成功',
                  'data': _args?.toJson(),
                });
              },
              child: Text('确认并返回'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 2. 路由注册

```dart
void main() {
  // 注册路由
  MyRouter.ROUTES.addAll({
    '/login': (_) => LoginPage(),
    '/home': (_) => HomePage(),
    '/my': (_) => MyPage(),
  });

  // 注册中间件
  MyRouter.middlewareManager.register(AuthMiddleware());

  runApp(const MyApp());
}
```

### 3. 导航方法

```dart
// 1. 普通导航
context.navigateTo(
  MyPage,
  arguments: PageArgs(id: 1, name: '测试'),
);

// 2. 导航并等待结果
final result = await context.navigateTo<Map<String, dynamic>>(
  MyPage,
  arguments: PageArgs(id: 1, name: '测试'),
);

if (result != null) {
  print('返回状态: ${result['status']}');
  print('返回消息: ${result['message']}');
  if (result['data'] != null) {
    print('返回数据: ${result['data']}');
  }
}

// 3. 重定向（替换当前页面）
context.redirectTo<Map<String, dynamic>, void>(
  MyPage,
  arguments: PageArgs(id: 1, name: '测试'),
);

// 4. 重新启动（清除所有页面）
context.reLaunch(
  MyPage,
  arguments: PageArgs(id: 1, name: '测试'),
);

// 5. 返回上一页
context.navigateBack();

// 6. 返回上一页并传递结果
context.navigateBack<Map<String, dynamic>>({
  'status': 'success',
  'message': '操作成功',
  'data': {'id': 1, 'name': '测试'},
});
```

### 4. 中间件使用

```dart
// 1. 创建中间件
class AuthMiddleware extends RouteMiddleware {
  @override
  int get priority => 100;

  @override
  Future<bool> handle(BuildContext context, RouteSettings settings) async {
    // 检查是否在白名单中
    if (_isInWhitelist(settings)) {
      return true;
    }

    // 权限验证
    final bool isAuthenticated = await _checkAuth();
    if (!isAuthenticated) {
      context.navigateTo(LoginPage);
      return false;
    }
    return true;
  }

  // 白名单检查
  bool _isInWhitelist(RouteSettings settings) {
    return _whitelist.contains(settings.name) ||
           _whitelistTypes.contains(settings.arguments as Type);
  }
}

// 2. 注册中间件
MyRouter.middlewareManager.register(AuthMiddleware());
```

### 5. 页面栈管理

```dart
// 1. 获取页面栈
final stack = MyRouter.getRouteStack(context);

// 2. 打印页面栈信息
MyRouter.printRouteStack(context);
// 输出示例：
// 当前页面栈信息：
// [0] IndexPage (首页)
// [1] MyPage (当前)
//     参数: {id: 1, name: 测试}
```

## 最佳实践

1. 参数传递：
   - 使用专门的参数类，而不是直接传递 Map
   - 实现 toJson 方法，方便序列化
   - 使用泛型确保类型安全

2. 返回值处理：
   - 使用 Map 作为返回值，包含状态、消息和数据
   - 在接收方进行类型转换和空值处理
   - 使用泛型指定返回值类型

3. 中间件使用：
   - 合理设置中间件优先级
   - 使用白名单避免循环跳转
   - 在中间件中处理全局逻辑

4. 页面栈管理：
   - 在关键操作前检查页面栈
   - 使用打印方法调试导航问题
   - 注意页面栈的清理时机

## 注意事项

1. 路由名称：
   - 使用 RouteHelper.typeName 获取类型名称
   - 确保路由名称唯一
   - 避免使用硬编码的路由名称

2. 参数传递：
   - 参数类应该是不可变的
   - 提供默认值处理空值情况
   - 注意参数的类型安全

3. 中间件：
   - 中间件应该是无状态的
   - 避免在中间件中执行耗时操作
   - 合理使用白名单机制

4. 页面栈：
   - 注意页面栈的深度
   - 及时清理不需要的页面
   - 避免页面栈过深导致性能问题
