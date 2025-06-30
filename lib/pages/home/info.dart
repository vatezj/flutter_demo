import 'package:flutter/material.dart';
import 'package:flutter_demo/core/router/router.dart';
import 'package:flutter_demo/core/router/context_extension.dart';
import 'package:flutter_demo/pages/category/categoryPage.dart';
import 'package:flutter_demo/pages/home/indexPage.dart';

class InfoPageArgs {
  final int id;
  final String name;

  InfoPageArgs({this.id = 0, this.name = ''});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

class PageResult {
  final String status;
  final String message;
  final InfoPageArgs? data;

  PageResult({
    required this.status,
    required this.message,
    this.data,
  });
}

class InfoPage extends StatefulWidget with RouterBridge<InfoPageArgs> {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  InfoPageArgs? _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 获取路由参数
    _args = widget.argumentOf(context);
    if (_args != null) {
      print('DetailsPage 接收到的参数: ${_args!.id}');
      print('DetailsPage 接收到的参数: ${_args!.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('详情页面')),
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


            ElevatedButton(
              onPressed: () {
                // 返回取消结果
                context.switchTab(CategoryPage);
              },
              child: Text('跳转到分类tabs'),
            ),
          ],
        ),
      ),
    );
  }
}
