import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MultiComboBox extends StatelessWidget {
  final List<String> items;
  final String label;
  final String title;
  final IconData? icon;
  final List<String> initialValues;
  final Function(List<String>) onConfirm;

  const MultiComboBox({
    Key? key,
    required this.items,
    required this.title,
    required this.label,
    required this.initialValues,
    required this.onConfirm,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: MultiSelectDialogField<String>(
        items: items.map((e) => MultiSelectItem<String>(e, e)).toList(),
        title: Text(title),
        selectedColor: Colors.blue,
        decoration: const BoxDecoration(
          border: Border(),
        ),
        buttonIcon: icon != null ? Icon(icon, color: Colors.grey[700]) : null,
        buttonText: Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        initialValue: initialValues,
        onConfirm: (results) {
          onConfirm(results.cast<String>());
        },
        dialogHeight: 400,
      ),
    );
  }
}
