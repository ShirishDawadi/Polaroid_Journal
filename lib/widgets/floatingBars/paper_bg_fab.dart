import 'package:flutter/material.dart';
import 'package:polaroid_journal/utils/app_assets.dart';
import 'package:polaroid_journal/widgets/decorated_icon_button.dart';
import 'package:polaroid_journal/widgets/svg_widget.dart';

class PaperBgFab extends StatelessWidget {
  final Function(String) onSelect;
  final VoidCallback addBg;
  final VoidCallback deleteBg;
  PaperBgFab({super.key, required this.onSelect, required this.addBg, required this.deleteBg});

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
                      onTap: () => onSelect(img),
                      child: Image.asset(img, width: null, height: 50),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10,),

              DecoratedIconButton(icon: Icon(Icons.add), onPressed: addBg),

              SizedBox(width: 10,),

              DecoratedIconButton(
                icon: AppSvg.icon(context: context, path: AppAssets.delete),
                onPressed: deleteBg,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
