import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  const ColorPickerDialog({super.key, required this.initialColor});

  @override
  State<ColorPickerDialog> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPickerDialog> {
  late Color tempColor;
  late TextEditingController hexController;

  @override
  void initState() {
    super.initState();

    tempColor = widget.initialColor;

    hexController = TextEditingController(
      text:
          '#${tempColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Pick a color'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPicker(
              pickerColor: tempColor,
              enableAlpha: false,
              onColorChanged: (color) {
                tempColor = color;
                hexController.text =
                    '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: hexController,
              cursorColor: Theme.of(context).primaryColor,
              decoration: InputDecoration(
                labelText: 'Hex code',
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              onChanged: (value) {
                try {
                  if (value.startsWith('#')) {
                    String hex = value.substring(1);

                    // Remove any non-hex characters
                    hex = hex.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');

                    // If length > 6, take last 6 chars
                    if (hex.length > 6) hex = hex.substring(hex.length - 6);

                    // If length < 6, pad with zeros at end
                    if (hex.length < 6) hex = hex.padRight(6, '0');

                    // Always add full opacity
                    tempColor = Color(int.parse('FF$hex', radix: 16));

                    // Update TextField to match sanitized value
                    hexController.text = '#${hex.toUpperCase()}';
                    hexController.selection = TextSelection.fromPosition(
                      TextPosition(offset: hexController.text.length),
                    );
                  }
                } catch (_) {}
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
            child: Text('Select'),
            onPressed: () {
              Navigator.of(context).pop(tempColor);
            },
          ),
        ],
      ),
    );
  }
}
