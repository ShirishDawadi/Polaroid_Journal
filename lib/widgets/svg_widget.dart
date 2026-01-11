import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSvg {
  static Widget icon({
    required BuildContext context,
    required String path,
    Color? color,
  }) {
    final iconColor = color ?? Theme.of(context).primaryColor;

    return SvgPicture.asset(
      path,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
    );
  }
}
