import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerOverlay {
  final BuildContext context;
  final Color initialColor;
  final void Function(Color) onSelect;

  OverlayEntry? _overlay;

  ColorPickerOverlay({
    required this.context,
    required this.initialColor,
    required this.onSelect,
  });

  void show() {
    Color tempColor = initialColor;
    TextEditingController hexController = TextEditingController(
      text:
          '#${tempColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
    );

    _overlay = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: hide,
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 20,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ColorPicker(
                        pickerColor: tempColor,
                        enableAlpha: false,
                        displayThumbColor: false,
                        labelTypes: [],
                        pickerAreaHeightPercent: 0.7,
                        onColorChanged: (color) {
                          tempColor = color;
                          hexController.text =
                              '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
                        },
                      ),
                      SizedBox(height: 0),
                      TextField(
                        controller: hexController,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          labelText: 'Hex code',
                          labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        onChanged: (value) {
                          try {
                            if (value.startsWith('#')) {
                              String hex = value.substring(1);

                              hex = hex.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');

                              if (hex.length > 6) {
                                hex = hex.substring(hex.length - 6);
                              }

                              if (hex.length < 6) {
                                hex = hex.padRight(6, '0');
                              }

                              tempColor = Color(int.parse('FF$hex', radix: 16));

                              hexController.text = '#${hex.toUpperCase()}';
                              hexController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(offset: hexController.text.length),
                              );
                            }
                          } catch (_) {}
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ),
                        child: Text('Select'),
                        onPressed: () {
                          onSelect(tempColor);
                          hide();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlay!);
  }

  void hide() {
    _overlay?.remove();
    _overlay = null;
  }
}
