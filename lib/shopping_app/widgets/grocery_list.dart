import 'package:firstapp/shopping_app/constant.dart';
import 'package:firstapp/shopping_app/data/grocery_item_repository.dart';
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
  final List<GroceryItem> _groceryItemList = [];

  var _isLoading = true;
  var _error = '';

  @override
  void initState() {
    super.initState();

    getIt<GroceryItemRepository>().getGroceryItems().then(
      (items) {
        if (!context.mounted) {
          return;
        }

        setState(
          () {
            _groceryItemList.clear();
            _groceryItemList.addAll(items);
            _isLoading = false;
          },
        );
      },
    ).catchError(
      (e) {
        if (!context.mounted) {
          return;
        }

        setState(
          () {
            _error = e.toString();
            _isLoading = false;
          },
        );
      },
    );
  }

  Future<void> _onAddItem() async {
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

  Future<void> _onDeleteItem(int index) async {
    final item = _groceryItemList[index];
    var snackbarText = '';

    try {
      setState(() {
        _groceryItemList.removeAt(index);
      });
      await getIt<GroceryItemRepository>().deleteGroceryItem(
        item.id,
      );

      snackbarText = '${_groceryItemList[index].name} deleted!';
    } catch (e) {
      setState(() {
        _groceryItemList.insert(index, item);
      });
      snackbarText = 'Failed to delete ${_groceryItemList[index].name}!';
    }

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackbarText),
        duration: const Duration(seconds: 2),
      ),
    );
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
      body: Builder(
        builder: (ctx) {
          if (_isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_error.isNotEmpty) {
            return Center(
              child: Text(_error),
            );
          }

          if (_groceryItemList.isEmpty) {
            return const Center(
              child: Text('No items yet!'),
            );
          }

          return ListView.builder(
            itemCount: _groceryItemList.length,
            itemBuilder: (ctx, index) => Dismissible(
              key: ValueKey(_groceryItemList[index].id),
              onDismissed: (_) => _onDeleteItem(index),
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
          );
        },
      ),
    );
  }
}
