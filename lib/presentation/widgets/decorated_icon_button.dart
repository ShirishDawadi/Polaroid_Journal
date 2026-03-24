import 'dart:ui';

import 'package:flutter/material.dart';
class DecoratedIconButton extends StatelessWidget {
  final Widget icon;
  final Color? color;
  final VoidCallback onPressed;

  const DecoratedIconButton({
    super.key,
    required this.icon,
    this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: 
          BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha:0.3),
            borderRadius: BorderRadius.circular(40),
          ),
          child: IconButton(
            icon: icon,
            color: color,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
