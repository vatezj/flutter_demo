import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_demo/pages/home/indexPage.dart';
import 'package:flutter_demo/pages/cart/cartPage.dart';
import 'package:flutter_demo/pages/my/myPage.dart';
import 'package:flutter_demo/core/router/context_extension.dart';
import 'package:flutter_demo/pages/category/category_view_model.dart';
import 'package:flutter_demo/core/mvvm/tab_view_model.dart';

import 'package:flutter_demo/core/mvvm/direct_lifecycle.dart';

class CategoryPage extends HookConsumerWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听 ViewModel 状态
    final categoryState = ref.watch(categoryStateProvider);
    final categoryViewModel = ref.read(categoryViewModelProvider.notifier);
    final tabViewModel = ref.read(tabViewModelProvider.notifier);
    
    // 直接生命周期管理
    DirectLifecycleHook.useDirectLifecycle(
      pageName: '分类页面',
      onResume: () {
        print('-------------------------分类页面 onResume');
        // 页面恢复时的逻辑
      },
      onInactive: () {
        print('-------------------------分类页面 onInactive');
        // 页面变为非活跃时的逻辑
      },
      onHide: () {
        print('-------------------------分类页面 onHide');
        // 页面隐藏时的逻辑
      },
      onShow: () {
        print('-------------------------分类页面 onShow');
        // 页面显示时的逻辑
      },
      onPause: () {
        print('-------------------------分类页面 onPause');
        // 页面暂停时的逻辑
      },
      onRestart: () {
        print('-------------------------分类页面 onRestart');
        // 页面重启时的逻辑
      },
      onDetach: () {
        print('-------------------------分类页面 onDetach');
        // 页面分离时的逻辑
      },
      onInit: () {
        print('-------------------------分类页面 onInit');
        // 页面初始化时的逻辑
      },
      onDispose: () {
        print('-------------------------分类页面 onDispose');
        // 页面销毁时的逻辑
      },
      onPageShow: () {
        print('-------------------------分类页面 onPageShow (页面可见)');
        // 页面变为可见时的逻辑
      },
      onPageHide: () {
        print('-------------------------分类页面 onPageHide (页面不可见)');
        // 页面变为不可见时的逻辑
      },
    );

    // Tab 页面生命周期管理
    useEffect(() {
      // 注册 Tab 页面回调
      TabViewModel.registerPageCallbacks('CategoryPage',
        onPageShow: () {
          print('-------------------------分类页面 Tab onPageShow (从其他Tab切换过来)');
          // Tab 页面显示时的逻辑
        },
        onPageHide: () {
          print('-------------------------分类页面 Tab onPageHide (切换到其他Tab)');
          // Tab 页面隐藏时的逻辑
        },
      );
      
      return () {
        TabViewModel.unregisterPageCallbacks('CategoryPage');
      };
    }, []);
    
    // 切换 Tab
    void switchToTab(String route) {
      tabViewModel.switchToRoute(route);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('分类'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.category,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              '分类页面',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '这里是分类页面的内容',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            
            // KeepAlive 测试区域
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
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
                    '当前计数: ${categoryState.counter}',
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: categoryViewModel.incrementCounter,
                    child: const Text('增加计数'),
                  ),
                  const Text(
                    '切换到其他Tab再回来，计数应该保持不变',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            
            // 分类列表
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    '分类列表',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...categoryState.categories.map((category) => ListTile(
                    title: Text(category),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        final index = categoryState.categories.indexOf(category);
                        if (index >= 0) {
                          categoryViewModel.removeCategory(index);
                        }
                      },
                    ),
                  )),
                  ElevatedButton(
                    onPressed: () {
                      final newCategory = '新分类${categoryState.categories.length + 1}';
                      categoryViewModel.addCategory(newCategory);
                    },
                    child: const Text('添加分类'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // 这里可以添加跳转到其他页面的逻辑
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('分类页面功能开发中...')),
                );
              },
              child: const Text('分类功能'),
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
                  onPressed: () => switchToTab('CartPage'),
                  child: const Text('切换到购物车'),
                ),
                ElevatedButton(
                  onPressed: () => switchToTab('MyPage'),
                  child: const Text('切换到我的'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 