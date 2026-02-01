import 'package:flutter/material.dart';
import 'package:polaroid_journal/models/layer_model.dart';
import 'package:polaroid_journal/utils/app_assets.dart';
import 'package:polaroid_journal/utils/tools_enum.dart';
import 'package:polaroid_journal/widgets/decorated_icon_button.dart';
// import 'package:polaroid_journal/widgets/layer/moveable_textfield.dart';
import 'package:polaroid_journal/widgets/svg_widget.dart';
import 'package:whiteboard/whiteboard.dart';

class JournalSubFAB extends StatefulWidget {
  final Tool? selectedTool;
  final SubTool? selectedSubTool;
  final Function(SubTool) onToolSelected;

  // final GlobalKey<MovableTextFieldState>? selectedTextKey;
  final LayerModel? layer;

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
    // this.selectedTextKey,
    this.layer,
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
  Widget subFab = SizedBox();

  @override
  Widget build(BuildContext context) {
    if (widget.selectedTool == Tool.text) {
      final layer = widget.layer!;

      subFab = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedIconButton(
            icon: AppSvg.icon(
              context: context,
              path: (layer.isBold) ? AppAssets.boldFilled : AppAssets.bold,
            ),
            onPressed: () {
              widget.onToolSelected(SubTool.bold);
              setState(() => layer.isBold = !layer.isBold);
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: AppSvg.icon(
              context: context,
              path: (layer.isItalic)
                  ? AppAssets.italicFilled
                  : AppAssets.italic,
            ),
            onPressed: () {
              widget.onToolSelected(SubTool.italic);
              setState(() => layer.isItalic = !layer.isItalic);
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: AppSvg.icon(
              context: context,
              path: (layer.isUnderline)
                  ? AppAssets.underlineFilled
                  : AppAssets.underline,
            ),
            onPressed: () {
              widget.onToolSelected(SubTool.underline);
              setState(() => layer.isUnderline = !layer.isUnderline);
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
              path: (layer.textAlign == TextAlign.left)
                  ? AppAssets.leftAlign
                  : (layer.textAlign == TextAlign.right)
                  ? AppAssets.rightAlign
                  : AppAssets.centerAlign,
            ),
            onPressed: () {
              setState(() {
                widget.onToolSelected(SubTool.align);
                if (layer.textAlign == TextAlign.left) {
                  layer.textAlign = TextAlign.center;
                } else if (layer.textAlign == TextAlign.center) {
                  layer.textAlign = TextAlign.right;
                } else {
                  layer.textAlign = TextAlign.left;
                }
              });
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: Icon(Icons.format_color_text, color: layer.textColor),
            onPressed: () => widget.onToolSelected(SubTool.color),
          ),
        ],
      );
    }

    if (widget.selectedTool == Tool.draw) {
      subFab = Row(
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
            icon: AppSvg.icon(context: context, path: AppAssets.thickness),
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
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: Icon(Icons.add),
            onPressed: () => widget.onToolSelected(SubTool.add),
          ),
        ],
      );
    }

    if (widget.selectedTool == Tool.background) {
      subFab = Row(
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
            icon: AppSvg.icon(context: context, path: AppAssets.slider),
            onPressed: () {
              widget.onToolSelected(SubTool.slider);
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: (widget.isImageBackground!)
                ? AppSvg.icon(context: context, path: AppAssets.wallpaperFilled)
                : AppSvg.icon(context: context, path: AppAssets.wallpaper),
            onPressed: () {
              widget.onToolSelected(SubTool.wallpaper);
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: (widget.primaryBackgroundColor != null)
                ? Icon(Icons.circle_rounded)
                : Icon(Icons.add),
            color: widget.primaryBackgroundColor,
            onPressed: () =>
                widget.onToolSelected(SubTool.primaryBackgroundColor),
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: (widget.secondaryBackgroundColor != null)
                ? Icon(Icons.circle_rounded)
                : Icon(Icons.add),
            color: widget.secondaryBackgroundColor,
            onPressed: () =>
                widget.onToolSelected(SubTool.secondaryBackgroundColor),
          ),
        ],
      );
    }

    if (widget.selectedTool == Tool.image) {
      subFab = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedIconButton(
            icon: AppSvg.icon(context: context, path: AppAssets.sticker),
            onPressed: () {
              widget.onToolSelected(SubTool.sticker);
            },
          ),
          const SizedBox(width: 15),

          DecoratedIconButton(
            icon: AppSvg.icon(context: context, path: AppAssets.photo),
            onPressed: () {
              widget.onToolSelected(SubTool.photo);
            },
          ),
        ],
      );
    }

    return subFab;
  }
}
