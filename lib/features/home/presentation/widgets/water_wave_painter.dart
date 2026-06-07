import 'dart:math';
import 'package:flutter/material.dart';

class WaterWavePainter extends StatefulWidget {
  const WaterWavePainter({
    super.key,
    required this.fillPercent,
    required this.waveColor,
  });

  final double fillPercent;
  final Color waveColor;

  @override
  State<WaterWavePainter> createState() => _WaterWavePainterState();
}

class _WaterWavePainterState extends State<WaterWavePainter>
    with TickerProviderStateMixin {
  late AnimationController _phaseController;
  late AnimationController _heightController;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _phaseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

    _heightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _heightAnimation = Tween<double>(
      begin: 0,
      end: widget.fillPercent,
    ).animate(CurvedAnimation(
      parent: _heightController,
      curve: Curves.easeOutCubic,
    ));
    _heightController.forward();
  }

  @override
  void didUpdateWidget(WaterWavePainter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fillPercent != widget.fillPercent) {
      _heightAnimation = Tween<double>(
        begin: _heightAnimation.value,
        end: widget.fillPercent,
      ).animate(CurvedAnimation(
        parent: _heightController,
        curve: Curves.easeOutCubic,
      ));
      _heightController
        ..duration = const Duration(milliseconds: 800)
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _phaseController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_phaseController, _heightController]),
      builder: (_, _) => CustomPaint(
        painter: _WavePainter(
          phase: _phaseController.value,
          fillPercent: _heightAnimation.value,
          waveColor: widget.waveColor,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter({
    required this.phase,
    required this.fillPercent,
    required this.waveColor,
  });

  final double phase;
  final double fillPercent;
  final Color waveColor;

  @override
  void paint(Canvas canvas, Size size) {
    final fillHeight = size.height * (1.0 - fillPercent.clamp(0.0, 0.95));

    final paint1 = Paint()..color = waveColor.withValues(alpha: 0.4);
    final path1 = Path();
    path1.moveTo(0, fillHeight);
    for (double x = 0; x <= size.width; x++) {
      final y = fillHeight + sin((x / size.width * 2 * pi) + phase * 2 * pi) * 12;
      path1.lineTo(x, y);
    }
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, paint1);

    final paint2 = Paint()..color = waveColor.withValues(alpha: 0.25);
    final path2 = Path();
    path2.moveTo(0, fillHeight + 4);
    for (double x = 0; x <= size.width; x++) {
      final y = fillHeight + 4 +
          sin((x / size.width * 2 * pi) + phase * 2 * pi + pi * 0.7) * 10;
      path2.lineTo(x, y);
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) =>
      oldDelegate.phase != phase ||
      oldDelegate.fillPercent != fillPercent ||
      oldDelegate.waveColor != waveColor;
}
