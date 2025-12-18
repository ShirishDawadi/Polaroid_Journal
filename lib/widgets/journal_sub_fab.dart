import 'package:flutter/material.dart';
import 'package:polaroid_journal/widgets/decorated_icon_button.dart';

class JournalSubFAB extends StatelessWidget {
  final int selectedTool;
  final int selectedSubTool;
  final Function(int) onToolSelected;

  const JournalSubFAB({
    super.key,
    required this.selectedTool,
    required this.selectedSubTool,
    required this.onToolSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedIconButton(
          icon: selectedSubTool == 0
              ? Icons.photo_library
              : Icons.photo_library_outlined,

          onPressed: () => onToolSelected(0),
        ),

        const SizedBox(width: 15),

        DecoratedIconButton(
          icon: selectedSubTool == 1 
          ? Icons.brush 
          : Icons.brush_outlined,

          onPressed: () => onToolSelected(1),
        ),

        const SizedBox(width: 15),

        DecoratedIconButton(
          icon: selectedSubTool == 2
              ? Icons.text_fields
              : Icons.text_fields_outlined,

          onPressed: () => onToolSelected(2),
        ),

        const SizedBox(width: 15),

        DecoratedIconButton(
          icon: selectedSubTool == 3
              ? Icons.format_paint
              : Icons.format_paint_outlined,

          onPressed: () => onToolSelected(3),
        ),
      ],
    );
  }
}
