import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polaroid_journal/widgets/color_floating_bar.dart';
import 'package:polaroid_journal/widgets/color_picker.dart';
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

  bool isOpen = true;
  int selectedTool = -1;
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
              child: Stack(children: [...photos, ...texts]),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedTool != 0 && selectedTool != -1 )
            AnimatedOpacity(
              opacity: 0.9,
              duration: Duration(milliseconds: 200),
              child: ColorFloatingBar(
                selectedColor: currentColor,
                onSelect: (color) {
                  setState(() {
                    if (selectedTool == 2) currentTextColor = color;
                    if (selectedTool == 3) currentBackgroundColor = color;
                    if (selectedTool == 1) currentBrushColor = color;
                    currentColor = color;
                  });
                },
                onOpenColorPicker: () async {
                  final picked = await showDialog<Color>(
                    context: context,
                    builder: (_) {
                      Color initialColor = currentColor;
                      return ColorPickerDialog(initialColor: initialColor);
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      if (selectedTool == 2) currentTextColor = picked;
                      if (selectedTool == 3) currentBackgroundColor = picked;
                      if (selectedTool == 1) currentBrushColor = picked;
                      currentColor = picked;
                    });
                  }
                },
              ),
            ),
            
          SizedBox(height: 5,),

          JournalFloatingBar(
            isOpen: isOpen,
            selectedTool: selectedTool,
            onToolSelected: (tool) async {
              setState(() {
                selectedTool = tool;
                if(selectedTool == 1) currentColor = currentBrushColor;
                if(selectedTool == 2) currentColor = currentTextColor;
                if(selectedTool == 3) currentColor = currentBackgroundColor;
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
