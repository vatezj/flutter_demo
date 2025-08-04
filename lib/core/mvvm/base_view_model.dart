import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 基础状态类
class BaseState {
  final bool isLoading;
  final String? errorMessage;

  const BaseState({
    this.isLoading = false,
    this.errorMessage,
  });

  factory BaseState.initial() => const BaseState();

  BaseState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return BaseState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BaseState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => isLoading.hashCode ^ errorMessage.hashCode;
}

/// 基础 Riverpod ViewModel 类
/// 使用 Riverpod 的状态管理
abstract class BaseRiverpodViewModel extends StateNotifier<BaseState> {
  BaseRiverpodViewModel() : super(BaseState.initial());

  /// 设置加载状态
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  /// 设置错误信息
  void setError(String? error) {
    state = state.copyWith(errorMessage: error);
  }

  /// 清除错误信息
  void clearError() {
    setError(null);
  }

  /// 初始化方法
  Future<void> init() async {
    // 子类可以重写此方法进行初始化
  }

  /// 安全执行异步操作
  Future<T?> safeAsync<T>(Future<T> Function() operation) async {
    try {
      setLoading(true);
      clearError();
      final result = await operation();
      return result;
    } catch (e) {
      setError(e.toString());
      return null;
    } finally {
      setLoading(false);
    }
  }
} 