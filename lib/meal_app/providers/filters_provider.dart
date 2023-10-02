import 'package:firstapp/meal_app/providers/meals_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegan,
  vegetarian,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier() : super({});

  void toggleFilter(Filter filter) {
    state = {
      ...state,
      filter: !(state[filter] ?? false),
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final filters = ref.watch(filtersProvider);

  return meals.where((meal) {
    if (filters[Filter.glutenFree] == true && !meal.isGlutenFree) {
      return false;
    }

    if (filters[Filter.lactoseFree] == true && !meal.isLactoseFree) {
      return false;
    }

    if (filters[Filter.vegan] == true && !meal.isVegan) {
      return false;
    }

    if (filters[Filter.vegetarian] == true && !meal.isVegetarian) {
      return false;
    }

    return true;
  }).toList();
});
