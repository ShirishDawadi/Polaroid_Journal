import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polaroid_journal/data/models/layer_model.dart';
import 'package:polaroid_journal/presentation/viewmodels/journal_viewmodel.dart';
import 'package:polaroid_journal/presentation/widgets/layer/moveable_layer.dart';

class MovablePhoto extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return MovableLayer(
      layer: layer,
      isFocused: isFocused,
      onFocus: onFocus,
      onTransformEnd: (position, scale, rotation) {
        ref.read(journalProvider.notifier).updateLayer(
              layer.copyWith(
                position: position,
                scale: scale,
                rotation: rotation,
              ),
            );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isFocused ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Image(image: layer.image!, fit: BoxFit.contain),
        ),
      ),
    );
  }
}