import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/core/mvvm/base_view_model.dart';

/// 分类页面状态类
class CategoryState extends BaseState {
  final int counter;
  final List<String> categories;

  const CategoryState({
    super.isLoading,
    super.errorMessage,
    required this.counter,
    required this.categories,
  });

  factory CategoryState.initial() => CategoryState(
        counter: 0,
        categories: [
          '电子产品',
          '服装',
          '食品',
          '家居',
          '运动',
          '图书',
        ],
      );

  @override
  CategoryState copyWith({
    bool? isLoading,
    String? errorMessage,
    int? counter,
    List<String>? categories,
  }) {
    return CategoryState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      counter: counter ?? this.counter,
      categories: categories ?? this.categories,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.counter == counter &&
        other.categories == categories;
  }

  @override
  int get hashCode => isLoading.hashCode ^
      errorMessage.hashCode ^
      counter.hashCode ^
      categories.hashCode;
}

/// 分类页面 ViewModel
class CategoryViewModel extends StateNotifier<CategoryState> {
  CategoryViewModel() : super(CategoryState.initial());

  /// 增加计数器
  void incrementCounter() {
    state = state.copyWith(counter: state.counter + 1);
  }

  /// 添加分类
  void addCategory(String category) {
    final newCategories = List<String>.from(state.categories)..add(category);
    state = state.copyWith(categories: newCategories);
  }

  /// 移除分类
  void removeCategory(int index) {
    if (index >= 0 && index < state.categories.length) {
      final newCategories = List<String>.from(state.categories)..removeAt(index);
      state = state.copyWith(categories: newCategories);
    }
  }

  /// 重置状态
  void reset() {
    state = CategoryState.initial();
  }
}

/// 分类页面 ViewModel Provider
final categoryViewModelProvider = StateNotifierProvider<CategoryViewModel, CategoryState>((ref) {
  return CategoryViewModel();
});

/// 分类页面状态 Provider
final categoryStateProvider = Provider<CategoryState>((ref) {
  return ref.watch(categoryViewModelProvider);
});

/// 分类计数器 Provider
final categoryCounterProvider = Provider<int>((ref) {
  return ref.watch(categoryStateProvider).counter;
});

/// 分类列表 Provider
final categoryListProvider = Provider<List<String>>((ref) {
  return ref.watch(categoryStateProvider).categories;
}); 