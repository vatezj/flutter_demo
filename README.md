# Flutter Demo - MVVM + Riverpod + Hooks 架构

## 🏗️ 项目架构

本项目采用现代化的 Flutter 架构模式：

- **MVVM (Model-View-ViewModel)**: 分离业务逻辑和 UI 层
- **Riverpod**: 响应式状态管理
- **Flutter Hooks**: 简化状态管理和生命周期
- **KeepAlive**: 页面状态保持

## 📁 项目结构

```
lib/
├── core/                    # 核心模块
│   ├── config/             # 配置管理
│   │   └── app_config.dart
│   ├── init/               # 应用初始化
│   │   └── app_init.dart
│   ├── mvvm/               # MVVM 架构核心
│   │   ├── base_view_model.dart
│   │   └── tab_view_model.dart
│   ├── network/            # 网络请求
│   │   ├── api.dart
│   │   ├── http.dart
│   │   └── interceptor.dart
│   └── router/             # 路由管理
│       ├── app_router.dart
│       ├── context_extension.dart
│       ├── middleware.dart
│       ├── route_helper.dart
│       └── router.dart
├── l10n/                   # 国际化
│   ├── app_en.arb
│   ├── app_zh.arb
│   └── gen/
├── pages/                  # 页面模块
│   ├── BottomMenuBarPage.dart
│   ├── home/               # 首页模块
│   │   ├── indexPage.dart
│   │   ├── details.dart
│   │   ├── info.dart
│   │   └── home_view_model.dart
│   ├── category/           # 分类模块
│   │   ├── categoryPage.dart
│   │   └── category_view_model.dart
│   ├── cart/               # 购物车模块
│   │   ├── cartPage.dart
│   │   └── cart_view_model.dart
│   ├── my/                 # 我的模块
│   │   ├── myPage.dart
│   │   └── my_view_model.dart
│   └── login/              # 登录模块
│       └── loginPage.dart
└── main.dart               # 应用入口
```

## 🚀 快速开始

### 环境要求

- Flutter 3.0.0+
- Dart 3.0.0+

### 安装依赖

```bash
flutter pub get
```

### 运行应用

```bash
flutter run
```

## 🏛️ 架构详解

### 1. MVVM 架构

#### BaseViewModel
```dart
abstract class BaseRiverpodViewModel extends StateNotifier<BaseState> {
  // 通用 ViewModel 功能
  void setLoading(bool loading);
  void setError(String? error);
  void clearError();
  Future<void> safeAsync(Future<void> Function() action);
}
```

#### 页面 ViewModel 示例
```dart
class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(HomeState.initial());

  void incrementCounter() {
    state = state.copyWith(counter: state.counter + 1);
  }
}
```

### 2. Riverpod 状态管理

#### Provider 定义
```dart
// ViewModel Provider
final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  return HomeViewModel();
});

// 状态 Provider
final homeStateProvider = Provider<HomeState>((ref) {
  return ref.watch(homeViewModelProvider);
});
```

#### 在 Widget 中使用
```dart
class HomePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeStateProvider);
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    
    return Text('计数: ${homeState.counter}');
  }
}
```

### 3. Flutter Hooks

#### 状态管理
```dart
// 本地状态
final counter = useState(0);
final isLoading = useState(false);

// 副作用
useEffect(() {
  // 初始化逻辑
  return () {
    // 清理逻辑
  };
}, []);

// 记忆化
final expensiveValue = useMemoized(() {
  return expensiveCalculation();
}, [dependencies]);
```

#### 生命周期管理
```dart
// 页面控制器
final pageController = usePageController();

// 动画控制器
final animationController = useAnimationController(
  duration: const Duration(milliseconds: 300),
);
```

## 📱 页面功能

### 1. 底部导航栏

- **首页**: 计数器测试、页面跳转
- **分类**: 分类列表管理
- **购物车**: 商品管理、数量调整
- **我的**: 用户信息、登录状态

### 2. KeepAlive 功能

所有 Tab 页面都包装在 `KeepAliveWrapper` 中，切换页面时状态保持：

```dart
class KeepAliveWrapper extends StatefulWidget {
  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
}
```

### 3. 路由系统

#### 路由配置
```dart
class AppRouter {
  static const String initialRoute = 'BottomMenuBarPage';
  
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // 路由生成逻辑
  }
}
```

#### 页面跳转
```dart
// Tab 切换
tabViewModel.switchToRoute('CategoryPage');

// 普通页面跳转
Navigator.push(context, MaterialPageRoute(...));

// 带参数跳转
Navigator.push(context, MaterialPageRoute(
  builder: (context) => const DetailsPage(),
  settings: RouteSettings(arguments: args),
));
```

## 🛠️ 开发指南

### 1. 创建新页面

1. **创建 ViewModel**:
```dart
class NewPageViewModel extends StateNotifier<NewPageState> {
  NewPageViewModel() : super(NewPageState.initial());
  
  void someAction() {
    // 业务逻辑
  }
}
```

2. **创建 Provider**:
```dart
final newPageViewModelProvider = StateNotifierProvider<NewPageViewModel, NewPageState>((ref) {
  return NewPageViewModel();
});
```

3. **创建页面**:
```dart
class NewPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(newPageStateProvider);
    final viewModel = ref.read(newPageViewModelProvider.notifier);
    
    return Scaffold(
      // UI 实现
    );
  }
}
```

### 2. 状态管理最佳实践

- 使用 `ref.watch()` 监听状态变化
- 使用 `ref.read()` 调用方法
- 在 `useEffect` 中使用 `Future.microtask()` 避免构建时修改状态
- 使用 `useMemoized()` 缓存计算结果

### 3. 路由管理

- Tab 页面使用 `TabRoute.isTabRoute()` 判断
- 普通页面使用 `Navigator.push()`
- 参数传递使用 `RouteSettings.arguments`

## 📦 依赖管理

### 主要依赖

```yaml
dependencies:
  flutter_riverpod: ^2.5.1      # 状态管理
  riverpod_annotation: ^2.3.5   # 代码生成注解
  flutter_hooks: ^0.20.5        # Hooks
  hooks_riverpod: ^2.5.1        # Hooks + Riverpod 集成
  dio: ^5.4.3                   # 网络请求
  shared_preferences: ^2.3.3    # 本地存储
```

### 开发依赖

```yaml
dev_dependencies:
  riverpod_generator: ^2.4.0    # 代码生成
  build_runner: ^2.4.13         # 构建工具
```

## 🔧 构建和部署

### 开发模式
```bash
flutter run --debug
```

### 生产构建
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 🧪 测试

### 单元测试
```bash
flutter test
```

### 集成测试
```bash
flutter test integration_test/
```

## 📄 许可证

MIT License

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

**注意**: 本项目采用现代化的 Flutter 架构，确保您使用的 Flutter 版本支持所有功能。
