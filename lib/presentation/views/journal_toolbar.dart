import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polaroid_journal/core/utils/tools_enum.dart';
import 'package:polaroid_journal/data/models/layer_model.dart';
import 'package:polaroid_journal/presentation/viewmodels/journal_viewmodel.dart';
import 'package:polaroid_journal/presentation/widgets/color_picker/color_picker_overlay.dart';
import 'package:polaroid_journal/presentation/widgets/floatingBars/color_floating_bar.dart';
import 'package:polaroid_journal/presentation/widgets/floatingBars/fonts_fab.dart';
import 'package:polaroid_journal/presentation/widgets/floatingBars/journal_floating_bar.dart';
import 'package:polaroid_journal/presentation/widgets/floatingBars/journal_sub_fab.dart';
import 'package:polaroid_journal/presentation/widgets/floatingBars/paper_bg_fab.dart';
import 'package:polaroid_journal/presentation/widgets/floatingBars/slider_fab.dart';

class JournalToolbar extends ConsumerStatefulWidget {
  final LayerModel? focusedLayer;
  final Tool? selectedTool;
  final SubTool? selectedSubTool;
  final bool isOpen;
  final double strokeWidth;
  final Color? currentColor;
  final Color currentBrushColor;
  final void Function(Tool) onToolSelected;
  final void Function(SubTool) onSubToolSelected;
  final void Function(LayerModel) onLayerUpdated;
  final void Function(Color?) onColorChanged;
  final void Function(String) onFontChanged;
  final void Function(double) onStrokeWidthChanged;
  final VoidCallback onToggle;
  final Future<void> Function() pickImage;

  const JournalToolbar({
    super.key,
    required this.focusedLayer,
    required this.selectedTool,
    required this.selectedSubTool,
    required this.isOpen,
    required this.strokeWidth,
    required this.currentColor,
    required this.currentBrushColor,
    required this.onToolSelected,
    required this.onSubToolSelected,
    required this.onLayerUpdated,
    required this.onColorChanged,
    required this.onFontChanged,
    required this.onStrokeWidthChanged,
    required this.onToggle,
    required this.pickImage,
  });

  @override
  ConsumerState<JournalToolbar> createState() => _JournalToolbarState();
}

class _JournalToolbarState extends ConsumerState<JournalToolbar> {
  late double localStrokeWidth;

  @override
  void initState() {
    super.initState();
    localStrokeWidth = widget.strokeWidth;
  }

  @override
  Widget build(BuildContext context) {
    final background = ref.watch(journalProvider).background;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.selectedSubTool == SubTool.color ||
            widget.selectedSubTool == SubTool.secondaryBackgroundColor ||
            widget.selectedSubTool == SubTool.primaryBackgroundColor)
          IgnorePointer(
            ignoring: widget.isOpen,
            child: ColorFloatingBar(
              selectedColor: widget.currentColor,
              tool: widget.selectedTool,
              onSelect: widget.onColorChanged,
              onOpenColorPicker: () {
                ColorPickerOverlay(
                  context: context,
                  initialColor: widget.currentColor!,
                  onSelect: widget.onColorChanged,
                ).show();
              },
            ),
          ),

        if (widget.selectedSubTool == SubTool.font)
          IgnorePointer(
            ignoring: widget.isOpen,
            child: FontsFab(onSelect: widget.onFontChanged),
          ),

        if (widget.selectedSubTool == SubTool.thickness)
          SliderFab(
            isCustom: true,
            strokeWidth: localStrokeWidth,
            minValue: 1,
            maxValue: 20,
            onChanged: (value) {
              setState(() => localStrokeWidth = value);
              widget.onStrokeWidthChanged(value);
            },
          ),

        if (widget.selectedSubTool == SubTool.wallpaper)
          PaperBgFab(
            onSelect: (image) => ref
                .read(journalProvider.notifier)
                .setBackgroundImage(AssetImage(image)),
            addBg: widget.pickImage,
            deleteBg: () =>
                ref.read(journalProvider.notifier).setBackgroundImage(null),
          ),

        if (widget.selectedSubTool == SubTool.slider)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: SliderFab(
                  strokeWidth: background.opacity,
                  minValue: 0,
                  maxValue: 1,
                  onChanged: (value) =>
                      ref.read(journalProvider.notifier).setOpacity(value),
                ),
              ),
              Flexible(
                child: SliderFab(
                  strokeWidth: background.blur,
                  minValue: 0,
                  maxValue: 20,
                  onChanged: (value) =>
                      ref.read(journalProvider.notifier).setBlur(value),
                ),
              ),
            ],
          ),

        const SizedBox(height: 5),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.selectedTool != null)
              IgnorePointer(
                ignoring: widget.isOpen,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(
                      overscroll: false,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      reverse: true,
                      child: JournalSubFAB(
                        selectedTool: widget.selectedTool,
                        selectedSubTool: widget.selectedSubTool,
                        onToolSelected: widget.onSubToolSelected,
                        onUpdateLayer: widget.onLayerUpdated,
                        layer: widget.focusedLayer,
                        whiteBoardController:
                            widget.focusedLayer?.type == LayerType.drawing
                            ? widget.focusedLayer!.whiteBoardController
                            : null,
                        currentBrushColor: widget.currentBrushColor,
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(width: 15),

            JournalFloatingBar(
              isOpen: widget.isOpen,
              selectedTool: widget.selectedTool,
              onToolSelected: widget.onToolSelected,
              onToggle: widget.onToggle,
            ),
          ],
        ),
      ],
    );
  }
}
