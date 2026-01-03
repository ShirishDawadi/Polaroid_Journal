import 'package:flutter/material.dart';
import 'package:polaroid_journal/utils/tools_enum.dart';
import 'package:polaroid_journal/widgets/decorated_icon_button.dart';
import 'package:polaroid_journal/widgets/moveable_textfield.dart';
import 'package:whiteboard/whiteboard.dart';

class JournalSubFAB extends StatefulWidget {
  final Tool? selectedTool;
  final SubTool? selectedSubTool;
  final Function(SubTool) onToolSelected;

  final GlobalKey<MovableTextFieldState>? selectedTextKey;
  
  final WhiteBoardController? whiteBoardController;
  final Color? currentBrushColor;

  const JournalSubFAB({
    super.key,
    required this.selectedTool,
    required this.selectedSubTool,
    required this.onToolSelected,
    this.selectedTextKey,
    this.whiteBoardController,
    this.currentBrushColor,
  });

  @override
  State<JournalSubFAB> createState() => _JournalSubFABState();
}

class _JournalSubFABState extends State<JournalSubFAB> {
  @override
  Widget build(BuildContext context) {
    if (widget.selectedTool == Tool.text) {
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
            icon: Icons.format_bold,
            onPressed:(){ 
              widget.onToolSelected(SubTool.bold);
              textState.toggleBold;
              }
          ),
          const SizedBox(width: 15),
      
          DecoratedIconButton(
            icon: Icons.format_italic,
            onPressed:(){ 
              widget.onToolSelected(SubTool.italic);
              textState.toggleItalic;}
          ),
          const SizedBox(width: 15),
      
          DecoratedIconButton(
            icon: Icons.format_underlined,
            onPressed:(){ 
              widget.onToolSelected(SubTool.underline);
              textState.toggleUnderline();
              }
          ),
          const SizedBox(width: 15),
      
          DecoratedIconButton(
            icon: Icons.font_download_rounded,
            onPressed: () => widget.onToolSelected(SubTool.font),
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
                widget.onToolSelected(SubTool.align);
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
            onPressed: () => widget.onToolSelected(SubTool.color),
          ),
        ],
      );
    }


    if (widget.selectedTool == Tool.draw) {

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedIconButton(
            icon: Icons.redo_rounded,
            onPressed:() { 
              widget.onToolSelected(SubTool.redo);
              widget.whiteBoardController?.redo();}
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: Icons.undo,
            onPressed:() {
              widget.onToolSelected(SubTool.undo);
              widget.whiteBoardController?.undo();
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: Icons.delete,
            onPressed:() {
              widget.onToolSelected(SubTool.delete);
              widget.whiteBoardController?.clear();
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: Icons.bubble_chart_outlined,
            onPressed:() => widget.onToolSelected(SubTool.erase),
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: Icons.circle_rounded,
            color: widget.currentBrushColor,
            onPressed: () => widget.onToolSelected(SubTool.color),
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
            onPressed: () => widget.onToolSelected(SubTool.color),
          ),
          const SizedBox(width: 15),
        ],
      ],
    );
  }
}
