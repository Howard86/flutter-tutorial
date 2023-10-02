import 'package:firstapp/meal_app/models/meal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesMealsNotifier extends StateNotifier<List<Meal>> {
  FavoritesMealsNotifier() : super([]);

  bool toggleFavoriteStatus(Meal meal) {
    bool isExisting = state.contains(meal);
    state = isExisting
        ? state.where((m) => m.id != meal.id).toList()
        : [...state, meal];

    return !isExisting;
  }
}

final favouriteMealsProvider =
    StateNotifierProvider<FavoritesMealsNotifier, List<Meal>>(
        (ref) => FavoritesMealsNotifier());
