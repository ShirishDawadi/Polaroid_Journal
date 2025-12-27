import 'package:flutter/material.dart';
import 'package:polaroid_journal/widgets/decorated_icon_button.dart';
import 'package:polaroid_journal/widgets/moveable_textfield.dart';

class JournalSubFAB extends StatefulWidget {
  final int selectedTool;
  final int selectedSubTool;
  final Function(int) onToolSelected;
  final GlobalKey<MovableTextFieldState>? selectedTextKey;

  const JournalSubFAB({
    super.key,
    required this.selectedTool,
    required this.selectedSubTool,
    required this.onToolSelected,
    this.selectedTextKey,
  });

  @override
  State<JournalSubFAB> createState() => _JournalSubFABState();
}

class _JournalSubFABState extends State<JournalSubFAB> {
  @override
  Widget build(BuildContext context) {
    if (widget.selectedTool == 2) {
      if (widget.selectedTextKey == null ||
          widget.selectedTextKey!.currentState == null) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Tap a text to edit',
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      final textState = widget.selectedTextKey!.currentState!;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedIconButton(
            icon: textState.isBold
                ? Icons.format_bold
                : Icons.format_bold_outlined,
            onPressed: textState.toggleBold,
          ),
          const SizedBox(width: 15),
      
          DecoratedIconButton(
            icon: textState.isItalic
                ? Icons.format_italic
                : Icons.format_italic_outlined,
            onPressed: textState.toggleItalic,
          ),
          const SizedBox(width: 15),
      
          DecoratedIconButton(
            icon: textState.isUnderline
                ? Icons.format_underlined
                : Icons.format_underlined_outlined,
            onPressed: textState.toggleUnderline,
          ),
          const SizedBox(width: 15),
      
          DecoratedIconButton(
            icon: Icons.font_download_rounded,
            onPressed: () => widget.onToolSelected(2),
          ),
          const SizedBox(width: 15),
      
          DecoratedIconButton(
            icon: textState.textAlign == TextAlign.left
                ? Icons.align_horizontal_left
                : textState.textAlign == TextAlign.right
                ? Icons.align_horizontal_right
                : Icons.align_horizontal_center,
            onPressed: () {
              setState(() {
                if (textState.textAlign == TextAlign.left) {
                  textState.setTextAlign(TextAlign.center);
                } else if (textState.textAlign == TextAlign.center) {
                  textState.setTextAlign(TextAlign.right);
                } else {
                  textState.setTextAlign(TextAlign.left);
                }
              });
            },
          ),
          const SizedBox(width: 15),
      
          DecoratedIconButton(
            icon: Icons.format_color_text,
            color: textState.textColor,
            onPressed: () => widget.onToolSelected(3),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 4; i++) ...[
          DecoratedIconButton(
            icon: widget.selectedSubTool == i
                ? Icons.circle
                : Icons.circle_outlined,
            onPressed: () => widget.onToolSelected(i),
          ),
          const SizedBox(width: 15),
        ],
      ],
    );
  }
}
