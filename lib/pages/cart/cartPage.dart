import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_demo/pages/home/indexPage.dart';
import 'package:flutter_demo/pages/category/categoryPage.dart';
import 'package:flutter_demo/pages/my/myPage.dart';
import 'package:flutter_demo/core/router/context_extension.dart';
import 'package:flutter_demo/pages/cart/cart_view_model.dart';
import 'package:flutter_demo/core/mvvm/tab_view_model.dart';

import 'package:flutter_demo/core/mvvm/direct_lifecycle.dart';

class CartPage extends HookConsumerWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听 ViewModel 状态
    final cartState = ref.watch(cartStateProvider);
    final cartViewModel = ref.read(cartViewModelProvider.notifier);
    final tabViewModel = ref.read(tabViewModelProvider.notifier);
    
    // 直接生命周期管理
    DirectLifecycleHook.useDirectLifecycle(
      pageName: '购物车页面',
      onResume: () {
        print('-------------------------购物车页面 onResume');
        // 页面恢复时的逻辑
      },
      onInactive: () {
        print('-------------------------购物车页面 onInactive');
        // 页面变为非活跃时的逻辑
      },
      onHide: () {
        print('-------------------------购物车页面 onHide');
        // 页面隐藏时的逻辑
      },
      onShow: () {
        print('-------------------------购物车页面 onShow');
        // 页面显示时的逻辑
      },
      onPause: () {
        print('-------------------------购物车页面 onPause');
        // 页面暂停时的逻辑
      },
      onRestart: () {
        print('-------------------------购物车页面 onRestart');
        // 页面重启时的逻辑
      },
      onDetach: () {
        print('-------------------------购物车页面 onDetach');
        // 页面分离时的逻辑
      },
      onInit: () {
        print('-------------------------购物车页面 onInit');
        // 页面初始化时的逻辑
      },
      onDispose: () {
        print('-------------------------购物车页面 onDispose');
        // 页面销毁时的逻辑
      },
      onPageShow: () {
        print('-------------------------购物车页面 onPageShow (页面可见)');
        // 页面变为可见时的逻辑
      },
      onPageHide: () {
        print('-------------------------购物车页面 onPageHide (页面不可见)');
        // 页面变为不可见时的逻辑
      },
    );

    // Tab 页面生命周期管理
    useEffect(() {
      // 注册 Tab 页面回调
      TabViewModel.registerPageCallbacks('CartPage',
        onPageShow: () {
          print('-------------------------购物车页面 Tab onPageShow (从其他Tab切换过来)');
          // Tab 页面显示时的逻辑
        },
        onPageHide: () {
          print('-------------------------购物车页面 Tab onPageHide (切换到其他Tab)');
          // Tab 页面隐藏时的逻辑
        },
      );
      
      return () {
        TabViewModel.unregisterPageCallbacks('CartPage');
      };
    }, []);
    
    // 切换 Tab
    void switchToTab(String route) {
      tabViewModel.switchToRoute(route);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('购物车'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart,
              size: 100,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            const Text(
              '购物车页面',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '这里是购物车页面的内容',
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
                color: Colors.orange.withValues(alpha: 0.1),
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
                    '当前计数: ${cartState.counter}',
                    style: const TextStyle(fontSize: 18, color: Colors.orange),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: cartViewModel.incrementCounter,
                    child: const Text('增加计数'),
                  ),
                  const Text(
                    '切换到其他Tab再回来，计数应该保持不变',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            
            // 购物车商品列表
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '购物车商品',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '总计: ¥${cartState.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...cartState.items.map((item) => Card(
                    child: ListTile(
                      leading: Text(item.image, style: const TextStyle(fontSize: 24)),
                      title: Text(item.name),
                      subtitle: Text('¥${item.price.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => cartViewModel.decrementItemQuantity(item.id),
                          ),
                          Text('${item.quantity}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => cartViewModel.incrementItemQuantity(item.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => cartViewModel.removeItem(item.id),
                          ),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: cartViewModel.clearCart,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('清空购物车'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('结算功能开发中...')),
                          );
                        },
                        child: const Text('结算'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // 这里可以添加跳转到其他页面的逻辑
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('购物车功能开发中...')),
                );
              },
              child: const Text('购物车功能'),
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