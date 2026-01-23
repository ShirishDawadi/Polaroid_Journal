import 'package:flutter/material.dart';
import 'package:whiteboard/whiteboard.dart';
import 'package:polaroid_journal/models/layer_model.dart';

class DrawingLayer extends StatelessWidget {
  final LayerModel layer;
  final bool isActive;
  final Color currentBrushColor;
  final double strokeWidth;
  final bool isErasing;

  const DrawingLayer({
    super.key,
    required this.layer,
    required this.isActive,
    required this.currentBrushColor,
    required this.strokeWidth,
    required this.isErasing,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !isActive,
        child: WhiteBoard(
          controller: layer.whiteBoardController!,
          backgroundColor: Colors.transparent,
          strokeColor: currentBrushColor,
          strokeWidth: strokeWidth,
          isErasing: isErasing,
        ),
      ),
    );
  }
}
