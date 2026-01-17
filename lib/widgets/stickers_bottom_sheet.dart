import 'package:flutter/material.dart';
import 'package:polaroid_journal/utils/app_assets.dart';

class StickersBottomSheet extends StatelessWidget {
  final Function(String) onSelect;
  StickersBottomSheet({super.key, required this.onSelect});

  final List<String> stickers = [
    AppAssets.sticker1,
    AppAssets.sticker2,
    AppAssets.sticker3,
    AppAssets.sticker4,
    AppAssets.sticker5,
    AppAssets.sticker6,
    AppAssets.sticker7,
    AppAssets.sticker8,
    AppAssets.sticker9,
    AppAssets.sticker10,
    AppAssets.sticker11,
    AppAssets.sticker12,
    AppAssets.sticker13,
    AppAssets.sticker14,
    AppAssets.sticker15,
    AppAssets.sticker16,
    AppAssets.sticker17,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 75,
            height: 5,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Flexible(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              children: [
                ...stickers.map(
                  (sticker) => GestureDetector(
                    onTap: () {
                      onSelect(sticker);
                      Navigator.pop(context);
                    },
                    child: Image.asset(sticker),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
