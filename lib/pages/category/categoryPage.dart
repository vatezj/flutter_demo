import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/home/indexPage.dart';
import 'package:flutter_demo/pages/cart/cartPage.dart';
import 'package:flutter_demo/pages/my/myPage.dart';
import 'package:flutter_demo/core/router/context_extension.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => context.switchTab(IndexPage),
                  child: const Text('切换到首页'),
                ),
                ElevatedButton(
                  onPressed: () => context.switchTab(CartPage),
                  child: const Text('切换到购物车'),
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