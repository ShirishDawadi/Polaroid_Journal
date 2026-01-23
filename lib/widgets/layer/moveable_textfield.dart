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

  double baseScale = 1.0;
  double baseRotation = 0.0;

  double focusedX = 0, focusedY = 0;
  double focusedScale = 1.0, focusedRotation = 0.0;

  final controller = TextEditingController();
  final focus = FocusNode();
  bool isFocused = false;

  bool isBold = false;
  bool isItalic = false;
  bool isUnderline = false;
  Color textColor = Colors.black;
  TextAlign textAlign = TextAlign.center;
  String fontFamily = 'Roboto';
  double borderRadius = 0;
  Color backgroundColor = Colors.transparent;

  @override
  void initState() {
    super.initState();

    final screen = MediaQuery.of(widget.context).size;
    final kbHeight = MediaQuery.of(widget.context).viewInsets.bottom;

    y = (screen.height - kbHeight) * 0.30;
    focusedY = y;

    focus.requestFocus();
    focus.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!mounted) return;

    setState(() {
      isFocused = focus.hasFocus;
    });

    widget.onFocusChanged?.call(widget.key!, isFocused);

    if (!isFocused && controller.text.trim().isEmpty) {
      widget.onRemove(widget.key!);
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

//adding later if i wanna
  void setBorderRadius(double radius){
    setState(() {
      borderRadius = radius;
    });
  }

  void setBackgroundColor(Color color){
    setState(() {
      backgroundColor = color;
    });
  }

  TextStyle get textStyle {
    return TextStyle(
      color: textColor,
      fontFamily: fontFamily,
      fontSize: 20,
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
      left: (isFocused) ? focusedX : x,
      top: (isFocused) ? focusedY : y,
      child: Transform.rotate(
        angle: (isFocused) ? focusedRotation : rotation,
        child: Transform.scale(
          scale: (isFocused) ? focusedScale : scale,
          child: GestureDetector(
            onScaleStart: (details) {
              baseScale = scale;
              baseRotation = rotation;
            },
            onScaleUpdate: (details) {
              if (!isFocused) {
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
              }
            },
            child: IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: isFocused
                        ? MediaQuery.of(context).size.width - 20
                        : 75,
                    maxWidth: MediaQuery.of(context).size.width - 20,
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
      ),
    );
  }
}
