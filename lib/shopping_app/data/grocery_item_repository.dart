import 'dart:convert';

import 'package:firstapp/shopping_app/models/category.dart';
import 'package:firstapp/shopping_app/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class GroceryItemRepository {
  const GroceryItemRepository({required this.baseUrl, required this.client});

  final String baseUrl;
  final http.Client client;
  final String _groceryItemPath = 'grocery_items';

  Future<List<GroceryItem>> getGroceryItems() async {
    final response = await client.get(
      Uri.https(
        baseUrl,
        '$_groceryItemPath.json',
      ),
    );

    if (response.statusCode >= 400) {
      throw Exception('Failed to fetch grocery items');
    }

    final responseData = json.decode(response.body) as Map<String, dynamic>;

    final List<GroceryItem> loadedItems = [];

    responseData.forEach((key, value) {
      loadedItems.add(
        GroceryItem.fromJson(value, key),
      );
    });

    return loadedItems;
  }

  Future<GroceryItem> addGroceryItem(
      ({
        String name,
        int quantity,
        Category category,
      }) item) async {
    final response = await client.post(
      Uri.https(
        baseUrl,
        '$_groceryItemPath.json',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': item.name,
        'quantity': item.quantity,
        'category': item.category.name,
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('Failed to add grocery item');
    }

    final responseData = json.decode(response.body) as Map<String, dynamic>;

    return GroceryItem(
      id: responseData['name']!,
      name: item.name,
      quantity: item.quantity,
      category: item.category,
    );
  }

  Future<void> deleteGroceryItem(String id) async {
    final response = await client.delete(
      Uri.https(
        baseUrl,
        '$_groceryItemPath/$id.json',
      ),
    );

    if (response.statusCode >= 400) {
      throw Exception('Failed to delete grocery item');
    }
  }
}
