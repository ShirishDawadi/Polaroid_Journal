// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polaroid_journal/utils/tools_enum.dart';
import 'package:polaroid_journal/widgets/floatingBars/color_floating_bar.dart';
import 'package:polaroid_journal/widgets/color_picker/color_picker_overlay.dart';
import 'package:polaroid_journal/widgets/floatingBars/fonts_fab.dart';
import 'package:polaroid_journal/widgets/floatingBars/journal_floating_bar.dart';
import 'package:polaroid_journal/widgets/floatingBars/stroke_width_fab.dart';
import 'package:polaroid_journal/widgets/journal_background.dart';
import 'package:polaroid_journal/widgets/moveable_photo.dart';
import 'package:polaroid_journal/widgets/moveable_textfield.dart';
import 'package:polaroid_journal/widgets/floatingBars/journal_sub_fab.dart';
import 'package:whiteboard/whiteboard.dart';

class JournalEntryScreen extends StatefulWidget {
  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  Color? primaryBackgroundColor = Colors.white;
  Color? secondaryBackgroundColor;
  File? currentBackgroundImage;

  Color currentTextColor = Colors.black;
  Color currentBrushColor = Colors.black;
  Color? currentColor = Colors.black;
  bool isIgnoring = true;

  late final WhiteBoardController controller;
  bool isErasing = false;
  double strokeWidth = 3;

  bool isOpen = false;
  Tool? selectedTool;
  SubTool? selectedSubTool;
  List<GlobalKey<MovableTextFieldState>> textKeys = [];
  List<MovableTextField> texts = [];
  GlobalKey<MovableTextFieldState>? selectedTextKey;

  List<MovablePhoto> photos = [];

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

    setState(() {
      if (selectedTool == Tool.image)
        photos.add(MovablePhoto(image: File(picked.path), context: context));
      if (selectedSubTool == SubTool.wallpaper)
        currentBackgroundImage = File(picked.path);
      _isPickingImage = false;
    });
  }

  void addTextField() {
    final key = GlobalKey<MovableTextFieldState>();

    textKeys.add(key);
    setState(() {
      texts.add(
        MovableTextField(
          key: key,
          onRemove: (fieldKey) {
            setState(() {
              texts.removeWhere((t) => t.key == fieldKey);
              textKeys.removeWhere((k) => k == fieldKey);

              if (selectedTextKey == fieldKey) {
                selectedTextKey = null;
              }
            });
          },
          context: context,
          onFocusChanged: (key, isFocused) {
            setState(() {
              if (isFocused) {
                selectedTextKey = key as GlobalKey<MovableTextFieldState>;
              }
            });
          },
        ),
      );
    });
  }

  void changeColor(Color? color) {
    if (color != null) {
      if (selectedTool == Tool.draw) {
        currentBrushColor = color;
      }

      if (selectedTool == Tool.text) {
        currentTextColor = color;
        if (selectedTextKey != null && selectedTextKey!.currentState != null) {
          selectedTextKey!.currentState!.setTextColor(color);
        }
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

  @override
  void initState() {
    controller = WhiteBoardController();
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
                    // imageOpacity: currentImageOpacity,
                    // imageBlur: currentImageBlur,
                  ),
                  ...photos,
                  ...texts,
                  IgnorePointer(
                    ignoring: isIgnoring,
                    child: WhiteBoard(
                      backgroundColor: Colors.transparent,
                      strokeColor: currentBrushColor,
                      strokeWidth: strokeWidth,
                      isErasing: isErasing,
                      controller: controller,
                    ),
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
                    if (selectedTextKey != null &&
                        selectedTextKey!.currentState != null) {
                      selectedTextKey!.currentState!.setFontFamily(font);
                    }
                  });
                },
              ),
            ),
          if (selectedSubTool == SubTool.thickness)
            StrokeWidthFab(
              strokeWidth: strokeWidth,
              onChanged: (value) {
                setState(() => strokeWidth = value);
              },
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
                            });
                            if (selectedSubTool == SubTool.wallpaper)
                              await pickImage();
                          },
                          selectedTextKey: selectedTextKey,
                          whiteBoardController: controller,
                          currentBrushColor: currentBrushColor,
                          primaryBackgroundColor: primaryBackgroundColor,
                          secondaryBackgroundColor: secondaryBackgroundColor,
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
                    if (selectedTool == Tool.draw) {
                      isIgnoring = false;
                      currentColor = currentBrushColor;
                    } else {
                      isIgnoring = true;
                    }
                    if (selectedTool == Tool.text)
                      currentColor = currentTextColor;
                    if (selectedTool == Tool.background) {
                      currentColor = primaryBackgroundColor;
                    }
                  });

                  if (tool == Tool.image) await pickImage();

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
