import 'package:firstapp/meal_app/providers/favorites_provider.dart';
import 'package:firstapp/meal_app/providers/filters_provider.dart';
import 'package:firstapp/meal_app/screens/categories.dart';
import 'package:firstapp/meal_app/screens/filters.dart';
import 'package:firstapp/meal_app/screens/meals.dart';
import 'package:firstapp/meal_app/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() => _selectedPageIndex = index);
  }

  void _setScreen(MainDrawerItem item) async {
    Navigator.of(context).pop();
    if (item == MainDrawerItem.filters) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        0 => CategoriesScreen(availableMeals: ref.watch(filteredMealsProvider)),
        1 => MealsScreen(meals: ref.watch(favouriteMealsProvider)),
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
