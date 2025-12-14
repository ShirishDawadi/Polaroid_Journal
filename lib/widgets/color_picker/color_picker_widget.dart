import 'package:flutter/material.dart';
import 'hue_ring.dart';
import 'gradient_square.dart';
import 'color_utils.dart';

class ColorPickerWidget extends StatefulWidget {
  final Color initialColor;
  final void Function(Color) onSelect;
  final VoidCallback onClose;

  const ColorPickerWidget({
    required this.initialColor,
    required this.onSelect,
    required this.onClose,
  });

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  late HSVColor currentColor;
  late TextEditingController hexController;
  Offset offset = Offset(50, 100);

  @override
  void initState() {
    super.initState();
    currentColor = HSVColor.fromColor(widget.initialColor);
    hexController = TextEditingController(
      text: colorToHex(currentColor.toColor()),
    );
  }

  @override
  void dispose() {
    hexController.dispose();
    super.dispose();
  }

  void _updateColor(HSVColor color) {
    setState(() {
      currentColor = color;
      final newHex = colorToHex(color.toColor());
      if (hexController.text != newHex) {
        hexController.text = newHex;
      }
    });
    widget.onSelect(color.toColor());
  }

  void _updateFromHex(String value) {
    final color = hsvFromHex(value);
    if (color != null) {
      setState(() {
        currentColor = color;
      });
      widget.onSelect(color.toColor());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: widget.onClose,
          ),
        ),
        Positioned(
          left: offset.dx,
          top: offset.dy,
          child: GestureDetector(
            onScaleUpdate: (details){
              setState(() {
                offset += details.focalPointDelta;
              });
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(150),
                  ),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HueRingWithHex(
                        hue: currentColor.hue,
                        hexController: hexController,
                        onHueChanged: (hue) {
                          _updateColor(currentColor.withHue(hue));
                        },
                        onHexChanged: _updateFromHex,
                      ),
                      SizedBox(width: 5),
                      GradientSquare(
                        hue: currentColor.hue,
                        saturation: currentColor.saturation,
                        value: currentColor.value,
                        onColorChanged: (s, v) {
                          _updateColor(currentColor.withSaturation(s).withValue(v));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
