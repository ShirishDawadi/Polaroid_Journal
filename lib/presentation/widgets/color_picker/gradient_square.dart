import 'package:flutter/material.dart';

class GradientSquare extends StatelessWidget {
  final double hue;
  final double saturation;
  final double value;
  final Function(double, double) onColorChanged;

  const GradientSquare({
    required this.hue,
    required this.saturation,
    required this.value,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) => _handleTouch(details.localPosition),
      onPanUpdate: (details) => _handleTouch(details.localPosition),
      child: SizedBox(
        width: 150,
        height: 150,
        child: ClipRRect(
          child: CustomPaint(
            painter: _GradientSquarePainter(
              hue: hue,
              saturation: saturation,
              value: value,
            ),
          ),
        ),
      ),
    );
  }

  void _handleTouch(Offset position) {
    final s = (position.dx / 150).clamp(0.0, 1.0);
    final v = (1.0 - position.dy / 150).clamp(0.0, 1.0);
    onColorChanged(s, v);
  }
}

class _GradientSquarePainter extends CustomPainter {
  final double hue;
  final double saturation;
  final double value;

  _GradientSquarePainter({
    required this.hue,
    required this.saturation,
    required this.value,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final hueColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = hueColor);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.white, Colors.white.withAlpha(0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final x = saturation * size.width;
    final y = (1 - value) * size.height;

    canvas.drawCircle(
      Offset(x, y),
      8,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    canvas.drawCircle(
      Offset(x, y),
      6,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _GradientSquarePainter old) =>
      old.hue != hue || old.saturation != saturation || old.value != value;
}
