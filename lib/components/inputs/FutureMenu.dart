import 'package:flutter/material.dart';
import 'package:roomify/components/inputs/MultiComboBox.dart';

class FutureMenu extends StatelessWidget {
  final Future<List<String>> items;
  final List<String> itemsSelected;
  final String title;
  final String label;
  final Function(List<String>) onConfirm;

  const FutureMenu({
    Key? key,
    required this.items,
    required this.itemsSelected,
    required this.title,
    required this.label,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar $title'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay $title disponibles'));
        }

        return MultiComboBox(
          onConfirm: onConfirm,
          icon: Icons.arrow_drop_down,
          title: title,
          label: label,
          initialValues: itemsSelected,
          items: snapshot.data!,
        );
      },
    );
  }
}
