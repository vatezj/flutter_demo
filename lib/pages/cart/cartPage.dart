import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/home/indexPage.dart';
import 'package:flutter_demo/pages/category/categoryPage.dart';
import 'package:flutter_demo/pages/my/myPage.dart';
import 'package:flutter_demo/core/router/context_extension.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => context.switchTab(IndexPage),
                  child: const Text('切换到首页'),
                ),
                ElevatedButton(
                  onPressed: () => context.switchTab(CategoryPage),
                  child: const Text('切换到分类'),
                ),
                ElevatedButton(
                  onPressed: () => context.switchTab(MyPage),
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