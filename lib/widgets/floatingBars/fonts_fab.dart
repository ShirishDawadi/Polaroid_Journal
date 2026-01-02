import 'package:flutter/material.dart';

class FontsFab extends StatelessWidget {
  final Function(String) onSelect;

  FontsFab({super.key, required this.onSelect});

  final List<String> fonts = [
    'Roboto',
    'KrabbyPatty',
    'AbrilFatface',
    'Akira',
    'AppleGaramond',
    'Moonlight',
    'OpenSans',
    'Sekuya',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...fonts.map(
                (font) => GestureDetector(
                  onTap: () => onSelect(font),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      font,
                      style: TextStyle(fontFamily: font, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
