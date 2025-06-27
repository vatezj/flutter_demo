import 'package:flutter/material.dart';
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

class MyPage extends StatefulWidget with RouterBridge<PageArgs> {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  PageArgs? _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 获取路由参数
    _args = widget.argumentOf(context);
    if (_args != null) {
      print('MyPage 接收到的参数: ${_args!.id}');
      print('MyPage 接收到的参数: ${_args!.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我的页面')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('接收到的ID: ${_args?.id ?? '无'}'),
            Text('接收到的名称: ${_args?.name ?? '无'}'),
            ElevatedButton(
              onPressed: () {
                // 返回成功结果
                context.navigateBack<Map<String, dynamic>>({
                  'status': 'success',
                  'message': '操作成功',
                  'data': _args?.toJson(),
                });
              },
              child: Text('确认并返回'),
            ),
            ElevatedButton(
              onPressed: () {
                // 返回取消结果
                context.navigateBack<Map<String, dynamic>>({
                  'status': 'cancel',
                  'message': '用户取消',
                  'data': null,
                });
              },
              child: Text('取消并返回'),
            ),
          ],
        ),
      ),
    );
  }
}
