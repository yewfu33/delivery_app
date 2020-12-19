import 'package:flutter/material.dart';

InputDecoration myDecoration(String text, {String helperText}) {
  return InputDecoration(
    helperText: helperText,
    helperMaxLines: 2,
    contentPadding: EdgeInsets.zero,
    labelText: text,
    labelStyle: const TextStyle(fontSize: 18, letterSpacing: 0.4),
  );
}

TextStyle customInputStyle(
    {final double fontSize = 18, final double letterSpacing = 0.4}) {
  return TextStyle(
    fontSize: fontSize,
    letterSpacing: letterSpacing,
  );
}
