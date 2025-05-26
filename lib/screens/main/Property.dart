import 'package:flutter/material.dart';
import 'package:roomify/components/home/FullImage.dart';
import 'package:roomify/models/Property.dart';
import 'package:roomify/services/firebase_services.dart';

class PropertyScreen extends StatefulWidget {
  final String id;

  const PropertyScreen({Key? key, required this.id}) : super(key: key);

  @override
  _PropertyScreenState createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {
  late Future<List<Image>> images;
  late Future<Property?> property;
  @override
  void initState() {
    super.initState();
    property = getProperty(widget.id);
  }

  Widget imagesHero({required List<String>? imagesUrls}) {
    return FutureBuilder<List<Image>>(
      future: getImages(imagesUrls),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error al cargar las imágenes');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No hay imágenes'));
        }
        final images = snapshot.data!;
        return SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: images.length,
            controller: PageController(viewportFraction: 0.9),
            itemBuilder: (context, index) {
              final image = images[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => FullScreenGallery(
                            images: images,
                            initialIndex: index,
                          ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(width: double.infinity, child: image),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Propiedad')),
      body: FutureBuilder<Property?>(
        future: property,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final propertyData = snapshot.data!;
          final images = propertyData.imagesUrls;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  imagesHero(imagesUrls: images),
                  propertyData.buildPropertyDetails(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
