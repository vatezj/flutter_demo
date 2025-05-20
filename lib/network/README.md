# Flutter 网络请求框架

一个基于 Dio 的网络请求框架，支持请求拦截、响应处理、错误处理等功能。

## 目录结构

```
lib/network/
├── README.md           # 本文档
├── http.dart          # 网络请求核心实现
├── api.dart           # API 接口定义
└── interceptor.dart   # 拦截器实现
```

## 功能特点

- 统一的请求配置
- 支持请求拦截
- 统一的响应处理
- 统一的错误处理
- 支持取消请求
- 支持请求重试
- 支持日志打印

## 基本使用

### 1. 初始化配置

```dart
void main() {
  // 初始化网络请求配置
  HttpClient().init(HttpConfig(
    baseUrl: 'https://api.example.com',
    connectTimeout: 15000,
    receiveTimeout: 15000,
    headers: {
      'Content-Type': 'application/json',
    },
    interceptors: [
      AuthInterceptor(),
      ErrorInterceptor(),
    ],
  ));

  runApp(const MyApp());
}
```

### 2. 发起请求

```dart
// GET 请求
final response = await HttpClient().get<Map<String, dynamic>>(
  '/user/info',
  queryParameters: {'id': 1},
);

// POST 请求
final response = await HttpClient().post<Map<String, dynamic>>(
  '/user/login',
  data: {
    'username': 'test',
    'password': '123456',
  },
);

// 处理响应
if (response.isSuccess) {
  print('数据: ${response.data}');
} else {
  print('错误: ${response.message}');
}
```

### 3. 使用 API 类

```dart
// 登录
final loginResponse = await Api().login(
  username: 'test',
  password: '123456',
);

if (loginResponse.isSuccess) {
  print('登录成功: ${loginResponse.data}');
} else {
  print('登录失败: ${loginResponse.message}');
}

// 获取用户信息
final userResponse = await Api().getUserInfo();
if (userResponse.isSuccess) {
  print('用户信息: ${userResponse.data}');
}

// 获取列表数据
final listResponse = await Api().getList(
  page: 1,
  pageSize: 10,
);
if (listResponse.isSuccess) {
  print('列表数据: ${listResponse.data}');
}
```

## 拦截器使用

### 1. 认证拦截器

```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 添加 token
    final token = 'your_token_here';
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 处理 401 错误
    if (err.response?.statusCode == 401) {
      // 跳转到登录页
    }
    handler.next(err);
  }
}
```

### 2. 错误处理拦截器

```dart
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
```

## 最佳实践

1. 请求配置：
   - 统一配置 baseUrl
   - 设置合理的超时时间
   - 添加必要的请求头

2. 响应处理：
   - 使用泛型指定返回类型
   - 统一处理响应格式
   - 处理错误情况

3. 错误处理：
   - 实现错误拦截器
   - 统一处理错误信息
   - 处理特殊错误码

4. 拦截器使用：
   - 实现认证拦截器
   - 实现错误处理拦截器
   - 实现日志拦截器

## 注意事项

1. 请求配置：
   - 注意 baseUrl 的正确性
   - 注意超时时间的设置
   - 注意请求头的设置

2. 响应处理：
   - 注意返回值的类型
   - 注意错误信息的处理
   - 注意空值处理

3. 错误处理：
   - 注意网络错误处理
   - 注意服务器错误处理
   - 注意业务错误处理

4. 拦截器：
   - 注意拦截器的顺序
   - 注意拦截器的性能
   - 注意拦截器的复用 