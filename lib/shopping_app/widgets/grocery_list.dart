import 'package:firstapp/shopping_app/data/dummy_items.dart';
import 'package:firstapp/shopping_app/models/grocery_item.dart';
import 'package:firstapp/shopping_app/widgets/new_item.dart';
import 'package:flutter/material.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({
    super.key,
  });

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItemList = groceryItems;

  void _onAddItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItemList.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _onAddItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _groceryItemList.isNotEmpty
          ? ListView.builder(
              itemCount: _groceryItemList.length,
              itemBuilder: (ctx, index) => Dismissible(
                key: ValueKey(_groceryItemList[index].id),
                onDismissed: (direction) => {
                  ScaffoldMessenger.of(context).clearSnackBars(),
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${_groceryItemList[index].name} deleted!'),
                      duration: const Duration(seconds: 2),
                    ),
                  ),
                  setState(() {
                    _groceryItemList.removeAt(index);
                  }),
                },
                background: Container(
                  color: Theme.of(context).colorScheme.error,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 4,
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    width: 24,
                    height: 24,
                    color: _groceryItemList[index].category.color,
                  ),
                  title: Text(_groceryItemList[index].name),
                  subtitle: Text(_groceryItemList[index].category.name),
                  trailing: Text('${_groceryItemList[index].quantity}'),
                ),
              ),
            )
          : const Center(
              child: Text('No items yet!'),
            ),
    );
  }
}
