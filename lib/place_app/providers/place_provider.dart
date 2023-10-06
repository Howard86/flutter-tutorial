import 'dart:io';

import 'package:firstapp/place_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

import 'package:sqflite/sqflite.dart' as sql;

Future<sql.Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();

  return sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) => db.execute(
      'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
    ),
    version: 1,
  );
}

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final places = await db.query('user_places');

    state = places
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();
  }

  Future<Place> addPlace(
      String title, File image, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy(path.join(appDir.path, filename));

    final place = Place(
      title: title,
      image: copiedImage,
      location: location,
    );

    final db = await _getDatabase();

    db.insert('user_places', {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
      'lat': place.location.latitude,
      'lng': place.location.longitude,
      'address': place.location.address,
    });

    state = [...state, place];
    return place;
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) => PlacesNotifier(),
);
