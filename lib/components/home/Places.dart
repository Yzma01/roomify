import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomify/components/home/PlaceCard.dart';
import 'package:roomify/components/hooks/UserProvider.dart';
import 'package:roomify/models/Property.dart';
import 'package:roomify/services/firebase_services.dart';

class Places extends StatelessWidget {
  const Places({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Property>>(
      future: getProperties(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error al cargar las alquileres'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay alquileres disponibles'));
        }

        final collection = snapshot.data!;

        return Column(
          children:
              collection.map((item) => PlaceCard(property: item)).toList(),
        );
      },
    );
  }
}
