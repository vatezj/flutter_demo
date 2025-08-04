import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_demo/pages/home/details.dart';
import 'package:flutter_demo/pages/my/myPage.dart';
import 'package:flutter_demo/pages/category/categoryPage.dart';
import 'package:flutter_demo/pages/cart/cartPage.dart';
import 'package:flutter_demo/core/router/router.dart';
import 'package:flutter_demo/core/router/context_extension.dart';
import 'package:flutter_demo/pages/home/home_view_model.dart';
import 'package:flutter_demo/core/mvvm/tab_view_model.dart';

class IndexPage extends HookConsumerWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用 Hooks 管理状态
    final args = useState<Map<String, dynamic>?>(null);
    final returnMessage = useState<String?>(null);
    final returnData = useState<DetailsPageArgs?>(null);

    // 监听 ViewModel 状态
    final homeState = ref.watch(homeStateProvider);
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    final tabViewModel = ref.read(tabViewModelProvider.notifier);

    // 获取路由参数
    useEffect(() {
      Future.microtask(() {
        final routeSettings = ModalRoute.of(context)?.settings;
        if (routeSettings?.arguments != null) {
          args.value = routeSettings!.arguments as Map<String, dynamic>;
          print('接收到的参数: ${args.value!['id']}');
        }
      });
      return null;
    }, []);

    // 导航并等待结果
    Future<void> navigateAndWaitResult() async {
      try {
          final result = await context.navigateToNonTab(
            DetailsPage,
            arguments: DetailsPageArgs(id: Random().nextInt(100), name: '测试'),
          );
          print('返回结果: $result');
  
      } catch (e) {
        print('发生错误: $e');
      }
    }

    // 切换 Tab
    void switchToTab(String route) {
      tabViewModel.switchToRoute(route);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('首页')),
      body: Column(
        children: [
          const Text('首页'),
          if (args.value != null) Text('接收到的ID: ${args.value!['id']}'),
          if (returnMessage.value != null) Text('返回消息: ${returnMessage.value}'),
          if (returnData.value != null) ...[
            Text('返回数据ID: ${returnData.value!.id}'),
            Text('返回数据名称: ${returnData.value!.name}'),
          ],
          Text('当前时间: ${homeState.currentTime}'),

          // KeepAlive 测试区域
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Text(
                  'KeepAlive 测试 - 计数器',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '当前计数: ${homeState.counter}',
                  style: const TextStyle(fontSize: 18, color: Colors.blue),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: homeViewModel.incrementCounter,
                  child: const Text('增加计数'),
                ),
                const Text(
                  '切换到其他Tab再回来，计数应该保持不变',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: navigateAndWaitResult,
            child: const Text('跳转并等待结果'),
          ),
          ElevatedButton(
            onPressed: () {
              // 使用navigateToNonTab跳转，避免显示底部导航栏
              context.navigateToNonTab(DetailsPage,
                  arguments:
                      DetailsPageArgs(id: Random().nextInt(100), name: '测试'));
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const DetailsPage(),
              //     settings: RouteSettings(
              //       arguments: DetailsPageArgs(id: Random().nextInt(100), name: '测试'),
              //     ),
              //   ),
              // );
            },
            child: const Text('普通跳转'),
          ),
          const SizedBox(height: 20),
          const Text('Tab切换测试:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => switchToTab('CategoryPage'),
                child: const Text('切换到分类'),
              ),
              ElevatedButton(
                onPressed: () => switchToTab('CartPage'),
                child: const Text('切换到购物车'),
              ),
              ElevatedButton(
                onPressed: () => switchToTab('MyPage'),
                child: const Text('切换到我的'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              print('测试switchTab到分类页面');
              switchToTab('CategoryPage');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('测试 - 切换到分类'),
          ),
        ],
      ),
    );
  }
}
