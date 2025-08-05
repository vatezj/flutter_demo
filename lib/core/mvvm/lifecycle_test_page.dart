import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'hook_lifecycle.dart';

/// 生命周期测试页面
class LifecycleTestPage extends HookConsumerWidget {
  const LifecycleTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 页面可见性状态
    final isVisible = usePageVisibility();
    final lifecycleLogs = useState<List<String>>([]);

    // 添加日志
    void addLog(String message) {
      final timestamp = DateTime.now().toString().substring(11, 19);
      lifecycleLogs.value = [...lifecycleLogs.value, '[$timestamp] $message'];
      print('[$timestamp] $message');
    }

    // 页面生命周期管理（增强版）
    LifecycleHook.useEnhancedPageLifecycle(
      onResume: () {
        addLog('-------------------------测试页面 onResume');
      },
      onInactive: () {
        addLog('-------------------------测试页面 onInactive');
      },
      onHide: () {
        addLog('-------------------------测试页面 onHide');
      },
      onShow: () {
        addLog('-------------------------测试页面 onShow');
      },
      onPause: () {
        addLog('-------------------------测试页面 onPause');
      },
      onRestart: () {
        addLog('-------------------------测试页面 onRestart');
      },
      onDetach: () {
        addLog('-------------------------测试页面 onDetach');
      },
      onInit: () {
        addLog('-------------------------测试页面 onInit');
      },
      onDispose: () {
        addLog('-------------------------测试页面 onDispose');
      },
      onPageShow: () {
        addLog('-------------------------测试页面 onPageShow (页面可见)');
      },
      onPageHide: () {
        addLog('-------------------------测试页面 onPageHide (页面不可见)');
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('生命周期测试'),
        backgroundColor: Colors.blue,
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
            // 页面可见性状态
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
            
            // 测试说明
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '测试说明',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. 切换到其他应用，观察 onPause 和 onPageHide 触发\n'
                      '2. 切换回应用，观察 onResume 和 onPageShow 触发\n'
                      '3. 切换到其他页面，观察页面级别的生命周期\n'
                      '4. 返回此页面，观察 onPageShow 触发',
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
                            addLog('手动添加测试日志');
                          },
                          child: const Text('添加测试日志'),
                        ),
                        const SizedBox(width: 8),
                                                  ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                    appBar: AppBar(title: const Text('测试页面')),
                                    body: const Center(child: Text('这是测试页面')),
                                  ),
                                ),
                              );
                            },
                            child: const Text('跳转测试页面'),
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