import 'package:flutter/material.dart';
import 'package:roomify/components/home/FullImage.dart';
import 'package:roomify/components/home/Places.dart';
import 'package:roomify/components/home/Property.dart';

class PropertyScreen extends StatefulWidget {
  final String id;

  const PropertyScreen({Key? key, required this.id}) : super(key: key);

  @override
  _PropertyScreenState createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {
  late Future<List<Image>> images;
  late Future<Property> property;
  Future<Property> getPropertyDetails() async {
    return Places.getPlaces()[int.parse(widget.id)];
    ;
  }

  @override
  void initState() {
    super.initState();
    property = getPropertyDetails();
  }

  Widget imagesHero({required List<Image> images}) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Propiedad')),
      body: FutureBuilder<Property>(
        future: property,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay Imágenes'));
          }
          final propertyData = snapshot.data!;
          final images = propertyData.images;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                imagesHero(images: images),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    propertyData.location,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
