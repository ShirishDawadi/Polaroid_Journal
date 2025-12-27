import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_painting_tools/flutter_painting_tools.dart'
    show PaintingBoard, PaintingBoardController;
import 'package:image_picker/image_picker.dart';
import 'package:polaroid_journal/widgets/floatingBars/color_floating_bar.dart';
import 'package:polaroid_journal/widgets/color_picker/color_picker_overlay.dart';
import 'package:polaroid_journal/widgets/floatingBars/fonts_fab.dart';
import 'package:polaroid_journal/widgets/floatingBars/journal_floating_bar.dart';
import 'package:polaroid_journal/widgets/moveable_photo.dart';
import 'package:polaroid_journal/widgets/moveable_textfield.dart';
import 'package:polaroid_journal/widgets/floatingBars/journal_sub_fab.dart';

class JournalEntryScreen extends StatefulWidget {
  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  Color currentBackgroundColor = Colors.white;
  Color currentTextColor = Colors.black;
  Color currentBrushColor = Colors.black;
  Color currentColor = Colors.black;
  bool isIgnoring = true;
  late final PaintingBoardController controller;

  bool isOpen = false;
  int selectedTool = -1;
  int selectedSubTool = -1;
  List<GlobalKey<MovableTextFieldState>> textKeys = [];
  List<MovableTextField> texts = [];
  GlobalKey<MovableTextFieldState>? selectedTextKey;

  List<MovablePhoto> photos = [];

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    setState(() {
      photos.add(MovablePhoto(image: File(picked.path), context: context));
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

  void changeColor(Color color) {
    if (selectedTool == 1) {
      controller.changeBrushColor(color);
      currentBrushColor = color;
    }

    if (selectedTool == 2) {
      currentTextColor = color;
      if (selectedTextKey != null && selectedTextKey!.currentState != null) {
        selectedTextKey!.currentState!.setTextColor(color);
      }
    }

    if (selectedTool == 3) currentBackgroundColor = color;

    currentColor = color;
  }

  @override
  void initState() {
    controller = PaintingBoardController();
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
              margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
              decoration: BoxDecoration(
                color: currentBackgroundColor,
                border: Border.all(color: Colors.brown, width: 2),
              ),
              child: Stack(
                children: [
                  ...photos,
                  ...texts,
                  IgnorePointer(
                    ignoring: isIgnoring,
                    child: Positioned.fill(
                      child: PaintingBoard(
                        boardBackgroundColor: Colors.transparent,
                        controller: controller,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (selectedSubTool == 3)
            ColorFloatingBar(
              selectedColor: currentColor,
              onSelect: (color) {
                setState(() => changeColor(color));
              },
              onOpenColorPicker: () {
                ColorPickerOverlay(
                  context: context,
                  initialColor: currentColor,
                  onSelect: (picked) {
                    setState(() => changeColor(picked));
                  },
                ).show();
              },
            ),
          if (selectedSubTool == 2)
            FontsFab(
              onSelect: (font) {
                setState(() {
                  if (selectedTextKey != null &&
                      selectedTextKey!.currentState != null) {
                    selectedTextKey!.currentState!.setFontFamily(font);
                  }
                });
              },
            ),
          SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (selectedTool != -1)
                UnconstrainedBox(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: JournalSubFAB(
                        selectedTool: selectedTool,
                        selectedSubTool: selectedSubTool,
                        onToolSelected: (selected) {
                          setState(() {
                            selectedSubTool = selected;
                          });
                        },
                        selectedTextKey: selectedTextKey,
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
                    if (selectedTool == 1) {
                      isIgnoring = false;
                      currentColor = currentBrushColor;
                    } else {
                      isIgnoring = true;
                    }
                    if (selectedTool == 2) currentColor = currentTextColor;
                    if (selectedTool == 3) currentColor = currentBackgroundColor;
                  });

                  if (tool == 0) await pickImage();

                  if (tool == 2) addTextField();
                },
                onToggle: () {
                  setState(() {
                    selectedSubTool = -1;
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
