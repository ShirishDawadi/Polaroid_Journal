import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class MovablePhoto extends StatefulWidget {
  final File image;
  final BuildContext context;

  const MovablePhoto({super.key, required this.image, required this.context});

  @override
  State<MovablePhoto> createState() => _MovablePhotoState();
}

class _MovablePhotoState extends State<MovablePhoto> {
  double x = 0;
  double y = 0;
  double scale = 1.0;
  double baseScale = 1.0;

  double rotation = 0.0;
  double baseRotation = 0.0;
  
  @override
  void initState() {
    super.initState();

    x = MediaQuery.of(widget.context).size.width / 2;
    y = MediaQuery.of(widget.context).size.height / 3;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,

      child: Transform.rotate(
        angle: rotation,
        child: Transform.scale(
          scale: scale,
          child: GestureDetector(
            onScaleStart: (details) {
              baseScale = scale;
              baseRotation = rotation;
            },
            onScaleUpdate: (details) {
              setState(() {
                scale = baseScale * details.scale;
                rotation = baseRotation + details.rotation;

                if (details.pointerCount > 1) return;

                final dx = details.focalPointDelta.dx;
                final dy = details.focalPointDelta.dy;

                final cos = math.cos(rotation);
                final sin = math.sin(rotation);

                x += (dx * cos - dy * sin) * scale;
                y += (dx * sin + dy * cos) * scale;
              });
            },
            child: Container(
              width: 170,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.9),
                    blurRadius: 5,
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 45),
                child: Image.file(widget.image, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
