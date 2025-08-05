# MVVM 架构模块

## 📁 模块结构

```
lib/core/mvvm/
├── base_view_model.dart      # 基础 ViewModel 类
├── tab_view_model.dart       # Tab 状态管理
├── page_lifecycle.dart       # 页面生命周期管理
├── hook_lifecycle.dart       # Hook 生命周期管理
└── README.md                 # 本文档
```

## 🏗️ 架构设计

### 1. 基础类

#### BaseState
```dart
abstract class BaseState {
  final bool isLoading;
  final String? errorMessage;

  const BaseState({
    this.isLoading = false,
    this.errorMessage,
  });

  BaseState copyWith({
    bool? isLoading,
    String? errorMessage,
  });
}
```

#### BaseRiverpodViewModel
```dart
abstract class BaseRiverpodViewModel extends StateNotifier<BaseState> {
  BaseRiverpodViewModel(BaseState initialState) : super(initialState);

  // 通用方法
  void setLoading(bool loading);
  void setError(String? error);
  void clearError();
  Future<void> safeAsync(Future<void> Function() action);
}
```

### 2. 现有实现

#### TabViewModel
- **TabState**: Tab 状态管理
- **TabViewModel**: Tab 切换逻辑
- **TabRoute**: Tab 路由配置

### 3. 生命周期管理

#### PageLifecycleMixin (StatefulWidget)
```dart
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with PageLifecycleMixin {
  @override
  PageLifecycleCallbacks get lifecycleCallbacks => const PageLifecycleCallbacks(
    onResume: _onResume,
    onPause: _onPause,
    onHide: _onHide,
    onShow: _onShow,
    onInactive: _onInactive,
    onDetach: _onDetach,
  );

  static void _onResume() {
    print('页面恢复');
  }

  static void _onPause() {
    print('页面暂停');
  }

  // ... 其他回调方法
}
```

#### LifecycleHook (HookConsumerWidget)
```dart
class MyPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 页面生命周期管理
    LifecycleHook.usePageLifecycle(
      onResume: () {
        print('-------------------------页面 onResume');
        // 页面恢复时的逻辑
      },
      onInactive: () {
        print('-------------------------页面 onInactive');
        // 页面变为非活跃时的逻辑
      },
      onHide: () {
        print('-------------------------页面 onHide');
        // 页面隐藏时的逻辑
      },
      onShow: () {
        print('-------------------------页面 onShow');
        // 页面显示时的逻辑
      },
      onPause: () {
        print('-------------------------页面 onPause');
        // 页面暂停时的逻辑
      },
      onRestart: () {
        print('-------------------------页面 onRestart');
        // 页面重启时的逻辑
      },
      onDetach: () {
        print('-------------------------页面 onDetach');
        // 页面分离时的逻辑
      },
      onInit: () {
        print('-------------------------页面 onInit');
        // 页面初始化时的逻辑
      },
      onDispose: () {
        print('-------------------------页面 onDispose');
        // 页面销毁时的逻辑
      },
    );

    return Scaffold(
      // 页面内容
    );
  }
}
```

## 🚀 新建功能 MVVM 指南

### 步骤 1: 定义状态类

```dart
// lib/pages/feature/feature_state.dart
import 'package:flutter_demo/core/mvvm/base_view_model.dart';

class FeatureState extends BaseState {
  final int counter;
  final List<String> items;
  final String? selectedItem;

  const FeatureState({
    super.isLoading = false,
    super.errorMessage,
    this.counter = 0,
    this.items = const [],
    this.selectedItem,
  });

  @override
  FeatureState copyWith({
    bool? isLoading,
    String? errorMessage,
    int? counter,
    List<String>? items,
    String? selectedItem,
  }) {
    return FeatureState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      counter: counter ?? this.counter,
      items: items ?? this.items,
      selectedItem: selectedItem ?? this.selectedItem,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeatureState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.counter == counter &&
        other.items == items &&
        other.selectedItem == selectedItem;
  }

  @override
  int get hashCode {
    return Object.hash(
      isLoading,
      errorMessage,
      counter,
      items,
      selectedItem,
    );
  }
}
```

### 步骤 2: 创建 ViewModel

```dart
// lib/pages/feature/feature_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/core/mvvm/base_view_model.dart';
import 'feature_state.dart';

class FeatureViewModel extends BaseRiverpodViewModel {
  FeatureViewModel() : super(FeatureState.initial());

  // 业务方法
  void incrementCounter() {
    state = state.copyWith(counter: state.counter + 1);
  }

  void decrementCounter() {
    if (state.counter > 0) {
      state = state.copyWith(counter: state.counter - 1);
    }
  }

  void addItem(String item) {
    final newItems = List<String>.from(state.items)..add(item);
    state = state.copyWith(items: newItems);
  }

  void removeItem(String item) {
    final newItems = List<String>.from(state.items)..remove(item);
    state = state.copyWith(items: newItems);
  }

  void selectItem(String? item) {
    state = state.copyWith(selectedItem: item);
  }

  // 异步操作示例
  Future<void> loadData() async {
    await safeAsync(() async {
      setLoading(true);
      
      try {
        // 模拟网络请求
        await Future.delayed(const Duration(seconds: 2));
        
        final items = ['项目1', '项目2', '项目3', '项目4'];
        state = state.copyWith(items: items);
        
        clearError();
      } catch (e) {
        setError('加载数据失败: $e');
      } finally {
        setLoading(false);
      }
    });
  }

  // 重置状态
  void reset() {
    state = FeatureState.initial();
  }
}
```

### 步骤 3: 定义 Provider

```dart
// lib/pages/feature/feature_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'feature_view_model.dart';
import 'feature_state.dart';

// ViewModel Provider
final featureViewModelProvider = StateNotifierProvider<FeatureViewModel, FeatureState>((ref) {
  return FeatureViewModel();
});

// 状态 Provider
final featureStateProvider = Provider<FeatureState>((ref) {
  return ref.watch(featureViewModelProvider);
});

// 特定状态 Provider
final featureCounterProvider = Provider<int>((ref) {
  return ref.watch(featureStateProvider).counter;
});

final featureItemsProvider = Provider<List<String>>((ref) {
  return ref.watch(featureStateProvider).items;
});

final featureSelectedItemProvider = Provider<String?>((ref) {
  return ref.watch(featureStateProvider).selectedItem;
});

final featureIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(featureStateProvider).isLoading;
});
```

### 步骤 4: 创建页面

```dart
// lib/pages/feature/feature_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_demo/core/mvvm/hook_lifecycle.dart';
import 'feature_providers.dart';

class FeaturePage extends HookConsumerWidget {
  const FeaturePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听状态
    final featureState = ref.watch(featureStateProvider);
    final featureViewModel = ref.read(featureViewModelProvider.notifier);
    
    // 本地状态
    final textController = useTextEditingController();
    final selectedIndex = useState<int?>(null);

    // 页面生命周期管理
    LifecycleHook.usePageLifecycle(
      onResume: () {
        print('-------------------------功能页面 onResume');
        // 页面恢复时的逻辑
      },
      onInactive: () {
        print('-------------------------功能页面 onInactive');
        // 页面变为非活跃时的逻辑
      },
      onHide: () {
        print('-------------------------功能页面 onHide');
        // 页面隐藏时的逻辑
      },
      onShow: () {
        print('-------------------------功能页面 onShow');
        // 页面显示时的逻辑
      },
      onPause: () {
        print('-------------------------功能页面 onPause');
        // 页面暂停时的逻辑
      },
      onRestart: () {
        print('-------------------------功能页面 onRestart');
        // 页面重启时的逻辑
      },
      onDetach: () {
        print('-------------------------功能页面 onDetach');
        // 页面分离时的逻辑
      },
      onInit: () {
        print('-------------------------功能页面 onInit');
        // 页面初始化时的逻辑
      },
      onDispose: () {
        print('-------------------------功能页面 onDispose');
        // 页面销毁时的逻辑
      },
    );

    // 副作用 - 页面初始化
    useEffect(() {
      // 加载初始数据
      featureViewModel.loadData();
      return null;
    }, []);

    // 副作用 - 监听选中项变化
    useEffect(() {
      if (featureState.selectedItem != null) {
        final index = featureState.items.indexOf(featureState.selectedItem!);
        selectedIndex.value = index >= 0 ? index : null;
      }
      return null;
    }, [featureState.selectedItem]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('功能页面'),
        actions: [
          IconButton(
            onPressed: featureViewModel.reset,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 计数器部分
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '计数器: ${featureState.counter}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: featureViewModel.decrementCounter,
                          child: const Text('-'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: featureViewModel.incrementCounter,
                          child: const Text('+'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 添加项目部分
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '添加项目',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textController,
                            decoration: const InputDecoration(
                              hintText: '输入项目名称',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (textController.text.isNotEmpty) {
                              featureViewModel.addItem(textController.text);
                              textController.clear();
                            }
                          },
                          child: const Text('添加'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 项目列表部分
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '项目列表 (${featureState.items.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      if (featureState.isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (featureState.items.isEmpty)
                        const Center(
                          child: Text('暂无项目'),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: featureState.items.length,
                            itemBuilder: (context, index) {
                              final item = featureState.items[index];
                              final isSelected = selectedIndex.value == index;
                              
                              return ListTile(
                                title: Text(item),
                                leading: Icon(
                                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                                  color: isSelected ? Colors.green : null,
                                ),
                                trailing: IconButton(
                                  onPressed: () => featureViewModel.removeItem(item),
                                  icon: const Icon(Icons.delete),
                                ),
                                onTap: () => featureViewModel.selectItem(item),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 步骤 5: 错误处理

```dart
// 在页面中添加错误显示
if (featureState.errorMessage != null)
  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.red.shade100,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(Icons.error, color: Colors.red.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            featureState.errorMessage!,
            style: TextStyle(color: Colors.red.shade700),
          ),
        ),
        IconButton(
          onPressed: featureViewModel.clearError,
          icon: Icon(Icons.close, color: Colors.red.shade700),
        ),
      ],
    ),
  ),
```

## 📋 完整示例模板

### 1. 状态类模板
```dart
class YourFeatureState extends BaseState {
  // 添加你的状态属性
  final String title;
  final List<dynamic> data;
  
  const YourFeatureState({
    super.isLoading = false,
    super.errorMessage,
    this.title = '',
    this.data = const [],
  });

  @override
  YourFeatureState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? title,
    List<dynamic>? data,
  }) {
    return YourFeatureState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      title: title ?? this.title,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YourFeatureState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.title == title &&
        other.data == data;
  }

  @override
  int get hashCode {
    return Object.hash(isLoading, errorMessage, title, data);
  }
}
```

### 2. ViewModel 模板
```dart
class YourFeatureViewModel extends BaseRiverpodViewModel {
  YourFeatureViewModel() : super(YourFeatureState.initial());

  // 同步方法
  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void addData(dynamic item) {
    final newData = List<dynamic>.from(state.data)..add(item);
    state = state.copyWith(data: newData);
  }

  // 异步方法
  Future<void> loadData() async {
    await safeAsync(() async {
      setLoading(true);
      try {
        // 你的异步逻辑
        await Future.delayed(const Duration(seconds: 1));
        state = state.copyWith(data: ['数据1', '数据2']);
        clearError();
      } catch (e) {
        setError('加载失败: $e');
      } finally {
        setLoading(false);
      }
    });
  }
}
```

### 3. Provider 模板
```dart
final yourFeatureViewModelProvider = StateNotifierProvider<YourFeatureViewModel, YourFeatureState>((ref) {
  return YourFeatureViewModel();
});

final yourFeatureStateProvider = Provider<YourFeatureState>((ref) {
  return ref.watch(yourFeatureViewModelProvider);
});
```

### 4. 页面模板
```dart
class YourFeaturePage extends HookConsumerWidget {
  const YourFeaturePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(yourFeatureStateProvider);
    final viewModel = ref.read(yourFeatureViewModelProvider.notifier);

    useEffect(() {
      viewModel.loadData();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: Text(state.title)),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(state.data[index].toString()));
              },
            ),
    );
  }
}
```

## 🎯 最佳实践

### 1. 状态设计
- ✅ 使用不可变状态
- ✅ 实现 `copyWith` 方法
- ✅ 重写 `==` 和 `hashCode`
- ✅ 继承 `BaseState` 获得通用功能

### 2. ViewModel 设计
- ✅ 继承 `BaseRiverpodViewModel`
- ✅ 使用 `safeAsync` 包装异步操作
- ✅ 提供清晰的业务方法
- ✅ 使用 `setLoading`、`setError`、`clearError`

### 3. Provider 设计
- ✅ 使用 `StateNotifierProvider` 定义 ViewModel
- ✅ 使用 `Provider` 定义状态访问
- ✅ 为常用状态创建专门的 Provider

### 4. 页面设计
- ✅ 使用 `HookConsumerWidget`
- ✅ 使用 `ref.watch()` 监听状态
- ✅ 使用 `ref.read()` 调用方法
- ✅ 使用 `useEffect` 处理副作用
- ✅ 使用 `useState` 管理本地状态
- ✅ 使用 `LifecycleHook.usePageLifecycle()` 管理页面生命周期

### 5. 错误处理
- ✅ 在 UI 中显示错误信息
- ✅ 提供错误清除功能
- ✅ 使用 `safeAsync` 自动处理异常

## 🔧 工具方法

### BaseRiverpodViewModel 提供的工具方法

```dart
// 设置加载状态
setLoading(true);

// 设置错误信息
setError('操作失败');

// 清除错误信息
clearError();

// 安全异步操作
await safeAsync(() async {
  // 你的异步逻辑
});
```

## 📝 注意事项

1. **状态不可变性**: 始终使用 `copyWith` 更新状态
2. **Provider 命名**: 使用清晰的命名约定
3. **错误处理**: 始终处理异步操作的错误
4. **性能优化**: 使用 `useMemoized` 缓存计算结果
5. **生命周期**: 在 `useEffect` 中处理资源清理

---

通过遵循这个指南，你可以快速创建符合项目架构规范的新功能！ 