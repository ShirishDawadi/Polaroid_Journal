import 'package:flutter/material.dart';
import 'color_picker_widget.dart';

class ColorPickerOverlay {
  final BuildContext context;
  final Color initialColor;
  final void Function(Color) onSelect;

  OverlayEntry? _overlay;

  ColorPickerOverlay({
    required this.context,
    required this.initialColor,
    required this.onSelect,
  });

  void show() {
    if (_overlay != null) return;
    _overlay = OverlayEntry(
      builder: (_) => ColorPickerWidget(
        initialColor: initialColor,
        onSelect: onSelect,
        onClose: hide,
      ),
    );

    Overlay.of(context).insert(_overlay!);
  }

  void hide() {
    _overlay?.remove();
    _overlay = null;
  }
}
