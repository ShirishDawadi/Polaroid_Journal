import 'package:flutter/material.dart';

class FontsFab extends StatelessWidget {
  final Function(String) onSelect;

  FontsFab({super.key, required this.onSelect});

  final List<String> fonts = ['Roboto', 'KrabbyPatty'];

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
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Text(font, style: TextStyle(fontFamily: font)),
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
