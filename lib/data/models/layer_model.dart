import 'package:flutter/material.dart';
import 'package:whiteboard/whiteboard.dart';

enum LayerType { photo, text, drawing }

class LayerModel {
  final String id;
  final LayerType type;

  final Offset position;
  final double scale;
  final double rotation;

  final ImageProvider? image;
  final WhiteBoardController? whiteBoardController;
  final String? text;

  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final Color? textColor;
  final TextAlign textAlign;
  final String? fontFamily;

  const LayerModel({
    required this.id,
    required this.type,
    this.position = Offset.zero,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.image,
    this.whiteBoardController,
    this.text = '',
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.textColor = Colors.black,
    this.textAlign = TextAlign.center,
    this.fontFamily = 'Roboto',
  });

  LayerModel copyWith({
    String? id,
    LayerType? type,
    Offset? position,
    double? scale,
    double? rotation,
    ImageProvider? image,
    WhiteBoardController? whiteBoardController,
    String? text,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    Color? textColor,
    TextAlign? textAlign,
    String? fontFamily,
  }) {
    return LayerModel(
      id: id ?? this.id,
      type: type ?? this.type,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      image: image ?? this.image,
      whiteBoardController: whiteBoardController ?? this.whiteBoardController,
      text: text ?? this.text,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      textColor: textColor ?? this.textColor,
      textAlign: textAlign ?? this.textAlign,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}