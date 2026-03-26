import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polaroid_journal/data/models/layer_model.dart';
import 'package:polaroid_journal/presentation/viewmodels/journal_viewmodel.dart';
import 'package:polaroid_journal/presentation/widgets/layer/moveable_layer.dart';

class MovableTextField extends ConsumerStatefulWidget {
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
  ConsumerState<MovableTextField> createState() => _MovableTextFieldState();
}

class _MovableTextFieldState extends ConsumerState<MovableTextField> {
  final controller = TextEditingController();
  final focus = FocusNode();
  late String _currentText;

  @override
  void initState() {
    super.initState();
    _currentText = widget.layer.text ?? '';
    controller.text = _currentText;
    if (widget.isFocused) focus.requestFocus();
  }

  @override
  void didUpdateWidget(covariant MovableTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!focus.hasFocus && widget.isFocused == oldWidget.isFocused) {
      final modelText = widget.layer.text ?? '';
      if (controller.text != modelText) {
        controller.text = modelText;
        _currentText = modelText;
      }
    }

    if (widget.isFocused && !oldWidget.isFocused) {
      focus.requestFocus();
    } else if (!widget.isFocused && oldWidget.isFocused) {
      focus.unfocus();
      Future.microtask(_commitText);
      if (_currentText.trim().isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onRemove?.call();
        });
      }
    }
  }

  void _commitText() {
    final latestLayer = ref
        .read(journalProvider)
        .layers
        .firstWhere((l) => l.id == widget.layer.id, orElse: () => widget.layer);
    ref
        .read(journalProvider.notifier)
        .updateLayer(latestLayer.copyWith(text: _currentText));
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
      onTransformEnd: (position, scale, rotation) {
        ref
            .read(journalProvider.notifier)
            .updateLayer(
              widget.layer.copyWith(
                position: position,
                scale: scale,
                rotation: rotation,
              ),
            );
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
              autofocus: false,
              onTap: widget.onFocus,
              controller: controller,
              focusNode: focus,
              onChanged: (value) => _currentText = value,
              textAlign: widget.layer.textAlign,
              style: textStyle,
              cursorColor: widget.layer.textColor,
              decoration: const InputDecoration(border: InputBorder.none),
              maxLines: null,
            ),
          ),
        ),
      ),
    );
  }
}
