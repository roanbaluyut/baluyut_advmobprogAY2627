import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/cart.dart';
import '../models/product.dart';

class CartService {
  // Session persistent cache mapping userId -> List<CartProduct>
  static final Map<int, List<CartProduct>> _localCartProducts = {};

  Future<List<Cart>> getCartsByUser(int userId) async {
    // Return local state if already populated
    if (_localCartProducts.containsKey(userId)) {
      return [_buildCartFromLocal(userId)];
    }

    try {
      final response = await http.get(Uri.parse('$host/carts/user/$userId'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List cartsJson = data['carts'] ?? [];
        final carts = cartsJson.map((json) => Cart.fromJson(json)).toList();

        if (carts.isNotEmpty) {
          _localCartProducts[userId] = List.from(carts.first.products);
          return [_buildCartFromLocal(userId)];
        }
      }
    } catch (_) {}

    _localCartProducts.putIfAbsent(userId, () => []);
    return [_buildCartFromLocal(userId)];
  }

  // Handles adding the current product to the active user's cart
  Future<Cart> addToCartProduct(
    int userId,
    Product product, {
    int quantity = 1,
  }) async {
    final currentItems = _localCartProducts.putIfAbsent(userId, () => []);
    final existingIndex = currentItems.indexWhere(
      (item) => item.id == product.id,
    );

    if (existingIndex >= 0) {
      final existing = currentItems[existingIndex];
      final newQty = existing.quantity + quantity;
      final newTotal = product.price * newQty;
      final newDiscounted = newTotal * (1 - (product.discountPercentage / 100));

      currentItems[existingIndex] = CartProduct(
        id: product.id,
        title: product.title,
        price: product.price,
        quantity: newQty,
        total: newTotal,
        discountPercentage: product.discountPercentage,
        discountedTotal: newDiscounted,
        thumbnail: product.thumbnail,
      );
    } else {
      final total = product.price * quantity;
      final discountedTotal = total * (1 - (product.discountPercentage / 100));

      currentItems.add(
        CartProduct(
          id: product.id,
          title: product.title,
          price: product.price,
          quantity: quantity,
          total: total,
          discountPercentage: product.discountPercentage,
          discountedTotal: discountedTotal,
          thumbnail: product.thumbnail,
        ),
      );
    }

    return _buildCartFromLocal(userId);
  }

  void updateQuantity(int userId, int productId, int delta) {
    final items = _localCartProducts[userId];
    if (items == null) return;

    final index = items.indexWhere((item) => item.id == productId);
    if (index == -1) return;

    final item = items[index];
    final newQuantity = item.quantity + delta;

    if (newQuantity <= 0) {
      items.removeAt(index);
    } else {
      final newTotal = item.price * newQuantity;
      final newDiscounted = newTotal * (1 - (item.discountPercentage / 100));

      items[index] = CartProduct(
        id: item.id,
        title: item.title,
        price: item.price,
        quantity: newQuantity,
        total: newTotal,
        discountPercentage: item.discountPercentage,
        discountedTotal: newDiscounted,
        thumbnail: item.thumbnail,
      );
    }
  }

  void removeItem(int userId, int productId) {
    _localCartProducts[userId]?.removeWhere((item) => item.id == productId);
  }

  Cart _buildCartFromLocal(int userId) {
    final products = _localCartProducts[userId] ?? [];
    double total = 0.0;
    double discountedTotal = 0.0;
    int totalQuantity = 0;

    for (final item in products) {
      total += item.total;
      discountedTotal += item.discountedTotal;
      totalQuantity += item.quantity;
    }

    return Cart(
      id: userId,
      products: List.from(products),
      total: total,
      discountedTotal: discountedTotal,
      userId: userId,
      totalProducts: products.length,
      totalQuantity: totalQuantity,
    );
  }
}
