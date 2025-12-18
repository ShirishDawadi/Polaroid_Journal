import 'package:flutter/material.dart';

class JournalFloatingBar extends StatelessWidget {
  final bool isOpen;
  final int selectedTool;

  final Function(int) onToolSelected;
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
                          selectedTool == 0
                              ? Icons.photo_library
                              : Icons.photo_library_outlined,
                        ),
                        onPressed: () => onToolSelected(0),
                      ),
                      IconButton(
                        icon: Icon(
                          selectedTool == 1
                              ? Icons.brush
                              : Icons.brush_outlined,
                        ),
                        onPressed: () => onToolSelected(1),
                      ),
                      IconButton(
                        icon: Icon(
                          selectedTool == 2
                              ? Icons.text_fields
                              : Icons.text_fields_outlined,
                        ),
                        onPressed: () => onToolSelected(2),
                      ),
                      IconButton(
                        icon: Icon(
                          selectedTool == 3
                              ? Icons.format_paint
                              : Icons.format_paint_outlined,
                        ),
                        onPressed: () => onToolSelected(3),
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
