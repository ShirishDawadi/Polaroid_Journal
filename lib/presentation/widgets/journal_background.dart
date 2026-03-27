import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:polaroid_journal/presentation/viewmodels/journal_state.dart';

class JournalBackground extends StatelessWidget {
  final BackgroundConfig config;

  const JournalBackground({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: (config.primaryColor ?? config.secondaryColor) ??
                Colors.transparent,
            gradient: (config.primaryColor != null &&
                    config.secondaryColor != null)
                ? LinearGradient(
                    colors: [config.primaryColor!, config.secondaryColor!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
          ),
        ),
        if (config.image != null)
          Opacity(
            opacity: config.opacity,
            child: Image(
              image: config.image!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        if (config.blur > 0)
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: config.blur,
                sigmaY: config.blur,
              ),
              child: Container(color: Colors.transparent),
            ),
          ),
      ],
    );
  }
}