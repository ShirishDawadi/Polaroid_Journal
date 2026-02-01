// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polaroid_journal/models/layer_model.dart';
import 'package:polaroid_journal/utils/tools_enum.dart';
import 'package:polaroid_journal/widgets/floatingBars/color_floating_bar.dart';
import 'package:polaroid_journal/widgets/color_picker/color_picker_overlay.dart';
import 'package:polaroid_journal/widgets/floatingBars/fonts_fab.dart';
import 'package:polaroid_journal/widgets/floatingBars/journal_floating_bar.dart';
import 'package:polaroid_journal/widgets/floatingBars/paper_bg_fab.dart';
import 'package:polaroid_journal/widgets/floatingBars/slider_fab.dart';
import 'package:polaroid_journal/widgets/journal_background.dart';
import 'package:polaroid_journal/widgets/layer/drawing_layer.dart';
import 'package:polaroid_journal/widgets/layer/moveable_photo.dart';
import 'package:polaroid_journal/widgets/layer/moveable_textfield.dart';
import 'package:polaroid_journal/widgets/floatingBars/journal_sub_fab.dart';
import 'package:polaroid_journal/widgets/stickers_bottom_sheet.dart';
import 'package:whiteboard/whiteboard.dart';

class JournalEntryScreen extends StatefulWidget {
  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  List<LayerModel> layers = [];
  LayerModel? focusedLayer;

  Color? primaryBackgroundColor = Colors.white;
  Color? secondaryBackgroundColor;
  ImageProvider? currentBackgroundImage;
  double currentImageOpacity = 1;
  double currentImageBlur = 0;

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

  Future<void> pickImage() async {
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
        layers.add(layer);
      });
    }

    if (selectedSubTool == SubTool.wallpaper) {
      setState(() {
        currentBackgroundImage = FileImage(File(picked.path));
      });
    }

    _isPickingImage = false;
  }

  void addTextField() {
    final layer = LayerModel(
      id: UniqueKey().toString(),
      type: LayerType.text,
      text: '',
    );

    setState(() {
      focusedLayer = layer;
      layers.add(layer);
    });
  }

  void changeColor(Color? color) {
    if (color != null) {
      if (selectedTool == Tool.draw) {
        currentBrushColor = color;
      }

      if (selectedTool == Tool.text) {
        currentTextColor = color;
        focusedLayer!.textColor = color;
      }
    }
    if (selectedTool == Tool.background) {
      if (selectedSubTool == SubTool.secondaryBackgroundColor) {
        secondaryBackgroundColor = color;
      } else {
        primaryBackgroundColor = color;
      }
    }
    currentColor = color;
  }

  void openBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) {
        return StickersBottomSheet(
          onSelect: (sticker) {
            final layer = LayerModel(
              id: UniqueKey().toString(),
              type: LayerType.photo,
              image: AssetImage(sticker),
            );

            setState(() {
              focusedLayer = layer;
              layers.add(layer);
            });
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Journal Entry")),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              if (selectedTool != Tool.draw) {
                setState(() {
                  selectedTool = null;
                  selectedSubTool = null;
                  focusedLayer = null;
                });
              }
            },
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown, width: 2),
              ),
              child: Stack(
                children: [
                  JournalBackground(
                    primaryBackgroundColor: primaryBackgroundColor,
                    secondaryBackgroundColor: secondaryBackgroundColor,
                    image: currentBackgroundImage,
                    imageOpacity: currentImageOpacity,
                    imageBlur: currentImageBlur,
                  ),

                  for (final layer in layers)
                    if (layer.type == LayerType.photo)
                      MovablePhoto(
                        key: ValueKey(layer.id),
                        layer: layer,
                        isFocused:
                            layer == focusedLayer && selectedTool != Tool.draw,
                        onFocus: () => setState(() {
                          if (layers.last != layer) {
                            layers.remove(layer);
                            layers.add(layer);
                          }
                          if (selectedTool != Tool.draw) focusedLayer = layer;
                          if (selectedTool != Tool.image)
                            selectedTool = Tool.image;
                        }),
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
                        onFocus: () => setState(() {
                          if (layers.last != layer) {
                            layers.remove(layer);
                            layers.add(layer);
                          }
                          if (selectedTool != Tool.draw) focusedLayer = layer;
                          if (selectedTool != Tool.text)
                            selectedTool = Tool.text;
                        }),
                      ),
                ],
              ),
            ),
          ),

          if (isOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isOpen = false;
                  });
                },
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
                onSelect: (color) {
                  setState(() => changeColor(color));
                },
                onOpenColorPicker: () {
                  ColorPickerOverlay(
                    context: context,
                    initialColor: currentColor!,
                    onSelect: (picked) {
                      setState(() => changeColor(picked));
                    },
                  ).show();
                },
              ),
            ),

          if (selectedSubTool == SubTool.font)
            IgnorePointer(
              ignoring: isOpen,
              child: FontsFab(
                onSelect: (font) {
                  setState(() {
                    focusedLayer!.fontFamily = font;
                  });
                },
              ),
            ),

          if (selectedSubTool == SubTool.thickness)
            SliderFab(
              isCustom: true,
              strokeWidth: strokeWidth,
              minValue: 1,
              maxValue: 20,
              onChanged: (value) {
                setState(() => strokeWidth = value);
              },
            ),

          if (selectedSubTool == SubTool.wallpaper)
            PaperBgFab(
              onSelect: (image) {
                setState(() => currentBackgroundImage = AssetImage(image));
              },
              addBg: () async => await pickImage(),
              deleteBg: () {
                setState(() => currentBackgroundImage = null);
              },
            ),

          if (selectedSubTool == SubTool.slider)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: SliderFab(
                    strokeWidth: currentImageOpacity,
                    minValue: 0,
                    maxValue: 1,
                    onChanged: (value) {
                      setState(() => currentImageOpacity = value);
                    },
                  ),
                ),
                Flexible(
                  child: SliderFab(
                    strokeWidth: currentImageBlur,
                    minValue: 0,
                    maxValue: 20,
                    onChanged: (value) {
                      setState(() => currentImageBlur = value);
                    },
                  ),
                ),
              ],
            ),

          SizedBox(height: 5),

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
                      behavior: const ScrollBehavior().copyWith(
                        overscroll: false,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        reverse: true,
                        child: JournalSubFAB(
                          selectedTool: selectedTool,
                          selectedSubTool: selectedSubTool,
                          onToolSelected: (selected) async {
                            setState(() {
                              selectedSubTool = selected;
                              if (selectedSubTool == SubTool.erase)
                                isErasing = !isErasing;
                              if (selectedSubTool ==
                                  SubTool.secondaryBackgroundColor)
                                currentColor = secondaryBackgroundColor;
                              if (selectedSubTool ==
                                  SubTool.primaryBackgroundColor)
                                currentColor = primaryBackgroundColor;
                              if (selectedSubTool == SubTool.add) {
                                final l = LayerModel(
                                  id: UniqueKey().toString(),
                                  type: LayerType.drawing,
                                  whiteBoardController: WhiteBoardController(),
                                );
                                layers.add(l);
                                focusedLayer = l;
                              }
                            });
                            if (selectedSubTool == SubTool.photo)
                              await pickImage();
                            if (selectedSubTool == SubTool.sticker)
                              openBottomSheet();
                          },
                          layer: focusedLayer,
                          whiteBoardController:
                              focusedLayer?.type == LayerType.drawing
                              ? focusedLayer!.whiteBoardController
                              : null,
                          currentBrushColor: currentBrushColor,
                          primaryBackgroundColor: primaryBackgroundColor,
                          secondaryBackgroundColor: secondaryBackgroundColor,
                          isImageBackground: currentBackgroundImage != null,
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(width: 15),

              JournalFloatingBar(
                isOpen: isOpen,
                selectedTool: selectedTool,
                onToolSelected: (tool) async {
                  setState(() {
                    isOpen = false;
                    selectedTool = tool;
                    if (tool == Tool.draw) {
                      isIgnoring = false;
                      final drawingLayer = layers.lastWhere(
                        (l) => l.type == LayerType.drawing,
                        orElse: () {
                          final l = LayerModel(
                            id: UniqueKey().toString(),
                            type: LayerType.drawing,
                            whiteBoardController: WhiteBoardController(),
                          );
                          layers.add(l);
                          return l;
                        },
                      );
                      focusedLayer = drawingLayer;
                    } else {
                      isIgnoring = true;
                    }
                    if (selectedTool == Tool.text)
                      currentColor = currentTextColor;
                    if (selectedTool == Tool.background) {
                      currentColor = primaryBackgroundColor;
                    }
                  });

                  if (tool == Tool.text) addTextField();
                },
                onToggle: () {
                  setState(() {
                    selectedSubTool = null;
                    isOpen = !isOpen;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
