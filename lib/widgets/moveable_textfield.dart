import 'dart:math' as math;
import 'package:flutter/material.dart';

class MovableTextField extends StatefulWidget {
  final Function(Key) onRemove;
  final BuildContext context;
  final Function(Key, bool)? onFocusChanged;

  const MovableTextField({
    super.key,
    required this.onRemove,
    required this.context,
    this.onFocusChanged,
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

  final controller = TextEditingController();
  final focus = FocusNode();

  bool isBold = false;
  bool isItalic = false;
  bool isUnderline = false;
  Color textColor = Colors.black;
  TextAlign textAlign = TextAlign.center;
  String fontFamily = 'Roboto';

  bool get isFocused => focus.hasFocus;

  @override
  void initState() {
    super.initState();

    x = 0;
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

    widget.onFocusChanged?.call(widget.key!, focus.hasFocus);

    if (focus.hasFocus) {
      origX = x;
      origY = y;
      origScale = scale;
      origRotation = rotation;

      final screen = MediaQuery.of(context).size;
      final kbHeight = MediaQuery.of(context).viewInsets.bottom;

      setState(() {
        x = -10;
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

  void toggleBold() {
    setState(() {
      isBold = !isBold;
    });
  }

  void toggleItalic() {
    setState(() {
      isItalic = !isItalic;
    });
  }

  void toggleUnderline() {
    setState(() {
      isUnderline = !isUnderline;
    });
  }

  void setTextColor(Color color) {
    setState(() {
      textColor = color;
    });
  }

  void setTextAlign(TextAlign align) {
    setState(() {
      textAlign = align;
    });
  }

  void setFontFamily(String font) {
    setState(() {
      fontFamily = font;
    });
  }

  TextStyle get textStyle {
    return TextStyle(
      color: textColor,
      fontFamily: fontFamily,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
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
                  scale = baseScale * details.scale;
                  rotation = baseRotation + details.rotation;

                  if (details.pointerCount > 1) return;

                  final dx = details.focalPointDelta.dx;
                  final dy = details.focalPointDelta.dy;

                  final cos = math.cos(rotation);
                  final sin = math.sin(rotation);

                  x += (dx * cos - dy * sin) * scale;
                  y += (dx * sin + dy * cos) * scale;

                  origX = x;
                  origY = y;
                  origScale = scale;
                  origRotation = rotation;
                });
              }
            },
            child: IntrinsicWidth(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 75,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: controller,
                    focusNode: focus,
                    textAlign: textAlign,
                    style: textStyle,
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
    );
  }
}