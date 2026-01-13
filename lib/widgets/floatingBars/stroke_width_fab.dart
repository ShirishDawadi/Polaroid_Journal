import 'package:flutter/material.dart';

class StrokeWidthFab extends StatefulWidget {
  final double strokeWidth;
  final Function(double) onChanged;

  StrokeWidthFab({
    super.key,
    required this.strokeWidth,
    required this.onChanged,
  });

  @override
  State<StrokeWidthFab> createState() => _StrokeWidthFabState();
}

class _StrokeWidthFabState extends State<StrokeWidthFab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30,0,0,0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(40)
        ),
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: widget.strokeWidth,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
          ),
          child: Slider(
            thumbColor: Theme.of(context).primaryColor,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Theme.of(context).primaryColor,

            value: widget.strokeWidth,
            min: 1,
            max: 20,
            onChanged: (value) => widget.onChanged(value),
          ),
        ),
      ),
    );
  }
}
