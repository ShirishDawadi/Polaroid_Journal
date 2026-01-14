import 'package:flutter/material.dart';
import 'package:polaroid_journal/utils/app_assets.dart';
import 'package:polaroid_journal/utils/tools_enum.dart';
import 'package:polaroid_journal/widgets/decorated_icon_button.dart';
import 'package:polaroid_journal/widgets/moveable_textfield.dart';
import 'package:polaroid_journal/widgets/svg_widget.dart';
import 'package:whiteboard/whiteboard.dart';

class JournalSubFAB extends StatefulWidget {
  final Tool? selectedTool;
  final SubTool? selectedSubTool;
  final Function(SubTool) onToolSelected;

  final GlobalKey<MovableTextFieldState>? selectedTextKey;

  final WhiteBoardController? whiteBoardController;
  final Color? currentBrushColor;

  final Color? primaryBackgroundColor;
  final Color? secondaryBackgroundColor;
  final bool? isImageBackground;

  const JournalSubFAB({
    super.key,
    required this.selectedTool,
    required this.selectedSubTool,
    required this.onToolSelected,
    this.selectedTextKey,
    this.whiteBoardController,
    this.currentBrushColor,
    this.primaryBackgroundColor,
    this.secondaryBackgroundColor,
    this.isImageBackground,
  });

  @override
  State<JournalSubFAB> createState() => _JournalSubFABState();
}

class _JournalSubFABState extends State<JournalSubFAB> {
  bool isErasing = false;

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
            icon: AppSvg.icon(
              context: context,
              path: (textState.isBold) ? AppAssets.boldFilled : AppAssets.bold,
            ),
            onPressed: () {
              widget.onToolSelected(SubTool.bold);
              setState(() => textState.toggleBold());
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: AppSvg.icon(
              context: context,
              path: (textState.isItalic)
                  ? AppAssets.italicFilled
                  : AppAssets.italic,
            ),
            onPressed: () {
              widget.onToolSelected(SubTool.italic);
              setState(() => textState.toggleItalic());
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: AppSvg.icon(
              context: context,
              path: (textState.isUnderline)
                  ? AppAssets.underlineFilled
                  : AppAssets.underline,
            ),
            onPressed: () {
              widget.onToolSelected(SubTool.underline);
              setState(() => textState.toggleUnderline());
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: AppSvg.icon(context: context, path: AppAssets.font),
            onPressed: () => widget.onToolSelected(SubTool.font),
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: AppSvg.icon(
              context: context,
              path: (textState.textAlign == TextAlign.left)
                  ? AppAssets.leftAlign
                  : (textState.textAlign == TextAlign.right)
                  ? AppAssets.rightAlign
                  : AppAssets.centerAlign,
            ),
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
            icon: Icon(Icons.format_color_text, color: textState.textColor),
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
            icon: AppSvg.icon(context: context, path: AppAssets.delete),
            onPressed: () {
              widget.onToolSelected(SubTool.delete);
              widget.whiteBoardController?.clear();
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: AppSvg.icon(context: context, path: AppAssets.undo),
            onPressed: () {
              widget.onToolSelected(SubTool.undo);
              widget.whiteBoardController?.undo();
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: AppSvg.icon(context: context, path: AppAssets.redo),
            onPressed: () {
              widget.onToolSelected(SubTool.redo);
              widget.whiteBoardController?.redo();
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: AppSvg.icon(
              context: context,
              path: isErasing ? AppAssets.eraserFilled : AppAssets.eraser,
            ),
            onPressed: () {
              widget.onToolSelected(SubTool.erase);
              setState(() => isErasing = !isErasing);
            },
          ),
          const SizedBox(width: 15),

           DecoratedIconButton(
            icon: AppSvg.icon(
              context: context,
              path:AppAssets.thickness,
            ),
            onPressed: () {
              widget.onToolSelected(SubTool.thickness);
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: Icon(Icons.circle_rounded),
            color: widget.currentBrushColor,
            onPressed: () => widget.onToolSelected(SubTool.color),
          ),
        ],
      );
    }

    if (widget.selectedTool == Tool.background) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedIconButton(
            icon: AppSvg.icon(context: context, path: AppAssets.paper),
            onPressed: () {
              widget.onToolSelected(SubTool.paper);
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: (widget.isImageBackground!)?
            AppSvg.icon(context: context, path: AppAssets.wallpaperFilled):
            AppSvg.icon(context: context, path: AppAssets.wallpaper),
            onPressed: () {
              widget.onToolSelected(SubTool.wallpaper);
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: (widget.primaryBackgroundColor != null)
                ? Icon(Icons.circle_rounded)
                : Icon(Icons.close),
            color: widget.primaryBackgroundColor,
            onPressed: () =>
                widget.onToolSelected(SubTool.primaryBackgroundColor),
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: (widget.secondaryBackgroundColor != null)
                ? Icon(Icons.circle_rounded)
                : Icon(Icons.close),
            color: widget.secondaryBackgroundColor,
            onPressed: () =>
                widget.onToolSelected(SubTool.secondaryBackgroundColor),
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
                ? Icon(Icons.circle)
                : Icon(Icons.circle_outlined),
            onPressed: () => widget.onToolSelected(SubTool.color),
          ),
          const SizedBox(width: 15),
        ],
      ],
    );
  }
}
