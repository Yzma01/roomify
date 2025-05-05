import 'package:flutter/widgets.dart';

class Property {
  final String location;
  final String name;
  final String id;
  final List<Image> images;

  Property({
    required this.id,
    required this.images,
    required this.location,
    required this.name,
  });
}