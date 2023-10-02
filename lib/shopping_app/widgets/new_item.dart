import 'package:firstapp/shopping_app/data/categories.dart';
import 'package:firstapp/shopping_app/models/category.dart';
import 'package:firstapp/shopping_app/models/grocery_item.dart';
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

  void _saveItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    Navigator.of(context).pop(
      GroceryItem(
        id: DateTime.now().toString(),
        name: _name,
        quantity: _quantity,
        category: _category,
      ),
    );
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
                    onPressed: _resetItem,
                    child: const Text('Reset'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Add Item'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
