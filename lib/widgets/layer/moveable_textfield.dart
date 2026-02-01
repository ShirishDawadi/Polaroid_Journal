import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:polaroid_journal/models/layer_model.dart';

class MovableTextField extends StatefulWidget {
  final LayerModel layer;
  final bool isFocused;
  final VoidCallback onFocus;

  const MovableTextField({
    super.key,
    required this.layer,
    required this.isFocused,
    required this.onFocus,
  });

  @override
  State<MovableTextField> createState() => _MovableTextFieldState();
}

class _MovableTextFieldState extends State<MovableTextField> {
  double baseScale = 1.0;
  double baseRotation = 0.0;
  bool isBeingManipulated = false;

  final controller = TextEditingController();
  final focus = FocusNode();

  TextStyle get textStyle {
    return TextStyle(
      color: widget.layer.textColor,
      fontFamily: widget.layer.fontFamily,
      fontSize: 20,
      fontWeight: widget.layer.isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: widget.layer.isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: widget.layer.isUnderline
          ? TextDecoration.underline
          : TextDecoration.none,
    );
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.layer.text!;
    if (widget.isFocused) {
      focus.requestFocus();
    }
  }

  @override
  void didUpdateWidget(covariant MovableTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFocused && !oldWidget.isFocused) {
      focus.requestFocus();
    } else if (!widget.isFocused && oldWidget.isFocused) {
      focus.unfocus();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final layer = widget.layer;

    return Positioned(
      left: (widget.isFocused && !isBeingManipulated) ? 0 : layer.position.dx,
      top: (widget.isFocused && !isBeingManipulated) ? 0 : layer.position.dy,
      child: Transform.rotate(
        angle: (widget.isFocused && !isBeingManipulated) ? 0 : layer.rotation,
        child: Transform.scale(
          scale: (widget.isFocused && !isBeingManipulated) ? 1 : layer.scale,
          child: GestureDetector(
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
            },
            child: IntrinsicWidth(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: widget.isFocused
                      ? MediaQuery.of(context).size.width - 20
                      : 75,
                  maxWidth: MediaQuery.of(context).size.width - 20,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    autofocus: true,
                    onTap: () {
                      widget.onFocus();
                    },
                    controller: controller,
                    focusNode: focus,
                    onChanged: (value) {
                      widget.layer.text = value;
                    },
                    textAlign: layer.textAlign,
                    style: textStyle,
                    cursorColor: layer.textColor,
                    decoration: const InputDecoration(border: InputBorder.none),
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
