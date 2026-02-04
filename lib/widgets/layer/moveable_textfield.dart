import 'package:flutter/material.dart';
import 'package:polaroid_journal/models/layer_model.dart';
import 'package:polaroid_journal/widgets/layer/moveable_layer.dart';

class MovableTextField extends StatefulWidget {
  final LayerModel layer;
  final bool isFocused;
  final VoidCallback onFocus;
  final VoidCallback? onRemove;

  const MovableTextField({
    super.key,
    required this.layer,
    required this.isFocused,
    required this.onFocus,
    required this.onRemove,
  });

  @override
  State<MovableTextField> createState() => _MovableTextFieldState();
}

class _MovableTextFieldState extends State<MovableTextField> {
  final controller = TextEditingController();
  final focus = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.text = widget.layer.text!;
    if (widget.isFocused) focus.requestFocus();
  }

  @override
  void didUpdateWidget(covariant MovableTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFocused && !oldWidget.isFocused) {
      focus.requestFocus();
    } else if (!widget.isFocused && oldWidget.isFocused) {
      focus.unfocus();
      if (widget.layer.text?.trim().isEmpty ?? true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onRemove?.call();
        });
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    focus.dispose();
    super.dispose();
  }

  TextStyle get textStyle => TextStyle(
    color: widget.layer.textColor,
    fontFamily: widget.layer.fontFamily,
    fontSize: 20,
    fontWeight: widget.layer.isBold ? FontWeight.bold : FontWeight.normal,
    fontStyle: widget.layer.isItalic ? FontStyle.italic : FontStyle.normal,
    decoration: widget.layer.isUnderline
        ? TextDecoration.underline
        : TextDecoration.none,
  );

  @override
  Widget build(BuildContext context) {
    return MovableLayer(
      layer: widget.layer,
      isFocused: widget.isFocused,
      onFocus: widget.onFocus,
      resetTransformWhenFocused: true,
      child: IntrinsicWidth(
        child: Container(
          color: Colors.amber,
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
                onTap: widget.onFocus,
                controller: controller,
                focusNode: focus,
                onChanged: (value) => widget.layer.text = value,
                textAlign: widget.layer.textAlign,
                style: textStyle,
                cursorColor: widget.layer.textColor,
                decoration: const InputDecoration(border: InputBorder.none),
                maxLines: null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
