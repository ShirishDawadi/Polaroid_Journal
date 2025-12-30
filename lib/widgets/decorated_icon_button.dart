import 'package:flutter/material.dart';
class DecoratedIconButton extends StatelessWidget {
  final IconData icon;
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
    return Container(
      decoration: 
      BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Theme.of(context).primaryColor),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        color: color,
        onPressed: onPressed,
      ),
    );
  }
}
