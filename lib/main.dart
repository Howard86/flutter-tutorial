import 'package:firstapp/shopping_app/constant.dart';
import 'package:firstapp/shopping_app/data/grocery_item_repository.dart';
import 'package:firstapp/shopping_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

void main() async {
  await dotenv.load(fileName: '.env');

  getIt.registerSingleton<GroceryItemRepository>(
    GroceryItemRepository(
      baseUrl: dotenv.env['FIREBASE_REALTIME_DATABASE_URL']!,
      client: http.Client(),
    ),
  );

  runApp(const ShoppingApp());
}
