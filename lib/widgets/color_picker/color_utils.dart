import 'package:flutter/material.dart';

String colorToHex(Color color) {
  return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
}

HSVColor? hsvFromHex(String value) {
  try {
    value = value.trim();
    String hex = value.startsWith('#') ? value.substring(1) : value;
    hex = hex.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
    if (hex.length == 6) {
      final color = Color(int.parse('FF$hex', radix: 16));
      return HSVColor.fromColor(color);
    }
  } catch (_) {}
  return null;
}
