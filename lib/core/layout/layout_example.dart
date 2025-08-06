import 'package:flutter/material.dart';
import 'package:flutter_demo/core/layout/base_layout.dart';

/// 使用公用 Layout 的示例页面
class LayoutExamplePage extends StatelessWidget {
  const LayoutExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarLayout(
      pageName: 'Layout示例页面',
      title: 'Layout 示例',
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            print('设置按钮被点击');
          },
        ),
      ],
      lifecycleCallbacks: LayoutLifecycleCallbacks(
        onInit: () {
          print('Layout示例页面 - 初始化');
        },
        onDispose: () {
          print('Layout示例页面 - 销毁');
        },
        onResume: () {
          print('Layout示例页面 - 恢复');
        },
        onPageShow: () {
          print('Layout示例页面 - 页面显示');
        },
        onPageHide: () {
          print('Layout示例页面 - 页面隐藏');
        },
        onShow: () {
          print('Layout示例页面 - 应用显示');
        },
        onHide: () {
          print('Layout示例页面 - 应用隐藏');
        },
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '这是一个使用公用 Layout 的示例页面',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              '这个页面自动包含了生命周期管理功能',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 