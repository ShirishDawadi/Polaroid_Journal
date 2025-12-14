import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_painting_tools/flutter_painting_tools.dart' show PaintingBoard, PaintingBoardController;
import 'package:image_picker/image_picker.dart';
import 'package:polaroid_journal/widgets/color_floating_bar.dart';
import 'package:polaroid_journal/widgets/color_picker/color_picker_overlay.dart';
// import 'package:polaroid_journal/widgets/color_picker.dart';
import 'package:polaroid_journal/widgets/journal_floating_bar.dart';
import 'package:polaroid_journal/widgets/moveable_photo.dart';
import 'package:polaroid_journal/widgets/moveable_textfield.dart';

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

  bool isOpen = true;
  int selectedTool = -1;
  List<GlobalKey<MovableTextFieldState>> textKeys = [];
  List<MovableTextField> texts = [];

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
            });
          },
          context: context,
          textColor: currentTextColor,
        ),
      );
    });
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
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedTool != 0 && selectedTool != -1)
            AnimatedOpacity(
              opacity: 0.9,
              duration: Duration(milliseconds: 200),
              child: ColorFloatingBar(
                selectedColor: currentColor,
                onSelect: (color) {
                  setState(() {
                    if (selectedTool == 1) {
                      controller.changeBrushColor(color);
                      currentBrushColor = color;
                    }

                    if (selectedTool == 2) {
                      currentTextColor = color;
                      for (var key in textKeys) {
                        final state = key.currentState;
                        if (state != null && state.isFocused) {
                          state.updateTextColor(color);
                          break;
                        }
                      }
                    }

                    if (selectedTool == 3) currentBackgroundColor = color;

                    currentColor = color;
                  });
                },
                onOpenColorPicker: () {
                  ColorPickerOverlay(
                    context: context,
                    initialColor: currentColor,
                    onSelect: (picked) {
                      setState(() {
                        if (selectedTool == 1) {
                          controller.changeBrushColor(picked);
                          currentBrushColor = picked;
                        }

                        if (selectedTool == 2) {
                          currentTextColor = picked;
                          for (var key in textKeys) {
                            final state = key.currentState;
                            if (state != null && state.isFocused) {
                              state.updateTextColor(picked);
                              break;
                            }
                          }
                        }
                        if (selectedTool == 3) currentBackgroundColor = picked;
                        
                        currentColor = picked;
                      });
                    },
                  ).show();
                },
              ),
            ),

          SizedBox(height: 5),

          JournalFloatingBar(
            isOpen: isOpen,
            selectedTool: selectedTool,
            onToolSelected: (tool) async {
              setState(() {
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
                selectedTool = -1;
                isOpen = !isOpen;
              });
            },
          ),
        ],
      ),
    );
  }
}
