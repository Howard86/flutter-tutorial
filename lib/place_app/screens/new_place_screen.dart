import 'dart:io';

import 'package:firstapp/place_app/models/place.dart';
import 'package:firstapp/place_app/providers/place_provider.dart';
import 'package:firstapp/place_app/widgets/image_input.dart';
import 'package:firstapp/place_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlaceScreen extends ConsumerStatefulWidget {
  const NewPlaceScreen({super.key});

  @override
  ConsumerState<NewPlaceScreen> createState() => _NewPlaceScreenState();
}

class _NewPlaceScreenState extends ConsumerState<NewPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  File? _pickedImage;
  PlaceLocation? _pickedLocation;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onAddPlace() {
    if (!_formKey.currentState!.validate() ||
        _pickedImage == null ||
        _pickedLocation == null) {
      return;
    }

    final place = ref.read(placesProvider.notifier).addPlace(
          _titleController.text,
          _pickedImage!,
          _pickedLocation!,
        );
    Navigator.of(context).pop(place);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Place'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ImageInput(
                onImagePicked: (image) => _pickedImage = image,
              ),
              const SizedBox(height: 10),
              LocationInput(
                onLocationPicked: (location) => _pickedLocation = location,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: _onAddPlace,
                icon: const Icon(Icons.add),
                label: const Text('Add Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
