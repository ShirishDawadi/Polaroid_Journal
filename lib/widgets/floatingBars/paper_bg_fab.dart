import 'package:flutter/material.dart';
import 'package:polaroid_journal/utils/app_assets.dart';

class PaperBgFab extends StatelessWidget {
  PaperBgFab({super.key});

  final List<String> paperBg = [
    AppAssets.paperBg1,
    AppAssets.paperBg2,
    AppAssets.paperBg3,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 0, 10, 20),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...paperBg.map(
                (img) => Row(
                  children: [
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => {},
                      child: Image.asset(img , width: 50, height: 50,),
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
