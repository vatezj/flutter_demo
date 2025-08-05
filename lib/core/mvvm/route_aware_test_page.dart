import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'route_aware_lifecycle.dart';

/// RouteAware 生命周期测试页面
class RouteAwareTestPage extends HookConsumerWidget {
  const RouteAwareTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lifecycleLogs = useState<List<String>>([]);

    // 添加日志
    void addLog(String message) {
      final timestamp = DateTime.now().toString().substring(11, 19);
      lifecycleLogs.value = [...lifecycleLogs.value, '[$timestamp] $message'];
      print('[$timestamp] $message');
    }

    // RouteAware 页面生命周期管理
    EnhancedRouteAwareLifecycleHook.useEnhancedRouteAwareLifecycle(
      pageName: 'RouteAware测试页面',
      onResume: () {
        addLog('-------------------------RouteAware测试页面 onResume');
      },
      onInactive: () {
        addLog('-------------------------RouteAware测试页面 onInactive');
      },
      onHide: () {
        addLog('-------------------------RouteAware测试页面 onHide');
      },
      onShow: () {
        addLog('-------------------------RouteAware测试页面 onShow');
      },
      onPause: () {
        addLog('-------------------------RouteAware测试页面 onPause');
      },
      onRestart: () {
        addLog('-------------------------RouteAware测试页面 onRestart');
      },
      onDetach: () {
        addLog('-------------------------RouteAware测试页面 onDetach');
      },
      onInit: () {
        addLog('-------------------------RouteAware测试页面 onInit');
      },
      onDispose: () {
        addLog('-------------------------RouteAware测试页面 onDispose');
      },
      onPageShow: () {
        addLog('-------------------------RouteAware测试页面 onPageShow (页面可见)');
      },
      onPageHide: () {
        addLog('-------------------------RouteAware测试页面 onPageHide (页面不可见)');
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('RouteAware 测试'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              lifecycleLogs.value = [];
            },
            icon: const Icon(Icons.clear),
            tooltip: '清空日志',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 测试说明
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RouteAware 测试说明',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. 点击"跳转到其他页面"按钮\n'
                      '2. 在新页面点击"返回"按钮\n'
                      '3. 观察返回时的生命周期日志\n'
                      '4. 应该看到 didPopNext 和 onPageShow 被触发',
                      style: TextStyle(fontSize: 12),
                    ),
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
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const _OtherPage(),
                              ),
                            );
                          },
                          child: const Text('跳转到其他页面'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            addLog('手动添加测试日志');
                          },
                          child: const Text('添加测试日志'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 生命周期日志
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '生命周期日志 (${lifecycleLogs.value.length})',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              lifecycleLogs.value = [];
                            },
                            child: const Text('清空'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: lifecycleLogs.value.isEmpty
                              ? const Center(
                                  child: Text(
                                    '暂无日志，请执行测试操作',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: lifecycleLogs.value.length,
                                  itemBuilder: (context, index) {
                                    final log = lifecycleLogs.value[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                                      child: Text(
                                        log,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    );
                                  },
                                ),
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

/// 其他页面
class _OtherPage extends HookConsumerWidget {
  const _OtherPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('其他页面'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '这是其他页面',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              '点击返回按钮，观察原页面的 RouteAware 生命周期',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('返回'),
            ),
          ],
        ),
      ),
    );
  }
} 