import 'package:flutter/material.dart';
import 'package:polaroid_journal/models/layer_model.dart';
import 'package:polaroid_journal/widgets/layer/moveable_layer.dart';

class MovablePhoto extends StatefulWidget {
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
  State<MovablePhoto> createState() => _MovablePhotoState();
}

class _MovablePhotoState extends State<MovablePhoto> {
  @override
  Widget build(BuildContext context) {
    return MovableLayer(
      layer: widget.layer,
      isFocused: widget.isFocused,
      onFocus: widget.onFocus,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.isFocused ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: Image(image: widget.layer.image!, fit: BoxFit.contain),
        ),
      ),
    );
  }
}