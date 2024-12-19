import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double verticalPadding;
  final double fontSize;

  const CustomElevatedButton({
    required this.text,
    required this.onPressed,
    required this.width,
    this.backgroundColor = Colors.black87,
    this.textColor = Colors.white,
    this.borderRadius = 35.0,
    this.verticalPadding = 16.0,
    this.fontSize = 22.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide.none,
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(vertical: verticalPadding),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: fontSize,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
