import 'package:get/get.dart';
import 'package:the_shawarma_hub/helper/cart_db_helper.dart';

class CartController extends GetxController {
  RxInt cartItemCount = 0.obs;

  // Reactive cart count variable
  @override
  void onInit() {
    super.onInit();
    _loadCartItemCount(); // Load the initial cart count
  }

  Future<void> _loadCartItemCount() async {
    final dbHelper = CartDatabaseHelper();
    int count = await dbHelper.getCartItemCount();
    cartItemCount.value = count;
  }

  Future<void> updateCartItemCount() async {
    final dbHelper = CartDatabaseHelper();
    int count = await dbHelper.getCartItemCount();
    cartItemCount.value = count;
    _loadCartItemCount();
  }
}
