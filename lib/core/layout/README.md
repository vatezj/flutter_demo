# 公用 Layout 组件

这个目录包含了公用的 Layout 组件，它们内置了生命周期管理功能，可以简化页面的开发。

## 组件说明

### 1. BaseLayout - 完整布局组件
最灵活的布局组件，支持所有 Scaffold 的属性。

```dart
BaseLayout(
  pageName: '页面名称',
  appBar: AppBar(title: Text('标题')),
  drawer: Drawer(child: ...),
  floatingActionButton: FloatingActionButton(...),
  lifecycleCallbacks: LayoutLifecycleCallbacks(
    onInit: () => print('页面初始化'),
    onPageShow: () => print('页面显示'),
    onPageHide: () => print('页面隐藏'),
    // ... 其他生命周期回调
  ),
  child: YourPageContent(),
)
```

### 2. AppBarLayout - 带 AppBar 的布局组件
简化版的布局组件，专门用于需要 AppBar 的页面。

```dart
AppBarLayout(
  pageName: '页面名称',
  title: '页面标题',
  actions: [
    IconButton(icon: Icon(Icons.settings), onPressed: () {}),
  ],
  lifecycleCallbacks: LayoutLifecycleCallbacks(
    onPageShow: () => print('页面显示'),
    onPageHide: () => print('页面隐藏'),
  ),
  child: YourPageContent(),
)
```

### 3. SimpleLayout - 简单布局组件
最简化的布局组件，只包含基本的 Scaffold 结构。

```dart
SimpleLayout(
  pageName: '页面名称',
  lifecycleCallbacks: LayoutLifecycleCallbacks(
    onPageShow: () => print('页面显示'),
    onPageHide: () => print('页面隐藏'),
  ),
  child: YourPageContent(),
)
```

## 生命周期回调

所有 Layout 组件都支持以下生命周期回调：

- `onInit` - 页面初始化时调用
- `onDispose` - 页面销毁时调用
- `onResume` - 应用恢复时调用
- `onInactive` - 应用变为非活跃时调用
- `onHide` - 应用隐藏时调用
- `onShow` - 应用显示时调用
- `onPause` - 应用暂停时调用
- `onRestart` - 应用重启时调用
- `onDetach` - 应用分离时调用
- `onPageShow` - 页面变为可见时调用
- `onPageHide` - 页面变为不可见时调用

## 使用示例

### 基本使用
```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBarLayout(
      pageName: '我的页面',
      title: '我的页面',
      lifecycleCallbacks: LayoutLifecycleCallbacks(
        onInit: () {
          // 页面初始化逻辑
          print('页面初始化');
        },
        onPageShow: () {
          // 页面显示逻辑
          print('页面显示');
        },
        onPageHide: () {
          // 页面隐藏逻辑
          print('页面隐藏');
        },
      ),
      child: Center(
        child: Text('页面内容'),
      ),
    );
  }
}
```

### 带侧边栏的页面
```dart
class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      pageName: '侧边栏页面',
      appBar: AppBar(title: Text('侧边栏页面')),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(title: Text('菜单项1')),
            ListTile(title: Text('菜单项2')),
          ],
        ),
      ),
      lifecycleCallbacks: LayoutLifecycleCallbacks(
        onPageShow: () => print('侧边栏页面显示'),
      ),
      child: Center(
        child: Text('页面内容'),
      ),
    );
  }
}
```

### 浮动按钮页面
```dart
class FABPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      pageName: '浮动按钮页面',
      appBar: AppBar(title: Text('浮动按钮页面')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('浮动按钮被点击');
        },
        child: Icon(Icons.add),
      ),
      lifecycleCallbacks: LayoutLifecycleCallbacks(
        onPageShow: () => print('浮动按钮页面显示'),
      ),
      child: Center(
        child: Text('页面内容'),
      ),
    );
  }
}
```

## 优势

1. **统一的生命周期管理** - 所有页面都使用相同的生命周期管理逻辑
2. **代码复用** - 避免在每个页面重复编写生命周期代码
3. **易于维护** - 生命周期逻辑集中管理，便于修改和调试
4. **类型安全** - 使用强类型的回调函数，避免错误
5. **灵活性** - 支持所有 Scaffold 的属性，满足不同需求

## 注意事项

1. 确保 `pageName` 是唯一的，用于标识不同的页面
2. 生命周期回调是可选的，可以根据需要选择使用
3. 所有 Layout 组件都基于 `DirectLifecycleHook`，确保生命周期事件的准确性
4. 组件内部使用了 `HookConsumerWidget`，支持 Hooks 和 Riverpod 