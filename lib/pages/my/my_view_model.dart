import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/core/mvvm/base_view_model.dart';

/// 用户信息模型
class UserInfo {
  final String id;
  final String name;
  final String avatar;
  final String email;
  final int points;

  const UserInfo({
    required this.id,
    required this.name,
    required this.avatar,
    required this.email,
    required this.points,
  });

  UserInfo copyWith({
    String? id,
    String? name,
    String? avatar,
    String? email,
    int? points,
  }) {
    return UserInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      points: points ?? this.points,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserInfo &&
        other.id == id &&
        other.name == name &&
        other.avatar == avatar &&
        other.email == email &&
        other.points == points;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ avatar.hashCode ^ email.hashCode ^ points.hashCode;
}

/// 我的页面状态类
class MyState extends BaseState {
  final int counter;
  final UserInfo? userInfo;
  final bool isLoggedIn;

  const MyState({
    super.isLoading,
    super.errorMessage,
    required this.counter,
    this.userInfo,
    required this.isLoggedIn,
  });

  factory MyState.initial() => MyState(
        counter: 0,
        isLoggedIn: false,
        userInfo: const UserInfo(
          id: '1',
          name: '张三',
          avatar: '👤',
          email: 'zhangsan@example.com',
          points: 1000,
        ),
      );

  @override
  MyState copyWith({
    bool? isLoading,
    String? errorMessage,
    int? counter,
    UserInfo? userInfo,
    bool? isLoggedIn,
  }) {
    return MyState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      counter: counter ?? this.counter,
      userInfo: userInfo ?? this.userInfo,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MyState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.counter == counter &&
        other.userInfo == userInfo &&
        other.isLoggedIn == isLoggedIn;
  }

  @override
  int get hashCode => isLoading.hashCode ^
      errorMessage.hashCode ^
      counter.hashCode ^
      userInfo.hashCode ^
      isLoggedIn.hashCode;
}

/// 我的页面 ViewModel
class MyViewModel extends StateNotifier<MyState> {
  MyViewModel() : super(MyState.initial());

  /// 增加计数器
  void incrementCounter() {
    state = state.copyWith(counter: state.counter + 1);
  }

  /// 登录
  void login() {
    state = state.copyWith(isLoggedIn: true);
  }

  /// 登出
  void logout() {
    state = state.copyWith(isLoggedIn: false);
  }

  /// 更新用户信息
  void updateUserInfo(UserInfo userInfo) {
    state = state.copyWith(userInfo: userInfo);
  }

  /// 增加积分
  void addPoints(int points) {
    if (state.userInfo != null) {
      final newUserInfo = state.userInfo!.copyWith(
        points: state.userInfo!.points + points,
      );
      state = state.copyWith(userInfo: newUserInfo);
    }
  }

  /// 重置状态
  void reset() {
    state = MyState.initial();
  }
}

/// 我的页面 ViewModel Provider
final myViewModelProvider = StateNotifierProvider<MyViewModel, MyState>((ref) {
  return MyViewModel();
});

/// 我的页面状态 Provider
final myStateProvider = Provider<MyState>((ref) {
  return ref.watch(myViewModelProvider);
});

/// 我的页面计数器 Provider
final myCounterProvider = Provider<int>((ref) {
  return ref.watch(myStateProvider).counter;
});

/// 用户信息 Provider
final userInfoProvider = Provider<UserInfo?>((ref) {
  return ref.watch(myStateProvider).userInfo;
});

/// 登录状态 Provider
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(myStateProvider).isLoggedIn;
}); 