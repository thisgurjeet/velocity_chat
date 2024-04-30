import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final FontWeight fontWeight;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.height,
    required this.width,
    required this.onPressed,
    required this.color,
    required this.textColor, // Default text color
    required this.fontWeight, // Default font weight
    this.fontSize = 20.0, // Default font size
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          // borderRadius: BorderRadius.circular(30)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
