import 'package:flutter/material.dart';

class CustomizeButton extends StatelessWidget {
  final Color color;
  final Color textcolor;
  final double height;
  final double width;
  final VoidCallback onPressed;
  final String text;
  final String fontfamily;
  final fontweightt;

  const CustomizeButton({super.key, 
    required this.color,
    required this.textcolor,
    required this.height,
    required this.width,
    required this.onPressed,
    required this.text,
    required this.fontfamily,
    required this.fontweightt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: color != null
          ? BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(25),
            )
          : null,
      height: height,
      width: width,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: textcolor,
              fontSize: 20,
              fontFamily: fontfamily,
              fontWeight: fontweightt),
        ),
      ),
    );
  }
}
