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

class JournalToolbar extends ConsumerWidget {
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
    required this.onToggle,
    required this.pickImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final background = ref.watch(journalProvider).background;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (selectedSubTool == SubTool.color ||
            selectedSubTool == SubTool.secondaryBackgroundColor ||
            selectedSubTool == SubTool.primaryBackgroundColor)
          IgnorePointer(
            ignoring: isOpen,
            child: ColorFloatingBar(
              selectedColor: currentColor,
              tool: selectedTool,
              onSelect: onColorChanged,
              onOpenColorPicker: () {
                ColorPickerOverlay(
                  context: context,
                  initialColor: currentColor!,
                  onSelect: onColorChanged,
                ).show();
              },
            ),
          ),

        if (selectedSubTool == SubTool.font)
          IgnorePointer(
            ignoring: isOpen,
            child: FontsFab(onSelect: onFontChanged),
          ),

        if (selectedSubTool == SubTool.thickness)
          SliderFab(
            isCustom: true,
            strokeWidth: strokeWidth,
            minValue: 1,
            maxValue: 20,
            onChanged: (value) =>
                ref.read(journalProvider.notifier).setBlur(value),
          ),

        if (selectedSubTool == SubTool.wallpaper)
          PaperBgFab(
            onSelect: (image) => ref
                .read(journalProvider.notifier)
                .setBackgroundImage(AssetImage(image)),
            addBg: pickImage,
            deleteBg: () =>
                ref.read(journalProvider.notifier).setBackgroundImage(null),
          ),

        if (selectedSubTool == SubTool.slider)
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
            if (selectedTool != null)
              IgnorePointer(
                ignoring: isOpen,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      reverse: true,
                      child: JournalSubFAB(
                        selectedTool: selectedTool,
                        selectedSubTool: selectedSubTool,
                        onToolSelected: onSubToolSelected,
                        onUpdateLayer: onLayerUpdated,
                        layer: focusedLayer,
                        whiteBoardController:
                            focusedLayer?.type == LayerType.drawing
                                ? focusedLayer!.whiteBoardController
                                : null,
                        currentBrushColor: currentBrushColor,
                        // primaryBackgroundColor: background.primaryColor,
                        // secondaryBackgroundColor: background.secondaryColor,
                        // isImageBackground: background.image != null,
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(width: 15),

            JournalFloatingBar(
              isOpen: isOpen,
              selectedTool: selectedTool,
              onToolSelected: onToolSelected,
              onToggle: onToggle,
            ),
          ],
        ),
      ],
    );
  }
}