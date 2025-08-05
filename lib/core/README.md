# 核心模块结构

## 目录结构

```
lib/core/
├── config/           # 配置管理
│   └── app_config.dart
├── init/             # 应用初始化
│   └── app_init.dart
├── mvvm/             # MVVM 架构核心
│   ├── base_view_model.dart
│   └── tab_view_model.dart
├── router/           # 路由管理
│   ├── app_router.dart
│   ├── router.dart
│   ├── context_extension.dart
│   ├── middleware.dart
│   ├── route_helper.dart
│   └── README.md
└── network/          # 网络请求
    ├── api.dart
    ├── http.dart
    ├── interceptor.dart
    └── README.md
```

## 模块说明

### 1. 配置管理 (config/)
- **app_config.dart**: 应用级别的配置管理
  - 应用名称、主题、国际化等配置
  - 路由默认配置

### 2. 应用初始化 (init/)
- **app_init.dart**: 应用启动时的初始化逻辑
  - 中间件注册
  - 其他初始化操作

### 3. MVVM 架构核心 (mvvm/)
- **base_view_model.dart**: 基础 ViewModel 类
  - `BaseState`: 通用状态基类（isLoading, errorMessage）
  - `BaseRiverpodViewModel`: 基础 ViewModel 类，提供通用功能
- **tab_view_model.dart**: 底部导航栏状态管理
  - `TabRoute`: Tab 路由配置和工具方法
  - `TabState`: Tab 状态类
  - `TabViewModel`: Tab 状态管理 ViewModel
  - Riverpod Provider 定义

### 4. 路由管理 (router/)
- **app_router.dart**: 应用路由管理器
  - 统一的路由生成逻辑
  - tabs 页面和普通页面的区分
- **router.dart**: 核心路由引擎
  - 路由定义和注册
  - 路由跳转方法
  - 中间件管理
- **context_extension.dart**: 路由扩展方法
  - 为 BuildContext 添加路由方法
  - 支持链式调用
- **middleware.dart**: 中间件管理
  - 路由拦截和权限验证
- **route_helper.dart**: 路由助手工具
  - 类型名称转换
  - 路由定义辅助

### 5. 网络请求 (network/)
- **api.dart**: API 接口定义
- **http.dart**: HTTP 客户端
- **interceptor.dart**: 请求拦截器

## 使用方式

### 入口文件 (main.dart)
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/core/init/app_init.dart';
import 'package:flutter_demo/core/router/app_router.dart';
import 'package:flutter_demo/core/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppInit.init();
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: AppConfig.lightTheme,
      darkTheme: AppConfig.darkTheme,
      initialRoute: AppRouter.initialRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
```

### MVVM 状态管理使用
```dart
// 在 Widget 中使用 HookConsumerWidget
class HomePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听状态
    final homeState = ref.watch(homeStateProvider);
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    
    // 使用 Hooks 管理本地状态
    final localCounter = useState(0);
    
    return Text('计数: ${homeState.counter}');
  }
}

// 调用 ViewModel 方法
ElevatedButton(
  onPressed: homeViewModel.incrementCounter,
  child: const Text('增加计数'),
)
```

### 路由跳转
```dart
// Tab 切换（使用 ViewModel）
tabViewModel.switchToRoute('CategoryPage');

// 普通页面跳转
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const DetailsPage(),
    settings: RouteSettings(arguments: args),
  ),
);

// 带返回值的跳转
final result = await Navigator.push<Map<String, dynamic>>(
  context,
  MaterialPageRoute(...),
);
```

### 配置管理
```dart
// 获取应用名称
String appName = AppConfig.appName;

// 获取主题
ThemeData lightTheme = AppConfig.lightTheme;
ThemeData darkTheme = AppConfig.darkTheme;
```

## MVVM + Riverpod + Hooks 架构优势

### 1. 状态管理优势
- **集中状态管理**: 所有状态都在 ViewModel 中管理
- **响应式更新**: 状态变化时自动更新 UI
- **类型安全**: 使用 Provider 提供类型安全的状态访问
- **易于测试**: 状态逻辑与 UI 分离，便于单元测试
- **性能优化**: 只有依赖特定状态的 Widget 才会重建

### 2. Hooks 优势
- **简化状态管理**: 减少样板代码
- **生命周期管理**: 自动处理 Widget 生命周期
- **性能优化**: 提供记忆化和缓存功能
- **代码复用**: 逻辑可以在不同 Widget 间复用

### 3. 路由系统优势
- **类型安全**: 使用类型而不是字符串进行路由
- **中间件支持**: 支持权限验证等拦截功能
- **参数传递**: 类型安全的参数传递
- **返回值处理**: 支持页面间数据传递

## 最佳实践

### 1. ViewModel 设计
- 继承 `BaseRiverpodViewModel` 获得通用功能
- 使用 `copyWith` 方法更新状态
- 实现 `==` 和 `hashCode` 方法
- 提供清晰的业务方法

### 2. 状态管理
- 使用 `ref.watch()` 监听状态变化
- 使用 `ref.read()` 调用方法
- 在 `useEffect` 中使用 `Future.microtask()` 避免构建时修改状态
- 使用 `useMemoized()` 缓存计算结果

### 3. 路由管理
- 使用 `TabRoute.isTabRoute()` 判断是否为 Tab 页面
- 普通页面使用 `Navigator.push()`
- 参数传递使用 `RouteSettings.arguments`
- 使用 `RouteHelper.typeName()` 获取类型名称

### 4. 错误处理
- 在 ViewModel 中使用 `setError()` 设置错误状态
- 在 UI 中显示错误信息
- 使用 `clearError()` 清除错误状态
- 使用 `safeAsync()` 包装异步操作 