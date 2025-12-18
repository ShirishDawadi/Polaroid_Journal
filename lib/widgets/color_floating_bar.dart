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
    Colors.amber,
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
    bool isCustomColor = !colors.contains(selectedColor);

    return Padding(
      padding: EdgeInsets.fromLTRB(30,0,0,0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...colors.map(
                (c) => GestureDetector(
                  onTap: () => onSelect(c),
                  child: Container(
                    width: 30,
                    height: 30,
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
                ),
              ),
          
              Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedColor ,
                  border: Border.all(
                    color: isCustomColor ? Colors.black : Colors.black12,
                    width: isCustomColor ? 3 : 1,
                  ),
                ),
                child: GestureDetector(
                  onTap: onOpenColorPicker,
                  child: Center(
                    child: Icon(
                      Icons.colorize_sharp,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
