import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polaroid_journal/data/models/journal_state.dart';
import 'package:polaroid_journal/data/models/layer_model.dart';
import 'package:polaroid_journal/core/constants/app_assets.dart';
import 'package:polaroid_journal/core/utils/tools_enum.dart';
import 'package:polaroid_journal/presentation/viewmodels/journal_viewmodel.dart';
import 'package:polaroid_journal/presentation/widgets/decorated_icon_button.dart';
import 'package:polaroid_journal/presentation/widgets/svg_widget.dart';
import 'package:whiteboard/whiteboard.dart';

class JournalSubFAB extends ConsumerStatefulWidget {
  final Tool? selectedTool;
  final SubTool? selectedSubTool;
  final Function(SubTool) onToolSelected;
  final Function(LayerModel)? onUpdateLayer;
  final LayerModel? layer;
  final WhiteBoardController? whiteBoardController;
  final Color? currentBrushColor;

  const JournalSubFAB({
    super.key,
    required this.selectedTool,
    required this.selectedSubTool,
    required this.onToolSelected,
    this.onUpdateLayer,
    this.layer,
    this.whiteBoardController,
    this.currentBrushColor,
  });

  @override
  ConsumerState<JournalSubFAB> createState() => _JournalSubFABState();
}

class _JournalSubFABState extends ConsumerState<JournalSubFAB> {
  bool isErasing = false;

  Widget _buildTextTools(LayerModel layer) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedIconButton(
          icon: AppSvg.icon(
            context: context,
            path: layer.isBold ? AppAssets.boldFilled : AppAssets.bold,
          ),
          onPressed: () {
            widget.onToolSelected(SubTool.bold);
            widget.onUpdateLayer?.call(layer.copyWith(isBold: !layer.isBold));
          },
        ),
        const SizedBox(width: 15),

        DecoratedIconButton(
          icon: AppSvg.icon(
            context: context,
            path: layer.isItalic ? AppAssets.italicFilled : AppAssets.italic,
          ),
          onPressed: () {
            widget.onToolSelected(SubTool.italic);
            widget.onUpdateLayer?.call(layer.copyWith(isItalic: !layer.isItalic));
          },
        ),
        const SizedBox(width: 15),

        DecoratedIconButton(
          icon: AppSvg.icon(
            context: context,
            path: layer.isUnderline
                ? AppAssets.underlineFilled
                : AppAssets.underline,
          ),
          onPressed: () {
            widget.onToolSelected(SubTool.underline);
            widget.onUpdateLayer
                ?.call(layer.copyWith(isUnderline: !layer.isUnderline));
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
            path: layer.textAlign == TextAlign.left
                ? AppAssets.leftAlign
                : layer.textAlign == TextAlign.right
                    ? AppAssets.rightAlign
                    : AppAssets.centerAlign,
          ),
          onPressed: () {
            widget.onToolSelected(SubTool.align);
            final nextAlign = layer.textAlign == TextAlign.left
                ? TextAlign.center
                : layer.textAlign == TextAlign.center
                    ? TextAlign.right
                    : TextAlign.left;
            widget.onUpdateLayer?.call(layer.copyWith(textAlign: nextAlign));
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

  Widget _buildDrawTools() {
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
          icon: AppSvg.icon(context: context, path: AppAssets.thickness),
          onPressed: () => widget.onToolSelected(SubTool.thickness),
        ),
        const SizedBox(width: 15),

        DecoratedIconButton(
          icon: const Icon(Icons.circle_rounded),
          color: widget.currentBrushColor,
          onPressed: () => widget.onToolSelected(SubTool.color),
        ),
        const SizedBox(width: 15),

        DecoratedIconButton(
          icon: const Icon(Icons.add),
          onPressed: () => widget.onToolSelected(SubTool.add),
        ),
      ],
    );
  }

  Widget _buildBackgroundTools(BackgroundConfig background) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedIconButton(
          icon: AppSvg.icon(context: context, path: AppAssets.paper),
          onPressed: () => widget.onToolSelected(SubTool.paper),
        ),
        const SizedBox(width: 15),

        DecoratedIconButton(
          icon: AppSvg.icon(context: context, path: AppAssets.slider),
          onPressed: () => widget.onToolSelected(SubTool.slider),
        ),
        const SizedBox(width: 15),

        DecoratedIconButton(
          icon: background.image != null
              ? AppSvg.icon(context: context, path: AppAssets.wallpaperFilled)
              : AppSvg.icon(context: context, path: AppAssets.wallpaper),
          onPressed: () => widget.onToolSelected(SubTool.wallpaper),
        ),
        const SizedBox(width: 15),

        DecoratedIconButton(
          icon: background.primaryColor != null
              ? const Icon(Icons.circle_rounded)
              : const Icon(Icons.add),
          color: background.primaryColor,
          onPressed: () =>
              widget.onToolSelected(SubTool.primaryBackgroundColor),
        ),
        const SizedBox(width: 15),

        DecoratedIconButton(
          icon: background.secondaryColor != null
              ? const Icon(Icons.circle_rounded)
              : const Icon(Icons.add),
          color: background.secondaryColor,
          onPressed: () =>
              widget.onToolSelected(SubTool.secondaryBackgroundColor),
        ),
      ],
    );
  }

  Widget _buildImageTools() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedIconButton(
          icon: AppSvg.icon(context: context, path: AppAssets.sticker),
          onPressed: () => widget.onToolSelected(SubTool.sticker),
        ),
        const SizedBox(width: 15),

        DecoratedIconButton(
          icon: AppSvg.icon(context: context, path: AppAssets.photo),
          onPressed: () => widget.onToolSelected(SubTool.photo),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final background = ref.watch(journalProvider).background;

    if (widget.selectedTool == Tool.text && widget.layer != null) {
      return _buildTextTools(widget.layer!);
    }
    if (widget.selectedTool == Tool.draw) {
      return _buildDrawTools();
    }
    if (widget.selectedTool == Tool.background) {
      return _buildBackgroundTools(background);
    }
    if (widget.selectedTool == Tool.image) {
      return _buildImageTools();
    }
    return const SizedBox();
  }
}