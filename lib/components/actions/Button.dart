import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double width;
  final double height;

  const Button({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.label = 'Registrarse',
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.fontSize = 16,
    this.width = double.infinity,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? CircularProgressIndicator(color: textColor)
            : Text(
                label,
                style: TextStyle(fontSize: fontSize, color: textColor),
              ),
      ),
    );
  }
}
