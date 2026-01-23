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
  String? text;
  WhiteBoardController? whiteBoardController;

  LayerModel({
    required this.id,
    required this.type,
    this.position = Offset.zero,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.image,
    this.text,
    this.whiteBoardController,
  });
}
