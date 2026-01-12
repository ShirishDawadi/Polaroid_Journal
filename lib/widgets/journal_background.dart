import 'dart:ui';
import 'package:flutter/material.dart';

class JournalBackground extends StatelessWidget {
  final Color? primaryBackgroundColor;
  final Color? secondaryBackgroundColor;
  final ImageProvider? image;
  final double imageOpacity;
  final double imageBlur;

  const JournalBackground({
    super.key,
    required this.primaryBackgroundColor,
    required this.secondaryBackgroundColor,
    this.image,
    this.imageOpacity = 1,
    this.imageBlur = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Gradient or solid color
          Container(
            decoration: BoxDecoration(
              color:
                  (primaryBackgroundColor ?? secondaryBackgroundColor) ??
                  Colors.transparent,
              gradient:
                  (primaryBackgroundColor != null &&
                      secondaryBackgroundColor != null)
                  ? LinearGradient(
                      colors: [
                        primaryBackgroundColor!,
                        secondaryBackgroundColor!,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  : null,
            ),
          ),

          if (image != null)
            Opacity(
              opacity: imageOpacity,
              child: Image(
                image: image!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

          if (imageBlur > 0)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: imageBlur, sigmaY: imageBlur),
                child: Container(color: Colors.transparent),
              ),
            ),
        ],
      ),
    );
  }
}
