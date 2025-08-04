import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_demo/pages/home/indexPage.dart';
import 'package:flutter_demo/pages/category/categoryPage.dart';
import 'package:flutter_demo/pages/cart/cartPage.dart';
import 'package:flutter_demo/core/router/router.dart';
import 'package:flutter_demo/core/router/context_extension.dart';
import 'package:flutter_demo/pages/my/my_view_model.dart';
import 'package:flutter_demo/core/mvvm/tab_view_model.dart';

class PageArgs {
  final int id;
  final String name;

  PageArgs({this.id = 0, this.name = ''});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class PageResult {
  final String status;
  final String message;
  final PageArgs? data;

  PageResult({
    required this.status,
    required this.message,
    this.data,
  });
}

class MyPage extends HookConsumerWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用 Hooks 管理状态
    final args = useState<Map<String, dynamic>?>(null);
    
    // 监听 ViewModel 状态
    final myState = ref.watch(myStateProvider);
    final myViewModel = ref.read(myViewModelProvider.notifier);
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
    
    // 返回结果
    Future<void> returnResult() async {
      final result = {
        'status': 'success',
        'message': '操作成功',
        'data': {
          'id': Random().nextInt(100),
          'name': '返回的数据',
        },
      };
      
      context.navigateBack(result);
    }
    
    // 切换 Tab
    void switchToTab(String route) {
      tabViewModel.switchToRoute(route);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: Column(
        children: [
          const Text('我的页面'),
          if (args.value != null) Text('接收到的ID: ${args.value!['id']}'),
          
          // KeepAlive 测试区域
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.1),
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
                  '当前计数: ${myState.counter}',
                  style: const TextStyle(fontSize: 18, color: Colors.purple),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: myViewModel.incrementCounter,
                  child: const Text('增加计数'),
                ),
                const Text(
                  '切换到其他Tab再回来，计数应该保持不变',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          
          // 用户信息区域
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Text(
                  '用户信息',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (myState.userInfo != null) ...[
                  Row(
                    children: [
                      Text(myState.userInfo!.avatar, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(myState.userInfo!.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(myState.userInfo!.email, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('积分: ${myState.userInfo!.points}', style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => myViewModel.addPoints(100),
                        child: const Text('增加积分'),
                      ),
                      ElevatedButton(
                        onPressed: myState.isLoggedIn ? myViewModel.logout : myViewModel.login,
                        child: Text(myState.isLoggedIn ? '登出' : '登录'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: returnResult,
            child: const Text('返回结果'),
          ),
          const SizedBox(height: 20),
          const Text('Tab切换测试:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => switchToTab('IndexPage'),
                child: const Text('切换到首页'),
              ),
              ElevatedButton(
                onPressed: () => switchToTab('CategoryPage'),
                child: const Text('切换到分类'),
              ),
              ElevatedButton(
                onPressed: () => switchToTab('CartPage'),
                child: const Text('切换到购物车'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
