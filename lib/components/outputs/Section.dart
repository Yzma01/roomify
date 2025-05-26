import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final Alignment alignment;
  final EdgeInsetsGeometry padding;

  const Section({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w500,
    this.alignment = Alignment.centerLeft,
    this.padding = const EdgeInsets.only(bottom: 8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Align(
        alignment: alignment,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          ),
        ),
      ),
    );
  }
}
