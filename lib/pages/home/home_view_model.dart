import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/core/mvvm/base_view_model.dart';

/// 首页状态类
class HomeState extends BaseState {
  final int counter;
  final String currentTime;
  final String? returnMessage;
  final Map<String, dynamic>? returnData;

  const HomeState({
    super.isLoading,
    super.errorMessage,
    required this.counter,
    required this.currentTime,
    this.returnMessage,
    this.returnData,
  });

  factory HomeState.initial() => HomeState(
        counter: 0,
        currentTime: DateTime.now().toString(),
      );

  @override
  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    int? counter,
    String? currentTime,
    String? returnMessage,
    Map<String, dynamic>? returnData,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      counter: counter ?? this.counter,
      currentTime: currentTime ?? this.currentTime,
      returnMessage: returnMessage ?? this.returnMessage,
      returnData: returnData ?? this.returnData,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.counter == counter &&
        other.currentTime == currentTime &&
        other.returnMessage == returnMessage &&
        other.returnData == returnData;
  }

  @override
  int get hashCode => isLoading.hashCode ^
      errorMessage.hashCode ^
      counter.hashCode ^
      currentTime.hashCode ^
      returnMessage.hashCode ^
      returnData.hashCode;
}

/// 首页 ViewModel
class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(HomeState.initial());

  /// 增加计数器
  void incrementCounter() {
    state = state.copyWith(counter: state.counter + 1);
  }

  /// 更新当前时间
  void updateCurrentTime() {
    state = state.copyWith(currentTime: DateTime.now().toString());
  }

  /// 设置返回消息
  void setReturnMessage(String? message) {
    state = state.copyWith(returnMessage: message);
  }

  /// 设置返回数据
  void setReturnData(Map<String, dynamic>? data) {
    state = state.copyWith(returnData: data);
  }

  /// 重置状态
  void reset() {
    state = HomeState.initial();
  }
}

/// 首页 ViewModel Provider
final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  return HomeViewModel();
});

/// 首页状态 Provider
final homeStateProvider = Provider<HomeState>((ref) {
  return ref.watch(homeViewModelProvider);
});

/// 计数器 Provider
final homeCounterProvider = Provider<int>((ref) {
  return ref.watch(homeStateProvider).counter;
});

/// 当前时间 Provider
final homeCurrentTimeProvider = Provider<String>((ref) {
  return ref.watch(homeStateProvider).currentTime;
}); 