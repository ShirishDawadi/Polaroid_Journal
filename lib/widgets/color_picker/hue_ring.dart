import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class HueRingWithHex extends StatelessWidget {
  final double hue;
  final TextEditingController hexController;
  final Function(double) onHueChanged;
  final Function(String) onHexChanged;

  const HueRingWithHex({
    required this.hue,
    required this.hexController,
    required this.onHueChanged,
    required this.onHexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) => _handleTouch(details.localPosition),
      onPanUpdate: (details) => _handleTouch(details.localPosition),
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(150, 150),
              painter: _HueRingPainter(hue: hue),
            ),
            SizedBox(
              width: 80,
              child: TextField(
                controller: hexController,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor.withAlpha(128),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: onHexChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTouch(Offset position) {
    final center = Offset(75, 75);
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;

    final distance = math.sqrt(dx * dx + dy * dy);
    if (distance < 55 || distance > 75) return;

    final angle = math.atan2(dy, dx);
    final hue = (angle * 180 / math.pi + 90 + 360) % 360;
    onHueChanged(hue);
  }
}

class _HueRingPainter extends CustomPainter {
  final double hue;

  static ui.Picture? _cachedRing;
  static Size? _cachedSize;

  _HueRingPainter({required this.hue});

  @override
  void paint(Canvas canvas, Size size) {
    if (_cachedRing == null || _cachedSize != size) {
      final recorder = ui.PictureRecorder();
      final ringCanvas = Canvas(recorder);

      final center = Offset(size.width / 2, size.height / 2);
      final radius = size.width / 2;
      const strokeWidth = 20.0;

      for (int i = 0; i < 360; i++) {
        final paint = Paint()
          ..color = HSVColor.fromAHSV(1, i.toDouble(), 1, 1).toColor()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

        final startAngle = (i - 90) * math.pi / 180;
        ringCanvas.drawArc(
          Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
          startAngle,
          math.pi / 180,
          false,
          paint,
        );
      }
      _cachedRing = recorder.endRecording();
      _cachedSize = size;
    }

    canvas.drawPicture(_cachedRing!);

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 20.0;

    final angle = (hue - 90) * math.pi / 180;
    final x = center.dx + (radius - strokeWidth / 2) * math.cos(angle);
    final y = center.dy + (radius - strokeWidth / 2) * math.sin(angle);

    canvas.drawCircle(Offset(x, y), 8, Paint()..color = Colors.white);
    canvas.drawCircle(
      Offset(x, y),
      6,
      Paint()..color = HSVColor.fromAHSV(1, hue, 1, 1).toColor(),
    );
  }

  @override
  bool shouldRepaint(covariant _HueRingPainter old) => old.hue != hue;
}
