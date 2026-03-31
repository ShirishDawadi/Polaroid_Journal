import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:polaroid_journal/data/models/layer_model.dart';

final isDraggingProvider = StateProvider<bool>((ref) => false);

class MovableLayer extends ConsumerStatefulWidget {
  final LayerModel layer;
  final bool isFocused;
  final VoidCallback onFocus;
  final Widget child;
  final bool resetTransformWhenFocused;
  final void Function(Offset position, double scale, double rotation)?
      onTransformEnd;

  const MovableLayer({
    super.key,
    required this.layer,
    required this.isFocused,
    required this.onFocus,
    required this.child,
    this.resetTransformWhenFocused = false,
    this.onTransformEnd,
  });

  @override
  ConsumerState<MovableLayer> createState() => _MovableLayerState();
}

class _MovableLayerState extends ConsumerState<MovableLayer> {
  late Offset _position;
  late double _scale;
  late double _rotation;

  double _baseScale = 1.0;
  double _baseRotation = 0.0;
  bool _isBeingManipulated = false;

  @override
  void initState() {
    super.initState();
    _position = widget.layer.position;
    _scale = widget.layer.scale;
    _rotation = widget.layer.rotation;
  }

  @override
  void didUpdateWidget(covariant MovableLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isBeingManipulated) {
      _position = widget.layer.position;
      _scale = widget.layer.scale;
      _rotation = widget.layer.rotation;
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldReset = widget.resetTransformWhenFocused &&
        widget.isFocused &&
        !_isBeingManipulated;

    return Positioned(
      left: shouldReset ? 0 : _position.dx,
      top: shouldReset ? 0 : _position.dy,
      child: Transform.rotate(
        angle: shouldReset ? 0 : _rotation,
        child: Transform.scale(
          scale: shouldReset ? 1 : _scale,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: widget.onFocus,
            onScaleStart: (details) {
              setState(() => _isBeingManipulated = true);
              ref.read(isDraggingProvider.notifier).state = true;
              _baseScale = _scale;
              _baseRotation = _rotation;
            },
            onScaleUpdate: (details) {
              setState(() {
                _scale = _baseScale * details.scale;
                _rotation = _baseRotation + details.rotation;

                if (details.pointerCount > 1) return;

                final dx = details.focalPointDelta.dx;
                final dy = details.focalPointDelta.dy;
                final cos = math.cos(_rotation);
                final sin = math.sin(_rotation);

                _position = Offset(
                  _position.dx + (dx * cos - dy * sin) * _scale,
                  _position.dy + (dx * sin + dy * cos) * _scale,
                );
              });
            },
            onScaleEnd: (_) {
              setState(() => _isBeingManipulated = false);
              ref.read(isDraggingProvider.notifier).state = false;
              widget.onTransformEnd?.call(_position, _scale, _rotation);
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}