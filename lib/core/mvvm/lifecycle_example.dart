import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'hook_lifecycle.dart';

/// 生命周期管理使用示例
class LifecycleExamplePage extends HookConsumerWidget {
  const LifecycleExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 页面可见性状态
    final isVisible = usePageVisibility();
    
    // 页面生命周期管理
    LifecycleHook.usePageLifecycle(
      onResume: () {
        print('-------------------------示例页面 onResume');
        // 页面恢复时的逻辑，比如刷新数据
        _refreshData();
      },
      onInactive: () {
        print('-------------------------示例页面 onInactive');
        // 页面变为非活跃时的逻辑，比如暂停动画
        _pauseAnimations();
      },
      onHide: () {
        print('-------------------------示例页面 onHide');
        // 页面隐藏时的逻辑，比如保存状态
        _saveState();
      },
      onShow: () {
        print('-------------------------示例页面 onShow');
        // 页面显示时的逻辑，比如恢复动画
        _resumeAnimations();
      },
      onPause: () {
        print('-------------------------示例页面 onPause');
        // 页面暂停时的逻辑，比如暂停网络请求
        _pauseNetworkRequests();
      },
      onRestart: () {
        print('-------------------------示例页面 onRestart');
        // 页面重启时的逻辑，比如重新初始化
        _reinitialize();
      },
      onDetach: () {
        print('-------------------------示例页面 onDetach');
        // 页面分离时的逻辑，比如清理资源
        _cleanupResources();
      },
      onInit: () {
        print('-------------------------示例页面 onInit');
        // 页面初始化时的逻辑，比如加载初始数据
        _loadInitialData();
      },
      onDispose: () {
        print('-------------------------示例页面 onDispose');
        // 页面销毁时的逻辑，比如清理监听器
        _cleanupListeners();
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('生命周期示例'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 页面可见性状态显示
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '页面可见性状态',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off,
                          color: isVisible ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isVisible ? '页面可见' : '页面隐藏',
                          style: TextStyle(
                            color: isVisible ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 生命周期说明
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '生命周期回调说明',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildLifecycleItem('onInit', '页面初始化时调用'),
                    _buildLifecycleItem('onResume', '页面恢复时调用'),
                    _buildLifecycleItem('onPause', '页面暂停时调用'),
                    _buildLifecycleItem('onHide', '页面隐藏时调用'),
                    _buildLifecycleItem('onShow', '页面显示时调用'),
                    _buildLifecycleItem('onInactive', '页面变为非活跃时调用'),
                    _buildLifecycleItem('onRestart', '页面重启时调用'),
                    _buildLifecycleItem('onDetach', '页面分离时调用'),
                    _buildLifecycleItem('onDispose', '页面销毁时调用'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 测试按钮
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '测试操作',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // 模拟一些操作
                        print('执行测试操作');
                      },
                      child: const Text('执行测试操作'),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '切换到其他应用或页面，观察控制台输出的生命周期日志',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLifecycleItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 8),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 模拟生命周期方法
  void _refreshData() {
    print('刷新数据');
  }

  void _pauseAnimations() {
    print('暂停动画');
  }

  void _saveState() {
    print('保存状态');
  }

  void _resumeAnimations() {
    print('恢复动画');
  }

  void _pauseNetworkRequests() {
    print('暂停网络请求');
  }

  void _reinitialize() {
    print('重新初始化');
  }

  void _cleanupResources() {
    print('清理资源');
  }

  void _loadInitialData() {
    print('加载初始数据');
  }

  void _cleanupListeners() {
    print('清理监听器');
  }
} 