// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polaroid_journal/data/models/layer_model.dart';
import 'package:polaroid_journal/core/utils/tools_enum.dart';
import 'package:polaroid_journal/presentation/widgets/floatingBars/color_floating_bar.dart';
import 'package:polaroid_journal/presentation/widgets/color_picker/color_picker_overlay.dart';
import 'package:polaroid_journal/presentation/widgets/floatingBars/fonts_fab.dart';
import 'package:polaroid_journal/presentation/widgets/floatingBars/journal_floating_bar.dart';
import 'package:polaroid_journal/presentation/widgets/floatingBars/paper_bg_fab.dart';
import 'package:polaroid_journal/presentation/widgets/floatingBars/slider_fab.dart';
import 'package:polaroid_journal/presentation/widgets/journal_background.dart';
import 'package:polaroid_journal/presentation/widgets/layer/drawing_layer.dart';
import 'package:polaroid_journal/presentation/widgets/layer/moveable_photo.dart';
import 'package:polaroid_journal/presentation/widgets/layer/moveable_textfield.dart';
import 'package:polaroid_journal/presentation/widgets/floatingBars/journal_sub_fab.dart';
import 'package:polaroid_journal/presentation/widgets/stickers_bottom_sheet.dart';
import 'package:polaroid_journal/presentation/viewmodels/journal_viewmodel.dart';
import 'package:whiteboard/whiteboard.dart';

class JournalEntryScreen extends ConsumerStatefulWidget {
  const JournalEntryScreen({super.key});

  @override
  ConsumerState<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends ConsumerState<JournalEntryScreen> {
  LayerModel? focusedLayer;

  Color currentTextColor = Colors.black;
  Color currentBrushColor = Colors.black;
  Color? currentColor = Colors.black;
  bool isIgnoring = true;

  bool isErasing = false;
  double strokeWidth = 3;

  bool isOpen = false;
  Tool? selectedTool;
  SubTool? selectedSubTool;

  bool _isPickingImage = false;

  // ─── Layer actions ────────────────────────────────────────────────────────

  void _onPhotoFocused(LayerModel layer) {
    setState(() {
      _bringToTop(layer);
      if (selectedTool != Tool.draw) focusedLayer = layer;
      if (selectedTool != Tool.image) selectedTool = Tool.image;
    });
  }

  void _onTextFocused(LayerModel layer) {
    setState(() {
      _bringToTop(layer);
      if (selectedTool != Tool.draw) focusedLayer = layer;
      if (selectedTool != Tool.text) selectedTool = Tool.text;
    });
  }

  void _onLayerRemoved(LayerModel layer) {
    ref.read(journalProvider.notifier).removeLayer(layer.id);
    setState(() => focusedLayer = null);
  }

  void _onLayerUpdated(LayerModel updatedLayer) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(journalProvider.notifier).updateLayer(updatedLayer);
      setState(() => focusedLayer = updatedLayer);
    });
  }

  void _bringToTop(LayerModel layer) {
    final layers = ref.read(journalProvider).layers;
    if (layers.last != layer) {
      ref.read(journalProvider.notifier).reorderToTop(layer.id);
    }
  }

  // ─── Image picking ────────────────────────────────────────────────────────

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    _isPickingImage = true;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) {
      _isPickingImage = false;
      return;
    }

    if (selectedSubTool == SubTool.photo) {
      final layer = LayerModel(
        id: UniqueKey().toString(),
        type: LayerType.photo,
        image: FileImage(File(picked.path)),
      );
      setState(() {
        focusedLayer = layer;
        ref.read(journalProvider.notifier).addLayer(layer);
      });
    }

    if (selectedSubTool == SubTool.wallpaper) {
      ref
          .read(journalProvider.notifier)
          .setBackgroundImage(FileImage(File(picked.path)));
    }

    _isPickingImage = false;
  }

  // ─── Text ─────────────────────────────────────────────────────────────────

  void _addTextField() {
    final layer = LayerModel(
      id: UniqueKey().toString(),
      type: LayerType.text,
      text: '',
    );
    setState(() {
      focusedLayer = layer;
      ref.read(journalProvider.notifier).addLayer(layer);
    });
  }

  // ─── Color ────────────────────────────────────────────────────────────────

  void _changeColor(Color? color) {
    if (color != null) {
      if (selectedTool == Tool.draw) currentBrushColor = color;
      if (selectedTool == Tool.text) {
        currentTextColor = color;
        ref.read(journalProvider.notifier).updateLayer(
              focusedLayer!.copyWith(textColor: color),
            );
        setState(() {
          focusedLayer = ref
              .read(journalProvider)
              .layers
              .firstWhere((l) => l.id == focusedLayer!.id);
        });
      }
    }
    if (selectedTool == Tool.background) {
      if (selectedSubTool == SubTool.secondaryBackgroundColor) {
        ref.read(journalProvider.notifier).setSecondaryColor(color);
      } else {
        ref.read(journalProvider.notifier).setPrimaryColor(color);
      }
    }
    setState(() => currentColor = color);
  }

  // ─── Font ─────────────────────────────────────────────────────────────────

  void _changeFont(String font) {
    ref.read(journalProvider.notifier).updateLayer(
          focusedLayer!.copyWith(fontFamily: font),
        );
    setState(() {
      focusedLayer = ref
          .read(journalProvider)
          .layers
          .firstWhere((l) => l.id == focusedLayer!.id);
    });
  }

  // ─── Stickers ─────────────────────────────────────────────────────────────

  void _openStickerSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) {
        return StickersBottomSheet(
          onSelect: (sticker) {
            Navigator.pop(context);
            final layer = LayerModel(
              id: UniqueKey().toString(),
              type: LayerType.photo,
              image: AssetImage(sticker),
            );
            FocusScope.of(context).unfocus();
            setState(() {
              focusedLayer = layer;
              ref.read(journalProvider.notifier).addLayer(layer);
            });
          },
        );
      },
    );
  }

  // ─── Tool selection ───────────────────────────────────────────────────────

  void _onCanvasTapped() {
    FocusScope.of(context).unfocus();
    if (selectedTool != Tool.draw) {
      setState(() {
        selectedTool = null;
        selectedSubTool = null;
        focusedLayer = null;
      });
    }
  }

  void _onSubToolSelected(SubTool selected) async {
    setState(() {
      selectedSubTool = selected;
      if (selected == SubTool.erase) isErasing = !isErasing;
      if (selected == SubTool.secondaryBackgroundColor) {
        currentColor =
            ref.read(journalProvider).background.secondaryColor;
      }
      if (selected == SubTool.primaryBackgroundColor) {
        currentColor = ref.read(journalProvider).background.primaryColor;
      }
      if (selected == SubTool.add) {
        final l = LayerModel(
          id: UniqueKey().toString(),
          type: LayerType.drawing,
          whiteBoardController: WhiteBoardController(),
        );
        ref.read(journalProvider.notifier).addLayer(l);
        focusedLayer = l;
      }
    });
    if (selected == SubTool.photo) await _pickImage();
    if (selected == SubTool.sticker) _openStickerSheet();
  }

  void _onToolSelected(Tool tool) async {
    setState(() {
      isOpen = false;
      selectedTool = tool;
      if (tool == Tool.draw) {
        isIgnoring = false;
        final layers = ref.read(journalProvider).layers;
        final drawingLayer = layers.lastWhere(
          (l) => l.type == LayerType.drawing,
          orElse: () {
            final l = LayerModel(
              id: UniqueKey().toString(),
              type: LayerType.drawing,
              whiteBoardController: WhiteBoardController(),
            );
            ref.read(journalProvider.notifier).addLayer(l);
            return l;
          },
        );
        focusedLayer = drawingLayer;
      } else {
        isIgnoring = true;
      }
      if (tool == Tool.text) currentColor = currentTextColor;
      if (tool == Tool.background) {
        currentColor = ref.read(journalProvider).background.primaryColor;
      }
    });
    if (tool == Tool.text) _addTextField();
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(journalProvider);
    final layers = state.layers;
    final background = state.background;

    return Scaffold(
      appBar: AppBar(title: const Text("New Journal Entry")),
      body: Stack(
        children: [
          GestureDetector(
            onTap: _onCanvasTapped,
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown, width: 2),
              ),
              child: Stack(
                children: [
                  JournalBackground(config: background),
                  for (final layer in layers)
                    if (layer.type == LayerType.photo)
                      MovablePhoto(
                        key: ValueKey(layer.id),
                        layer: layer,
                        isFocused:
                            layer == focusedLayer && selectedTool != Tool.draw,
                        onFocus: () => _onPhotoFocused(layer),
                      )
                    else if (layer.type == LayerType.drawing)
                      DrawingLayer(
                        key: ValueKey(layer.id),
                        layer: layer,
                        isActive: !isIgnoring,
                        currentBrushColor: currentBrushColor,
                        strokeWidth: strokeWidth,
                        isErasing: isErasing,
                      )
                    else if (layer.type == LayerType.text)
                      MovableTextField(
                        key: ValueKey(layer.id),
                        layer: layer,
                        isFocused:
                            layer == focusedLayer && selectedTool != Tool.draw,
                        onFocus: () => _onTextFocused(layer),
                        onRemove: () => _onLayerRemoved(layer),
                      ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => isOpen = false),
                child: Container(color: Colors.black.withValues(alpha: 0.6)),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
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
                onSelect: _changeColor,
                onOpenColorPicker: () {
                  ColorPickerOverlay(
                    context: context,
                    initialColor: currentColor!,
                    onSelect: _changeColor,
                  ).show();
                },
              ),
            ),

          if (selectedSubTool == SubTool.font)
            IgnorePointer(
              ignoring: isOpen,
              child: FontsFab(onSelect: _changeFont),
            ),

          if (selectedSubTool == SubTool.thickness)
            SliderFab(
              isCustom: true,
              strokeWidth: strokeWidth,
              minValue: 1,
              maxValue: 20,
              onChanged: (value) => setState(() => strokeWidth = value),
            ),

          if (selectedSubTool == SubTool.wallpaper)
            PaperBgFab(
              onSelect: (image) => ref
                  .read(journalProvider.notifier)
                  .setBackgroundImage(AssetImage(image)),
              addBg: _pickImage,
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
                          onToolSelected: _onSubToolSelected,
                          layer: focusedLayer,
                          whiteBoardController:
                              focusedLayer?.type == LayerType.drawing
                                  ? focusedLayer!.whiteBoardController
                                  : null,
                          currentBrushColor: currentBrushColor,
                          primaryBackgroundColor: background.primaryColor,
                          secondaryBackgroundColor: background.secondaryColor,
                          isImageBackground: background.image != null,
                          onUpdateLayer: _onLayerUpdated,
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(width: 15),

              JournalFloatingBar(
                isOpen: isOpen,
                selectedTool: selectedTool,
                onToolSelected: _onToolSelected,
                onToggle: () => setState(() {
                  selectedSubTool = null;
                  isOpen = !isOpen;
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}