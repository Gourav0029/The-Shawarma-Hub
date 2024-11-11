// ignore_for_file: constant_identifier_names

import 'dart:convert';

List<MenuItems> menuItemsFromJson(String str) =>
    List<MenuItems>.from(json.decode(str).map((x) => MenuItems.fromJson(x)));

String menuItemsToJson(List<MenuItems> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MenuItems {
  String? itemId;
  String? name;
  String? description;
  int? price;
  String? category;
  String? photo;
  String? subCategory;

  MenuItems({
    this.itemId,
    this.name,
    this.description,
    this.price,
    this.category,
    this.photo,
    this.subCategory,
  });

  factory MenuItems.fromJson(Map<String, dynamic> json) => MenuItems(
        itemId: json["item_id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        category: json["category"],
        photo: json["photo"],
        subCategory: json["subCategory"],
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "name": name,
        "description": description,
        "price": price,
        "category": category,
        "photo": photo,
        "subCategory": subCategory,
      };
}
