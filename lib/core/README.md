# 核心模块结构

## 目录结构

```
lib/core/
├── config/           # 配置管理
│   └── app_config.dart
├── init/             # 应用初始化
│   └── app_init.dart
├── provider/         # 状态管理
│   ├── tab_provider.dart
│   └── app_providers.dart
├── router/           # 路由管理
│   ├── app_router.dart
│   ├── router.dart
│   ├── context_extension.dart
│   ├── middleware.dart
│   ├── RouteHelper.dart
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

### 3. 状态管理 (provider/)
- **tab_provider.dart**: 底部导航栏状态管理
  - 管理当前激活的tab索引
  - 提供tab切换方法
  - 路由名称和索引的转换
- **app_providers.dart**: 应用级别的Provider管理器
  - 统一管理所有Provider
  - 提供MultiProvider配置

### 4. 路由管理 (router/)
- **app_router.dart**: 应用路由管理器
  - 统一的路由生成逻辑
  - tabs页面和普通页面的区分
- **router.dart**: 核心路由引擎
- **context_extension.dart**: 路由扩展方法
- **middleware.dart**: 中间件管理

### 5. 网络请求 (network/)
- **api.dart**: API接口定义
- **http.dart**: HTTP客户端
- **interceptor.dart**: 请求拦截器

## 使用方式

### 入口文件 (main.dart)
```dart
import 'package:flutter/material.dart';
import 'package:flutter_demo/core/init/app_init.dart';
import 'package:flutter_demo/core/router/app_router.dart';
import 'package:flutter_demo/core/config/app_config.dart';
import 'package:flutter_demo/core/provider/app_providers.dart';

void main() {
  AppInit.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppProviders.getMultiProvider(
      child: MaterialApp(
        title: AppConfig.appName,
        theme: AppConfig.theme,
        initialRoute: AppConfig.initialRoute,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
```

### 状态管理使用
```dart
// 在Widget中使用Consumer监听状态变化
Consumer<TabProvider>(
  builder: (context, tabProvider, child) {
    return Text('当前tab: ${tabProvider.currentIndex}');
  },
)

// 在方法中读取状态
final tabProvider = context.read<TabProvider>();
tabProvider.switchTab(1);

// 切换tab
context.read<TabProvider>().switchTabByRoute('CategoryPage');
```

### 路由跳转
```dart
// 普通跳转（在tabs页面内部跳转，会显示底部导航栏）
context.navigateTo(SomePage);

// 跳转到非tabs页面（不显示底部导航栏）
context.navigateToNonTab(DetailsPage);

// 切换到tab页面（使用Provider状态管理）
context.switchTab(CategoryPage);
```

### 配置管理
```dart
// 获取应用名称
String appName = AppConfig.appName;

// 获取主题
ThemeData theme = AppConfig.theme;
```

## Provider 状态管理优势

1. **集中状态管理**: 所有tab相关状态都在 `TabProvider` 中
2. **响应式更新**: 状态变化时自动更新UI
3. **类型安全**: 使用Provider提供类型安全的状态访问
4. **易于测试**: 状态逻辑与UI分离，便于单元测试
5. **性能优化**: 只有依赖特定状态的Widget才会重建

## 优化说明

### 路由名称获取优化
- 使用 `RouteHelper.typeName()` 自动获取路由名称
- 无需手动定义每个路由的映射关系
- 支持任何页面类型，自动处理路由名称转换

### 状态管理优势

1. **集中状态管理**: 所有tab相关状态都在 `TabProvider` 中
2. **响应式更新**: 状态变化时自动更新UI
3. **类型安全**: 使用Provider提供类型安全的状态访问
4. **易于测试**: 状态逻辑与UI分离，便于单元测试
5. **性能优化**: 只有依赖特定状态的Widget才会重建 