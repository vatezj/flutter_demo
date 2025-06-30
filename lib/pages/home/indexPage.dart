import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/home/details.dart';
import 'package:flutter_demo/pages/my/myPage.dart';
import 'package:flutter_demo/pages/category/categoryPage.dart';
import 'package:flutter_demo/pages/cart/cartPage.dart';
import 'package:flutter_demo/core/router/router.dart';
import 'package:flutter_demo/core/router/context_extension.dart';

class IndexPage extends StatefulWidget with RouterBridge<Map<String, dynamic>> {
  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  Map<String, dynamic>? _args;
  String? _returnMessage;
  DetailsPageArgs? _returnData;

  String now_date = DateTime.now().toString();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在 didChangeDependencies 中获取参数
    _args = widget.argumentOf(context);
    if (_args != null) {
      print('接收到的参数: ${_args!['id']}');
    }
  }

  Future<void> _navigateAndWaitResult() async {
    try {
      final result = await context.navigateTo<Map<String, dynamic>>(
        DetailsPage,
        arguments: DetailsPageArgs(id: Random().nextInt(100), name: '测试'),
      );

      if (result != null) {
        setState(() {
          _returnMessage = result['message'] as String;
          if (result['data'] != null) {
            final data = result['data'] as Map<String, dynamic>;
            _returnData = DetailsPageArgs(
              id: data['id'] as int,
              name: data['name'] as String,
            );
          }
        });
        print('返回状态: ${result['status']}');
        print('返回消息: ${result['message']}');
        if (result['data'] != null) {
          print('返回数据: ${result['data']}');
        }
      }
    } catch (e) {
      print('发生错误: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('首页')),
      body: Column(
        children: [
          Text('首页'),
          if (_args != null) Text('接收到的ID: ${_args!['id']}'),
          if (_returnMessage != null) Text('返回消息: $_returnMessage'),
          if (_returnData != null) ...[
            Text('返回数据ID: ${_returnData!.id}'),
            Text('返回数据名称: ${_returnData!.name}'),
          ],
          Text('当前时间: $now_date'),
          ElevatedButton(
            onPressed: _navigateAndWaitResult,
            child: Text('跳转并等待结果'),
          ),
          ElevatedButton(
            onPressed: () {
              // 使用navigateToNonTab跳转，避免显示底部导航栏
              context.navigateTo(
                DetailsPage,
                arguments:
                    DetailsPageArgs(id: Random().nextInt(100), name: '测试'),
              );
            },
            child: Text('普通跳转'),
          ),
          const SizedBox(height: 20),
          const Text('Tab切换测试:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => context.switchTab(CategoryPage),
                child: const Text('切换到分类'),
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              print('测试switchTab到分类页面');
              context.switchTab(CategoryPage);
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
