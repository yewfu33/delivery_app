import 'package:flutter/material.dart';

final double letterSpacing = 0.4;
final double fontSize = 18;

InputDecoration myDecoration(String text, String helperText) {
  return InputDecoration(
    helperText: helperText,
    helperMaxLines: 2,
    contentPadding: EdgeInsets.zero,
    labelText: text,
    labelStyle: TextStyle(
      fontSize: fontSize,
      letterSpacing: letterSpacing,
    ),
  );
}
