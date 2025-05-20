import 'package:dio/dio.dart';

/// 认证拦截器
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 从本地存储获取 token
    final token = 'your_token_here';
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // token 过期，跳转到登录页
      // TODO: 实现跳转逻辑
    }
    handler.next(err);
  }
}

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        // 处理连接超时
        break;
      case DioExceptionType.sendTimeout:
        // 处理请求超时
        break;
      case DioExceptionType.receiveTimeout:
        // 处理响应超时
        break;
      case DioExceptionType.badResponse:
        // 处理服务器错误
        break;
      case DioExceptionType.cancel:
        // 处理请求取消
        break;
      default:
        // 处理其他错误
        break;
    }
    handler.next(err);
  }
} 