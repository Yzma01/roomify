import 'package:flutter/material.dart';
import 'package:roomify/components/home/PlaceCard.dart';
import 'package:roomify/models/Property.dart';

class Places extends StatelessWidget {
  final List<Property> properties;
  final bool isLoading;

  const Places({Key? key, required this.properties, this.isLoading = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando propiedades...'),
            ],
          ),
        ),
      );
    }
    
    if (properties.isEmpty) {
      return Center(
        child: Text('No hay propiedades que coincidan con los filtros'),
      );
    }

    return ListView.separated(
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        return PlaceCard(property: property);
      },
      separatorBuilder: (context, index) => SizedBox(height: 5),
    );
  }
}
