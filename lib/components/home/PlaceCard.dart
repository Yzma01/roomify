import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  final String name;
  final List<Image> images;
  final String location;
  final String id;

  const PlaceCard({
    Key? key,
    required this.images,
    required this.location,
    required this.name,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    images.shuffle();
    return Card(
      margin: EdgeInsets.all(20),
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/property/$id');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(location, style: TextStyle(color: Colors.grey)),
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
  }
}
