import 'package:flutter/material.dart';
import 'package:polaroid_journal/utils/app_assets.dart';
import 'package:polaroid_journal/utils/tools_enum.dart';
import 'package:polaroid_journal/widgets/svg_widget.dart';

class JournalFloatingBar extends StatelessWidget {
  final bool isOpen;
  final Tool? selectedTool;

  final Function(Tool) onToolSelected;
  final Function() onToggle;

  const JournalFloatingBar({
    super.key,
    required this.isOpen,
    required this.selectedTool,
    required this.onToolSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: isOpen
                  ? [
                      IconButton(
                        icon: AppSvg.icon(
                          context: context,
                          path: selectedTool == Tool.image
                              ? AppAssets.imageFilled
                              : AppAssets.image,
                        ),
                        onPressed: () => onToolSelected(Tool.image),
                      ),
                      IconButton(
                        icon: AppSvg.icon(
                          context: context,
                          path: selectedTool == Tool.draw
                              ? AppAssets.brushFilled
                              : AppAssets.brush,
                        ),
                        onPressed: () => onToolSelected(Tool.draw),
                      ),
                      IconButton(
                        icon: AppSvg.icon(
                          context: context,
                          path: selectedTool == Tool.text
                              ? AppAssets.textFilled
                              : AppAssets.text,
                        ),
                        onPressed: () => onToolSelected(Tool.text),
                      ),
                      IconButton(
                        icon: AppSvg.icon(
                          context: context,
                          path: AppAssets.background,
                        ),
                        onPressed: () => onToolSelected(Tool.background),
                      ),
                    ]
                  : [],
            ),
          ),
          AnimatedRotation(
            duration: const Duration(milliseconds: 300),
            turns: isOpen ? 0.25 : 0.75,
            child: IconButton(
              iconSize: 20,
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              onPressed: onToggle,
            ),
          ),
        ],
      ),
    );
  }
}
