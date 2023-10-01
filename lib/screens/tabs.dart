import 'package:firstapp/data/dummy_data.dart';
import 'package:firstapp/models/meal.dart';
import 'package:firstapp/screens/categories.dart';
import 'package:firstapp/screens/filters.dart';
import 'package:firstapp/screens/meals.dart';
import 'package:firstapp/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  final Map<Filter, bool> _filters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegan: false,
    Filter.vegetarian: false,
  };

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleFavoriteMeal(Meal meal) {
    var isExisting = _favoriteMeals.contains(meal);
    setState(() {
      if (isExisting) {
        _favoriteMeals.remove(meal);
      } else {
        _favoriteMeals.add(meal);
      }
    });
    _showInfoMessage(
      isExisting
          ? '${meal.title} removed from favorites!'
          : '${meal.title} added to favorites!',
    );
  }

  void _selectPage(int index) {
    setState(() => _selectedPageIndex = index);
  }

  void _setScreen(MainDrawerItem item) async {
    Navigator.of(context).pop();
    if (item == MainDrawerItem.filters) {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(currentFilters: _filters),
        ),
      );

      if (result != null) {
        setState(() {
          for (final filter in result.keys) {
            _filters[filter] = result[filter]!;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_filters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }

      if (_filters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }

      if (_filters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }

      if (_filters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }

      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: switch (_selectedPageIndex) {
          0 => const Text('Categories'),
          1 => const Text('Favorites'),
          _ => throw Exception('Invalid page index'),
        },
      ),
      drawer: MainDrawer(
        onSelectItem: _setScreen,
      ),
      body: switch (_selectedPageIndex) {
        0 => CategoriesScreen(
            availableMeals: availableMeals,
            onToggleFavorite: _toggleFavoriteMeal,
          ),
        1 => MealsScreen(
            meals: _favoriteMeals,
            onToggleFavorite: _toggleFavoriteMeal,
          ),
        _ => throw Exception('Invalid page index'),
      },
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
