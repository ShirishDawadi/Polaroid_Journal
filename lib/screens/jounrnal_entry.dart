import 'package:flutter/material.dart';
import 'package:polaroid_journal/widgets/color_picker.dart';
import 'package:polaroid_journal/widgets/moveable_textfield.dart';

class JournalEntryScreen extends StatefulWidget {
  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  Color currentColor = Colors.white;
  bool isOpen = true;
  int selectedTool = -1;
  List<MovableTextField> texts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Journal Entry")),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
          decoration: BoxDecoration(
            color: currentColor,
            border: Border.all(color: Colors.brown, width: 2),
          ),
          child: Stack(children: texts),
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: isOpen
                    ? [
                        IconButton(
                          icon: selectedTool == 0
                              ? Icon(Icons.photo_library)
                              : Icon(Icons.photo_library_outlined),
                          onPressed: () => setState(() => selectedTool = 0),
                        ),
                        IconButton(
                          icon: selectedTool == 2
                              ? Icon(Icons.text_fields)
                              : Icon(Icons.text_fields_outlined),
                          onPressed: () {
                            setState(() {
                              selectedTool = 2;
                              texts.add(
                                MovableTextField(
                                  onRemove: () {
                                    setState(() {
                                      texts.removeLast();
                                    });
                                  },
                                  context: context,
                                ),
                              );
                            });
                          },
                        ),
                        IconButton(
                          icon: selectedTool == 1
                              ? Icon(Icons.brush)
                              : Icon(Icons.brush_outlined),
                          onPressed: () => setState(() => selectedTool = 1),
                        ),
                        IconButton(
                          icon: selectedTool == 3
                              ? Icon(Icons.format_paint)
                              : Icon(Icons.format_paint_outlined),
                          onPressed: () async {
                            setState(() => selectedTool = 3);
                            final picked = await showDialog<Color>(
                              context: context,
                              builder: (_) =>
                                  ColorPickerDialog(initialColor: currentColor),
                            );
                            if (picked != null) {
                              setState(() => currentColor = picked);
                            }
                          },
                        ),
                      ]
                    : [],
              ),
            ),
            
            // Arrow button
            AnimatedRotation(
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
              turns: isOpen? 0 :0.5 ,
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios_rounded),
                onPressed: () => setState(() {
                  selectedTool = -1;
                  isOpen = !isOpen;
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}