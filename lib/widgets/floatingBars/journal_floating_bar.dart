import 'package:flutter/material.dart';
import 'package:polaroid_journal/utils/tools_enum.dart';

class JournalFloatingBar extends StatelessWidget {
  final bool isOpen;
  final Tool? selectedTool;

  final Function(Tool) onToolSelected;
  final Function() onToggle;

  const JournalFloatingBar({
    super.key,
    required this.isOpen,
    required this.selectedTool,
    required this.onToolSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: isOpen
                  ? [
                      IconButton(
                        icon: Icon(
                          selectedTool == Tool.image
                              ? Icons.photo_library
                              : Icons.photo_library_outlined,
                        ),
                        onPressed: () => onToolSelected(Tool.image),
                      ),
                      IconButton(
                        icon: Icon(
                          selectedTool == Tool.draw
                              ? Icons.brush
                              : Icons.brush_outlined,
                        ),
                        onPressed: () => onToolSelected(Tool.draw),
                      ),
                      IconButton(
                        icon: Icon(
                          selectedTool == Tool.text
                              ? Icons.text_fields
                              : Icons.text_fields_outlined,
                        ),
                        onPressed: () => onToolSelected(Tool.text),
                      ),
                      IconButton(
                        icon: Icon(
                          selectedTool == Tool.background
                              ? Icons.format_paint
                              : Icons.format_paint_outlined,
                        ),
                        onPressed: () => onToolSelected(Tool.background),
                      ),
                    ]
                  : [],
            ),
          ),
          AnimatedRotation(
            duration: const Duration(milliseconds: 300),
            turns: isOpen ? 0.25 : 0.75,
            child: IconButton(
              iconSize: 10,
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              onPressed: onToggle,
            ),
          ),
        ],
      ),
    );
  }
}
