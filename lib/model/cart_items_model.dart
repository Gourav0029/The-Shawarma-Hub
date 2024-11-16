import 'package:the_shawarma_hub/model/menu_items_model.dart';

class CartItem {
  String? itemId;
  String? name;
  String? description;
  int? price;
  String? category;
  String? photo;
  String? subCategory;
  int? quantity;

  CartItem({
    required this.itemId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.photo,
    required this.subCategory,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'item_id': itemId,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'photo': photo,
      'subCategory': subCategory,
      'quantity': quantity,
    };
  }

  // Method to convert MenuItem to CartItem
  factory CartItem.fromMenuItem(MenuItems menuItem, int quantity) {
    return CartItem(
      itemId: menuItem.itemId,
      name: menuItem.name,
      description: menuItem.description,
      price: menuItem.price,
      category: menuItem.category,
      photo: menuItem.photo,
      subCategory: menuItem.subCategory,
      quantity: quantity,
    );
  }
}
