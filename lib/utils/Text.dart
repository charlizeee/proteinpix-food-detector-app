import 'package:flutter/material.dart';
  
TextSpan buildTextSpan(String text, Color color, double sizeFont) {
  // double fontSize = 24; 
  return TextSpan(
    text: text,
    style: TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: sizeFont,
      shadows: [
        Shadow(
          offset: Offset(2.0, 2.0),
          blurRadius: 10.0,
          color: Color.fromRGBO(58, 64, 64, 0).withOpacity(0.6),
        ),
      ],
    ),
  );
}