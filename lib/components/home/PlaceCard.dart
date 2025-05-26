import 'package:flutter/material.dart';
import 'package:roomify/models/Property.dart';
import 'package:roomify/services/firebase_services.dart';

class PlaceCard extends StatelessWidget {
  final Property property;

  const PlaceCard({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Image>>(
      future: getImages(property.imagesUrls),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error al cargar propiedades'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay alquileres disponibles'));
        }
        final images = snapshot.data!;
        return Card(
          margin: EdgeInsets.all(20),
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/property/${property.uid}');
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    property.departmentType,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    property.description.length > 50
                        ? '${property.description.substring(0, 50)}...'
                        : property.description,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: images.length,
                      controller: PageController(viewportFraction: 0.9),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: double.infinity,
                              child: images[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
