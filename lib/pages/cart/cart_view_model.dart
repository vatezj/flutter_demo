import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/core/mvvm/base_view_model.dart';

/// 购物车商品模型
class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String image;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? image,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
    );
  }

  double get totalPrice => price * quantity;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        other.quantity == quantity &&
        other.image == image;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ price.hashCode ^ quantity.hashCode ^ image.hashCode;
}

/// 购物车页面状态类
class CartState extends BaseState {
  final int counter;
  final List<CartItem> items;

  const CartState({
    super.isLoading,
    super.errorMessage,
    required this.counter,
    required this.items,
  });

  factory CartState.initial() => CartState(
        counter: 0,
        items: [
          const CartItem(
            id: '1',
            name: 'iPhone 15',
            price: 5999.0,
            quantity: 1,
            image: '📱',
          ),
          const CartItem(
            id: '2',
            name: 'MacBook Pro',
            price: 12999.0,
            quantity: 1,
            image: '💻',
          ),
        ],
      );

  @override
  CartState copyWith({
    bool? isLoading,
    String? errorMessage,
    int? counter,
    List<CartItem>? items,
  }) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      counter: counter ?? this.counter,
      items: items ?? this.items,
    );
  }

  double get totalAmount {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.counter == counter &&
        other.items == items;
  }

  @override
  int get hashCode => isLoading.hashCode ^
      errorMessage.hashCode ^
      counter.hashCode ^
      items.hashCode;
}

/// 购物车页面 ViewModel
class CartViewModel extends StateNotifier<CartState> {
  CartViewModel() : super(CartState.initial());

  /// 增加计数器
  void incrementCounter() {
    state = state.copyWith(counter: state.counter + 1);
  }

  /// 增加商品数量
  void incrementItemQuantity(String itemId) {
    final newItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
    state = state.copyWith(items: newItems);
  }

  /// 减少商品数量
  void decrementItemQuantity(String itemId) {
    final newItems = state.items.map((item) {
      if (item.id == itemId && item.quantity > 1) {
        return item.copyWith(quantity: item.quantity - 1);
      }
      return item;
    }).toList();
    state = state.copyWith(items: newItems);
  }

  /// 移除商品
  void removeItem(String itemId) {
    final newItems = state.items.where((item) => item.id != itemId).toList();
    state = state.copyWith(items: newItems);
  }

  /// 清空购物车
  void clearCart() {
    state = state.copyWith(items: []);
  }

  /// 重置状态
  void reset() {
    state = CartState.initial();
  }
}

/// 购物车页面 ViewModel Provider
final cartViewModelProvider = StateNotifierProvider<CartViewModel, CartState>((ref) {
  return CartViewModel();
});

/// 购物车页面状态 Provider
final cartStateProvider = Provider<CartState>((ref) {
  return ref.watch(cartViewModelProvider);
});

/// 购物车计数器 Provider
final cartCounterProvider = Provider<int>((ref) {
  return ref.watch(cartStateProvider).counter;
});

/// 购物车商品列表 Provider
final cartItemsProvider = Provider<List<CartItem>>((ref) {
  return ref.watch(cartStateProvider).items;
});

/// 购物车总金额 Provider
final cartTotalAmountProvider = Provider<double>((ref) {
  return ref.watch(cartStateProvider).totalAmount;
});

/// 购物车商品总数 Provider
final cartTotalItemsProvider = Provider<int>((ref) {
  return ref.watch(cartStateProvider).totalItems;
}); 