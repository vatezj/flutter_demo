import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_demo/core/layout/base_layout.dart';

/// 测试页面 - 用于验证 onPageShow 触发
class TestPage extends HookConsumerWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = useState(0);

    return AppBarLayout(
      pageName: '测试页面',
      title: '测试页面',
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      lifecycleCallbacks: LayoutLifecycleCallbacks(
        onResume: () {
          print('-------------------------测试页面 onResume');
        },
        onInactive: () {
          print('-------------------------测试页面 onInactive');
        },
        onHide: () {
          print('-------------------------测试页面 onHide');
        },
        onShow: () {
          print('-------------------------测试页面 onShow');
        },
        onPause: () {
          print('-------------------------测试页面 onPause');
        },
        onRestart: () {
          print('-------------------------测试页面 onRestart');
        },
        onDetach: () {
          print('-------------------------测试页面 onDetach');
        },
        onInit: () {
          print('-------------------------测试页面 onInit');
        },
        onDispose: () {
          print('-------------------------测试页面 onDispose');
        },
        onPageShow: () {
          print('-------------------------测试页面 onPageShow (页面可见)');
          counter.value++;
        },
        onPageHide: () {
          print('-------------------------测试页面 onPageHide (页面不可见)');
        },
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'onPageShow 触发次数:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '${counter.value}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '说明：\n'
              '1. 每次页面变为可见时，onPageShow 会触发\n'
              '2. 从其他页面返回时，计数器会增加\n'
              '3. 查看控制台日志确认触发情况',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(title: const Text('临时页面')),
                      body: const Center(
                        child: Text('点击返回按钮测试 onPageShow'),
                      ),
                    ),
                  ),
                );
              },
              child: const Text('跳转到临时页面'),
            ),
            const SizedBox(height: 10),
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