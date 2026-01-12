import 'package:flutter/material.dart';
import 'package:polaroid_journal/utils/tools_enum.dart';

class ColorFloatingBar extends StatelessWidget {
  final Function(Color?) onSelect;
  final Tool? tool;
  final VoidCallback onOpenColorPicker;
  final Color? selectedColor;

  ColorFloatingBar({
    super.key,
    required this.selectedColor,
    required this.tool,
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
    if(tool == Tool.background) colors.add(Colors.transparent);

    return Padding(
      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
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
                        color: Colors.black,
                        width: c == selectedColor ? 3 : 1,
                      ),
                    ),
                  ),
                ),
              ),

              if (tool == Tool.background)
                GestureDetector(
                  onTap: () => onSelect(null),
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: selectedColor == null ? 3 : 1,
                      ),
                    ),
                    child: Center(child: Icon(Icons.close, size: 18)),
                  ),
                ),

              if (selectedColor != null)
                GestureDetector(
                  onTap: onOpenColorPicker,
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selectedColor,
                      border: Border.all(
                        color: isCustomColor ? Colors.black : Colors.black12,
                        width: isCustomColor ? 3 : 1,
                      ),
                    ),
                    child: Center(child: Icon(Icons.colorize_sharp, size: 18)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
