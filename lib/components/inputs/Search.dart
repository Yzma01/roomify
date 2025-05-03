import 'package:flutter/material.dart';
import 'package:roomify/components/inputs/Input.dart';

class Search extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;

  const Search({
    Key? key,
    required this.controller,
    required this.label,
    this.suffixIcon,
    this.prefixIcon,
    this.padding = const EdgeInsets.only(bottom: 16.0),
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Input(
        controller: controller,
        label: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        centerLabel: true,
        padding: padding,
        decoration: decoration,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese un lugar';
          }
        },
      ),
    );
  }
}
