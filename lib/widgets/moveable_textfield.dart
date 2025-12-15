import 'dart:math' as math;

import 'package:flutter/material.dart';

class MovableTextField extends StatefulWidget {
  final Function(Key) onRemove;
  final BuildContext context;
  final Color textColor;

  const MovableTextField({
    super.key,
    required this.onRemove,
    required this.context,
    required this.textColor,
  });

  @override
  State<MovableTextField> createState() => MovableTextFieldState();
}

class MovableTextFieldState extends State<MovableTextField> {
  double x = 0, y = 0;
  double scale = 1.0, rotation = 0.0;

  double origX = 0, origY = 0;
  double origScale = 1.0, origRotation = 0.0;

  double baseScale = 1.0;
  double baseRotation = 0.0;

  Color? textColor;
  final controller = TextEditingController();
  final focus = FocusNode();

  bool get isFocused => focus.hasFocus;

  void updateTextColor(Color color) {
    setState(() => textColor = color);
  }

  @override
  void initState() {
    super.initState();

    textColor = widget.textColor;

    x = MediaQuery.of(widget.context).size.width / 2.5;
    y = MediaQuery.of(widget.context).size.height / 3;

    origX = x;
    origY = y;
    origScale = scale;
    origRotation = rotation;

    focus.requestFocus();

    focus.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!mounted) return;

    if (focus.hasFocus) {
      origX = x;
      origY = y;
      origScale = scale;
      origRotation = rotation;

      final screen = MediaQuery.of(context).size;
      final kbHeight = MediaQuery.of(context).viewInsets.bottom;

      setState(() {
        x = 0;
        y = (screen.height - kbHeight) * 0.30;
        scale = 1.0;
        rotation = 0.0;
      });
    } else {
      setState(() {
        x = origX;
        y = origY;
        scale = origScale;
        rotation = origRotation;
      });

      if (controller.text.trim().isEmpty) {
        widget.onRemove(widget.key!);
      }
    }
  }

  @override
  void dispose() {
    focus.removeListener(_handleFocusChange);
    controller.dispose();
    focus.dispose();
    super.dispose();
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
              if (!focus.hasFocus) {
                setState(() {
                  final dx = details.focalPointDelta.dx;
                  final dy = details.focalPointDelta.dy;
          
                  final cos = math.cos(-rotation);
                  final sin = math.sin(-rotation);
          
                  x += dx * cos - dy * sin;
                  y += dx * sin + dy * cos;
                  
                  origX = x;
                  origY = y;
          
                  if (details.pointerCount >= 2) {
                    scale = baseScale * details.scale;
                    rotation = baseRotation + details.rotation;
          
                    origScale = scale;
                    origRotation = rotation;
                  }
                });
              }
            },
            child: IntrinsicWidth(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: SizedBox(
                  width: focus.hasFocus
                      ? MediaQuery.of(context).size.width
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: controller,
                      focusNode: focus,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textColor),
                      cursorColor: textColor,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
