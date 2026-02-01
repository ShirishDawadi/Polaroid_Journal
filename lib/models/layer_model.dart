import 'package:flutter/material.dart';
import 'package:whiteboard/whiteboard.dart';

enum LayerType { photo, text, drawing }

class LayerModel {
  final String id;
  final LayerType type;

  Offset position;
  double scale;
  double rotation;

  ImageProvider? image;
  WhiteBoardController? whiteBoardController;
  String? text;

  bool isBold;
  bool isItalic;
  bool isUnderline;
  Color? textColor;
  TextAlign textAlign;
  String? fontFamily;

  LayerModel({
    required this.id,
    required this.type,
    this.position = Offset.zero,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.image,
    this.whiteBoardController,
    this.text ='',
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.textColor = Colors.black,
    this.textAlign = TextAlign.center,
    this.fontFamily = 'Roboto',
  });
}
