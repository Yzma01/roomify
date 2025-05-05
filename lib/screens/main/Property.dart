import 'package:flutter/material.dart';

class PropertyScreen extends StatelessWidget {
  final String id;

  const PropertyScreen({Key? key, required this.id}) : super(key: key);

  Widget _topBar(context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        const Spacer(),
        Text(style: TextStyle(fontSize: 20), 'Propiedad'),
        const Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            width: double.infinity,
          ),
          _topBar(context),
        ],
      ),
    );
  }
}
