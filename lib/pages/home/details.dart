import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_demo/core/router/router.dart';
import 'package:flutter_demo/core/router/context_extension.dart';
import 'package:flutter_demo/pages/home/info.dart';

class DetailsPageArgs {
  final int id;
  final String name;

  DetailsPageArgs({this.id = 0, this.name = ''});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

class PageResult {
  final String status;
  final String message;
  final DetailsPageArgs? data;

  PageResult({
    required this.status,
    required this.message,
    this.data,
  });
}

class DetailsPage extends HookConsumerWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用 Hooks 管理状态
    final args = useState<DetailsPageArgs?>(null);
    
    // 获取路由参数
    useEffect(() {
      Future.microtask(() {
        final routeSettings = ModalRoute.of(context)?.settings;
        if (routeSettings?.arguments != null) {
          args.value = routeSettings!.arguments as DetailsPageArgs;
          print('DetailsPage 接收到的参11数123: ${args.value!.id}');
          print('DetailsPage 接收到的参数456: ${args.value!.name}');
        }
      });
      return null;
    }, []);
    return Scaffold(
      appBar: AppBar(title: const Text('详情页面')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('接收到的ID: ${args.value?.id ?? '无'}'),
            Text('接收到的名称: ${args.value?.name ?? '无'}'),
            ElevatedButton(
              onPressed: () {
                // 返回成功结果
                context.navigateBack<Map<String, dynamic>>({
                  'status': 'success',
                  'message': '操作成功',
                  'data': args.value?.toJson(),
                });
              },
              child: const Text('确认并返回'),
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
              child: const Text('取消并返回'),
            ),


             ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InfoPage(),
                    settings: RouteSettings(
                      arguments: DetailsPageArgs(id: (args.value?.id ?? 0) + 1, name: '${args.value?.name ?? ''} - 详情'),
                    ),
                  ),
                );
              },
              child: const Text('跳转到信息页面'),
            ),
          ],
        ),
      ),
    );
  }
}
