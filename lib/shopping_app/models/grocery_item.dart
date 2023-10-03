import 'package:firstapp/shopping_app/data/categories.dart';
import 'package:firstapp/shopping_app/models/category.dart';

class GroceryItem {
  final String id;
  final String name;
  final int quantity;
  final Category category;

  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });

  factory GroceryItem.fromJson(Map<String, dynamic> json, String id) =>
      GroceryItem(
        id: id,
        name: json['name'],
        quantity: json['quantity'],
        category: categories.entries
            .firstWhere(
              (c) => c.value.name == json['category'],
            )
            .value,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'category': category.name,
      };
}
