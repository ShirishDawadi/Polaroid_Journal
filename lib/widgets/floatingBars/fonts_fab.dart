import 'dart:ui';

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
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          overscroll: false,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...fonts.map(
                (font) => Row(
                  children: [
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => onSelect(font),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surface.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Text(
                              font,
                              style: TextStyle(
                                fontFamily: font,
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
