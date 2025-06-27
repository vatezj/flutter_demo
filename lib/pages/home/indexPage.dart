import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/my/myPage.dart';
import 'package:flutter_demo/core/router/router.dart';
import 'package:flutter_demo/core/router/context_extension.dart';

class IndexPage extends StatefulWidget with RouterBridge<Map<String, dynamic>> {
  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  Map<String, dynamic>? _args;
  String? _returnMessage;
  PageArgs? _returnData;

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
        MyPage,
        arguments: PageArgs(id: Random().nextInt(100), name: '测试'),
      );
      
      if (result != null) {
        setState(() {
          _returnMessage = result['message'] as String;
          if (result['data'] != null) {
            final data = result['data'] as Map<String, dynamic>;
            _returnData = PageArgs(
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
          ElevatedButton(
            onPressed: _navigateAndWaitResult,
            child: Text('跳转并等待结果'),
          ),
          ElevatedButton(
            onPressed: () {
              context.navigateTo(
                MyPage,
                arguments: PageArgs(id: Random().nextInt(100), name: '测试'),
              );
            },
            child: Text('普通跳转'),
          ),
        ],
      ),
    );
  }
}
