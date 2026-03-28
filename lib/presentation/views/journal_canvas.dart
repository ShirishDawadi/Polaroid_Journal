import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polaroid_journal/core/utils/tools_enum.dart';
import 'package:polaroid_journal/data/models/layer_model.dart';
import 'package:polaroid_journal/presentation/viewmodels/journal_viewmodel.dart';
import 'package:polaroid_journal/presentation/widgets/journal_background.dart';
import 'package:polaroid_journal/presentation/widgets/layer/drawing_layer.dart';
import 'package:polaroid_journal/presentation/widgets/layer/moveable_photo.dart';
import 'package:polaroid_journal/presentation/widgets/layer/moveable_textfield.dart';

class JournalCanvas extends ConsumerWidget {
  final LayerModel? focusedLayer;
  final Tool? selectedTool;
  final bool isOpen;
  final bool isIgnoring;
  final Color currentBrushColor;
  final double strokeWidth;
  final bool isErasing;
  final VoidCallback onCanvasTapped;
  final void Function(LayerModel) onPhotoFocused;
  final void Function(LayerModel) onTextFocused;
  final void Function(LayerModel) onLayerRemoved;
  final VoidCallback onDismissOverlay;

  const JournalCanvas({
    super.key,
    required this.focusedLayer,
    required this.selectedTool,
    required this.isOpen,
    required this.isIgnoring,
    required this.currentBrushColor,
    required this.strokeWidth,
    required this.isErasing,
    required this.onCanvasTapped,
    required this.onPhotoFocused,
    required this.onTextFocused,
    required this.onLayerRemoved,
    required this.onDismissOverlay,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(journalProvider);
    final layers = state.layers;
    final background = state.background;

    return Stack(
      children: [
        GestureDetector(
          onTap: onCanvasTapped,
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 2),
            ),
            child: Stack(
              children: [
                JournalBackground(config: background),
                for (final layer in layers)
                  if (layer.type == LayerType.photo)
                    MovablePhoto(
                      key: ValueKey(layer.id),
                      layer: layer,
                      isFocused:
                          layer == focusedLayer && selectedTool != Tool.draw,
                      onFocus: () => onPhotoFocused(layer),
                    )
                  else if (layer.type == LayerType.drawing)
                    DrawingLayer(
                      key: ValueKey(layer.id),
                      layer: layer,
                      isActive: !isIgnoring,
                      currentBrushColor: currentBrushColor,
                      strokeWidth: strokeWidth,
                      isErasing: isErasing,
                    )
                  else if (layer.type == LayerType.text)
                    MovableTextField(
                      key: ValueKey(layer.id),
                      layer: layer,
                      isFocused:
                          layer == focusedLayer && selectedTool != Tool.draw,
                      onFocus: () => onTextFocused(layer),
                      onRemove: () => onLayerRemoved(layer),
                    ),
              ],
            ),
          ),
        ),
        if (isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: onDismissOverlay,
              child: Container(color: Colors.black.withValues(alpha: 0.6)),
            ),
          ),
      ],
    );
  }
}