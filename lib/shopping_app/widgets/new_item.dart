import 'package:firstapp/shopping_app/constant.dart';
import 'package:firstapp/shopping_app/data/categories.dart';
import 'package:firstapp/shopping_app/data/grocery_item_repository.dart';
import 'package:firstapp/shopping_app/models/category.dart';
import 'package:flutter/material.dart';

class NewItem extends StatefulWidget {
  const NewItem({
    super.key,
  });

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();

  var _name = '';
  var _quantity = 1;
  var _category = categories[Categories.vegetables]!;
  var _isLoading = false;
  var _error = '';

  void _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final item = await getIt<GroceryItemRepository>().addGroceryItem((
        name: _name,
        quantity: _quantity,
        category: _category,
      ));

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(item);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  void _resetItem() {
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                maxLength: 50,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Must be between 1 and 50 characters.'
                    : null,
                onSaved: (newValue) => _name = newValue!,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                      ),
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          (value == null || int.tryParse(value) == null)
                              ? 'Must be a valid positive number.'
                              : null,
                      onSaved: (newValue) => _quantity = int.parse(newValue!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _category,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.name),
                              ],
                            ),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _category = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : _resetItem,
                    child: const Text('Reset'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveItem,
                    child: _isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Add Item'),
                  )
                ],
              ),
              if (_error.isNotEmpty)
                Text(
                  _error,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
