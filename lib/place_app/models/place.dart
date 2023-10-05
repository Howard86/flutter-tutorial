import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  final String id;
  final String title;
  final File image;
  final PlaceLocation location;

  Place({
    required this.title,
    required this.image,
    required this.location,
    String? id,
  }) : id = id ?? uuid.v4();
}

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  String get mapImageUrl =>
      "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=${dotenv.env['GOOGLE_API_KEY']}";

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}
