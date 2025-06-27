import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 网络请求响应数据
class HttpResponse<T> {
  final T? data;
  final int? code;
  final String? message;

  HttpResponse({this.data, this.code, this.message});

  bool get isSuccess => code == 200;

  factory HttpResponse.fromJson(Map<String, dynamic> json) {
    return HttpResponse(
      data: json['data'],
      code: json['code'],
      message: json['message'],
    );
  }
}

/// 网络请求配置
class HttpConfig {
  final String baseUrl;
  final int connectTimeout;
  final int receiveTimeout;
  final Map<String, dynamic>? headers;
  final List<Interceptor>? interceptors;

  HttpConfig({
    required this.baseUrl,
    this.connectTimeout = 15000,
    this.receiveTimeout = 15000,
    this.headers,
    this.interceptors,
  });
}

/// 网络请求客户端
class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  HttpClient._internal();

  late Dio _dio;
  HttpConfig? _config;

  /// 初始化配置
  void init(HttpConfig config) {
    _config = config;
    _dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: Duration(milliseconds: config.connectTimeout),
        receiveTimeout: Duration(milliseconds: config.receiveTimeout),
        headers: config.headers,
      ),
    );

    // 添加拦截器
    if (config.interceptors != null) {
      _dio.interceptors.addAll(config.interceptors!);
    }

    // 添加日志拦截器
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  /// GET 请求
  Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  /// POST 请求
  Future<HttpResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  /// PUT 请求
  Future<HttpResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  /// DELETE 请求
  Future<HttpResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  /// 处理响应数据
  HttpResponse<T> _handleResponse<T>(Response response) {
    if (response.statusCode == 200) {
      try {
        if (response.data is Map<String, dynamic>) {
          return HttpResponse<T>.fromJson(response.data);
        } else {
          return HttpResponse<T>(
            data: response.data,
            code: response.statusCode,
            message: 'success',
          );
        }
      } catch (e) {
        return HttpResponse<T>(code: -1, message: '数据解析错误: $e');
      }
    } else {
      return HttpResponse<T>(
        code: response.statusCode,
        message: response.statusMessage,
      );
    }
  }

  /// 处理错误
  HttpResponse<T> _handleError<T>(DioException error) {
    String message = '未知错误';
    int? code;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = '连接超时';
        break;
      case DioExceptionType.sendTimeout:
        message = '请求超时';
        break;
      case DioExceptionType.receiveTimeout:
        message = '响应超时';
        break;
      case DioExceptionType.badResponse:
        code = error.response?.statusCode;
        message = error.response?.statusMessage ?? '服务器错误';
        break;
      case DioExceptionType.cancel:
        message = '请求取消';
        break;
      default:
        message = '网络错误';
        break;
    }

    return HttpResponse<T>(code: code ?? -1, message: message);
  }
}
