import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomify/components/home/PlaceCard.dart';
import 'package:roomify/components/home/Property.dart';
import 'package:roomify/components/hooks/UserProvider.dart';

class Places extends StatelessWidget {
  const Places({Key? key}) : super(key: key);

  // aquí debo de sacar las imágenes por cada lugar que haya, que pereza :'(
  List<Image> getImages(id) {
    final List<Image> images = [];
    List<String> collection = [
      'assets/images/casa1.jpg',
      'assets/images/casa2.jpg',
      'assets/images/casa3.jpg',
    ];
    for (var element in collection) {
      images.add(Image.asset(element));
    }
    return images;
  }

  List<Property> getPlaces() {
    List<Property> collection = [];
    for (var i = 0; i < 10; i++) {
      collection.add(
        Property(
          id: i.toString(),
          images: getImages(i.toString()),
          location: 'location$i',
          name: 'name$i',
        ),
      );
    }
    return collection;
  }

  @override
  Widget build(BuildContext context) {
    final collection = getPlaces();
    return Column(
      children: [
        ...collection.map(
          (item) => PlaceCard(
            images: item.images,
            location: item.location,
            name: item.name,
            id: item.id,
          ),
        ),
      ],
    );
  }
}
