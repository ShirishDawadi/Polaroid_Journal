import 'package:flutter/material.dart';

class SliderFab extends StatefulWidget {
  final bool isCustom;
  final double strokeWidth;
  final double minValue;
  final double maxValue;
  final Function(double) onChanged;

  SliderFab({
    super.key,
    this.isCustom = false,
    required this.strokeWidth,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
  });

  @override
  State<SliderFab> createState() => _SliderFabState();
}

class _SliderFabState extends State<SliderFab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(40),
        ),
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: widget.isCustom ? widget.strokeWidth : 1,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: widget.isCustom? 15:10),
            overlayShape: RoundSliderOverlayShape(overlayRadius: widget.isCustom? 24:15),
          ),
          child: Slider(
            thumbColor: Theme.of(context).primaryColor,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Theme.of(context).primaryColor,

            value: widget.strokeWidth,
            min: widget.minValue,
            max: widget.maxValue,
            onChanged: (value) => widget.onChanged(value),
          ),
        ),
      ),
    );
  }
}
