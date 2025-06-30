import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/home/indexPage.dart';
import 'package:flutter_demo/pages/category/categoryPage.dart';
import 'package:flutter_demo/pages/cart/cartPage.dart';
import 'package:flutter_demo/core/router/router.dart';
import 'package:flutter_demo/core/router/context_extension.dart';

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

class MyPage extends StatefulWidget with RouterBridge<Map<String, dynamic>> {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Map<String, dynamic>? _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args = widget.argumentOf(context);
    if (_args != null) {
      print('接收到的参数: ${_args!['id']}');
    }
  }

  Future<void> _returnResult() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我的')),
      body: Column(
        children: [
          Text('我的页面'),
          if (_args != null) Text('接收到的ID: ${_args!['id']}'),
          ElevatedButton(
            onPressed: _returnResult,
            child: Text('返回结果'),
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
                onPressed: () => context.switchTab(CartPage),
                child: const Text('切换到购物车'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
