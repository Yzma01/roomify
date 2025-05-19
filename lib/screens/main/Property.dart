import 'package:flutter/material.dart';

class PropertyScreen extends StatelessWidget {
  final String id;

  const PropertyScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Propiedad'),),
      body: Column(
        children: [
          Text(id)
        ],
      ),
    );
  }
}
