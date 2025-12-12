import 'package:flutter/material.dart';

class ColorFloatingBar extends StatelessWidget {
  final Function(Color) onSelect;
  final VoidCallback onOpenColorPicker;
  final Color selectedColor;

  ColorFloatingBar({
    required this.selectedColor,
    required this.onSelect,
    required this.onOpenColorPicker,
  });

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.black,
    Colors.white,
    Colors.purple,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...colors.map((c) => GestureDetector(
                onTap: () => onSelect(c),
                child: Container(
                  width: 28,
                  height: 28,
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: c == selectedColor ? Colors.black : Colors.black12,
                      width: c == selectedColor ? 3 : 1,
                    ),
                  ),
                ),
              )),

          IconButton(
            icon: Icon(Icons.colorize_sharp),
            onPressed: onOpenColorPicker,
          ),
        ],
      ),
    );
  }
}
