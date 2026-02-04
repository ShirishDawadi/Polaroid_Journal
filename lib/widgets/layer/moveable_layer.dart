import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:polaroid_journal/models/layer_model.dart';

class MovableLayer extends StatefulWidget {
  final LayerModel layer;
  final bool isFocused;
  final VoidCallback onFocus;
  final Widget child;
  final bool resetTransformWhenFocused; 

  const MovableLayer({
    super.key,
    required this.layer,
    required this.isFocused,
    required this.onFocus,
    required this.child,
    this.resetTransformWhenFocused = false,
  });

  @override
  State<MovableLayer> createState() => _MovableLayerState();
}

class _MovableLayerState extends State<MovableLayer> {
  double baseScale = 1.0;
  double baseRotation = 0.0;
  bool isBeingManipulated = false;

  @override
  Widget build(BuildContext context) {
    final layer = widget.layer;
    final shouldReset = widget.resetTransformWhenFocused && 
                        widget.isFocused && 
                        !isBeingManipulated;

    return Positioned(
      left: shouldReset ? 0 : layer.position.dx,
      top: shouldReset ? 0 : layer.position.dy,
      child: Transform.rotate(
        angle: shouldReset ? 0 : layer.rotation,
        child: Transform.scale(
          scale: shouldReset ? 1 : layer.scale,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: widget.onFocus,
            onScaleStart: (details) {
              setState(() => isBeingManipulated = true);
              baseScale = layer.scale;
              baseRotation = layer.rotation;
            },
            onScaleUpdate: (details) {
              setState(() {
                layer.scale = baseScale * details.scale;
                layer.rotation = baseRotation + details.rotation;

                if (details.pointerCount > 1) return;

                final dx = details.focalPointDelta.dx;
                final dy = details.focalPointDelta.dy;
                final cos = math.cos(layer.rotation);
                final sin = math.sin(layer.rotation);

                layer.position = Offset(
                  layer.position.dx + (dx * cos - dy * sin) * layer.scale,
                  layer.position.dy + (dx * sin + dy * cos) * layer.scale,
                );
              });
            },
            onScaleEnd: (details) {
              setState(() => isBeingManipulated = false);
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}