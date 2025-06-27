 import 'package:flutter_demo/core/network/http.dart';

/// API 接口类
class Api {
  static final Api _instance = Api._internal();
  factory Api() => _instance;
  Api._internal();

  /// 获取用户信息
  Future<HttpResponse<Map<String, dynamic>>> getUserInfo() async {
    return await HttpClient().get<Map<String, dynamic>>('/user/info');
  }

  /// 登录
  Future<HttpResponse<Map<String, dynamic>>> login({
    required String username,
    required String password,
  }) async {
    return await HttpClient().post<Map<String, dynamic>>(
      '/user/login',
      data: {
        'username': username,
        'password': password,
      },
    );
  }

  /// 获取列表数据
  Future<HttpResponse<List<Map<String, dynamic>>>> getList({
    int page = 1,
    int pageSize = 10,
  }) async {
    return await HttpClient().get<List<Map<String, dynamic>>>(
      '/list',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );
  }
}