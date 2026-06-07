import 'dart:math';
import 'package:flutter/material.dart';

class WaterWave extends StatefulWidget {
  const WaterWave({
    super.key,
    required this.fillPercent,
    required this.waveColor,
  });

  final double fillPercent;
  final Color waveColor;

  @override
  State<WaterWave> createState() => _WaterWaveState();
}

class _WaterWaveState extends State<WaterWave> with TickerProviderStateMixin {
  late AnimationController _phaseCtrl;
  late AnimationController _fillCtrl;

  @override
  void initState() {
    super.initState();
    _fillCtrl = AnimationController(
      vsync: this,
      value: widget.fillPercent.clamp(0.0, 0.95),
    );
    _phaseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
    _phaseCtrl.addListener(() => setState(() {}));
    _fillCtrl.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(WaterWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fillPercent != widget.fillPercent) {
      _fillCtrl.animateTo(
        widget.fillPercent.clamp(0.0, 0.95),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _phaseCtrl.dispose();
    _fillCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WavePainter(
        phase: _phaseCtrl.value,
        fill: _fillCtrl.value,
        waveColor: widget.waveColor,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter({
    required this.phase,
    required this.fill,
    required this.waveColor,
  });

  final double phase;
  final double fill;
  final Color waveColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (fill <= 0.01) return;

    final baseY = size.height * (1.0 - fill.clamp(0.0, 0.95));

    final paint1 = Paint()
      ..color = waveColor.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;
    final path1 = Path()..moveTo(0, baseY);
    for (double x = 0; x <= size.width; x += 2.0) {
      final y = baseY + sin(x / size.width * 2 * pi + phase * 2 * pi) * 10;
      path1.lineTo(x, y);
    }
    path1
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path1, paint1);

    final paint2 = Paint()
      ..color = waveColor.withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;
    final path2 = Path()..moveTo(0, baseY + 3);
    for (double x = 0; x <= size.width; x += 2.0) {
      final y =
          baseY + 3 + sin(x / size.width * 2 * pi + phase * 2 * pi + pi * 0.6) * 8;
      path2.lineTo(x, y);
    }
    path2
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path2, paint2);

    final solidPaint = Paint()
      ..color = waveColor.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(0, baseY + 12, size.width, size.height - baseY - 12),
      solidPaint,
    );
  }

  @override
  bool shouldRepaint(_WavePainter _) => true;
}
