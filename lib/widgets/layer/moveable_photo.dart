import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:polaroid_journal/models/layer_model.dart';

class MovablePhoto extends StatefulWidget {
  final LayerModel layer;
  final bool isFocused;
  final VoidCallback onFocus;

  const MovablePhoto({
    super.key,
    required this.layer,
    required this.isFocused,
    required this.onFocus,
  });

  @override
  State<MovablePhoto> createState() => _MovablePhotoState();
}

class _MovablePhotoState extends State<MovablePhoto> {
  double baseScale = 1.0;
  double baseRotation = 0.0;
  bool isBeingManipulated = false;

  @override
  Widget build(BuildContext context) {
    final layer = widget.layer;

    return Positioned(
      left: layer.position.dx,
      top: layer.position.dy,
      child: Transform.rotate(
        angle: layer.rotation,
        child: Transform.scale(
          scale: layer.scale,
          child: GestureDetector(
            onTap: () => widget.onFocus(),
            onScaleStart: (details) {
              setState(() {
                isBeingManipulated = true;
              });
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
              setState(() {
                isBeingManipulated = false;
              });
              widget.onFocus();
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: (widget.isFocused || isBeingManipulated)
                      ? Colors.blue
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200),
                child: ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: Image(image: layer.image!, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
