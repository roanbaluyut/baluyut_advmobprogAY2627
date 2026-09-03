import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// models
import '../models/cart.dart';

// services
import '../services/cart_service.dart';
import '../services/product_service.dart';
import '../services/user_service.dart';

// screens
import 'product_detail_screen.dart';

// widgets
import '../widgets/custom_text.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  final ProductService _productService = ProductService();
  final UserService _userService = UserService();

  int _userId = 3;
  late Future<List<Cart>> _cartsFuture;

  @override
  void initState() {
    super.initState();
    _cartsFuture = _loadInitialCart();
  }

  // Synchronously assigns the initial Future so build() never encounters an uninitialized field
  Future<List<Cart>> _loadInitialCart() async {
    final user = await _userService.getUser();
    _userId = user.id != 0 ? user.id : 3;
    return _cartService.getCartsByUser(_userId);
  }

  Future<void> _openDetails(int productId) async {
    try {
      final product = await _productService.getProductById(productId);
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ProductDetailsScreen(product: product, showAddToCart: false),
        ),
      );
      setState(() {
        _cartsFuture = _cartService.getCartsByUser(_userId);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to open product: $e')));
    }
  }

  void _changeQuantity(int itemId, int delta) {
    setState(() {
      _cartService.updateQuantity(_userId, itemId, delta);
      _cartsFuture = _cartService.getCartsByUser(_userId);
    });
  }

  void _deleteItem(int itemId) {
    setState(() {
      _cartService.removeItem(_userId, itemId);
      _cartsFuture = _cartService.getCartsByUser(_userId);
    });
  }

  void _confirmOrder() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Order confirmed')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: FutureBuilder<List<Cart>>(
        future: _cartsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: CustomText(text: 'Error: ${snapshot.error}'));
          }

          final carts = snapshot.data ?? [];
          final products = carts.isNotEmpty
              ? carts.first.products
              : <CartProduct>[];

          if (products.isEmpty) {
            return const Center(child: CustomText(text: 'Your cart is empty'));
          }

          final cart = carts.first;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(12.r),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final item = products[index];
                    // Swipe-to-delete wrapper inside the cart list builder
                    return Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.w),
                        margin: EdgeInsets.only(bottom: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      onDismissed: (direction) {
                        _deleteItem(item.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.title} removed from cart'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.only(bottom: 12.h),
                        child: InkWell(
                          onTap: () => _openDetails(item.id),
                          borderRadius: BorderRadius.circular(12.r),
                          child: Padding(
                            padding: EdgeInsets.all(8.r),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.network(
                                    item.thumbnail,
                                    width: 56.w,
                                    height: 56.h,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Icon(Icons.image, size: 32.sp),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: item.title,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          CustomText(
                                            text:
                                                '\$${item.price.toStringAsFixed(2)}',
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          SizedBox(width: 8.w),
                                          if (item.discountPercentage > 0)
                                            DefaultTextStyle.merge(
                                              style: const TextStyle(
                                                color: Colors.red,
                                              ),
                                              child: CustomText(
                                                text:
                                                    '-${item.discountPercentage.toStringAsFixed(0)}%',
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add_circle, size: 20.sp),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () =>
                                          _changeQuantity(item.id, 1),
                                    ),
                                    SizedBox(height: 4.h),
                                    CustomText(
                                      text: '${item.quantity}',
                                      fontSize: 13.sp,
                                    ),
                                    SizedBox(height: 4.h),
                                    IconButton(
                                      icon: Icon(
                                        Icons.remove_circle,
                                        size: 20.sp,
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () =>
                                          _changeQuantity(item.id, -1),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: theme.dividerColor)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: 'Subtotal', fontSize: 14.sp),
                        CustomText(
                          text: '\$${cart.total.toStringAsFixed(2)}',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: _confirmOrder,
                        child: CustomText(
                          text: 'Confirm Order',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
