import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/double_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class ProgressRing extends StatefulWidget {
  const ProgressRing({
    super.key,
    required this.percentage,
    required this.totalMl,
    required this.goalMl,
    this.unit = 'ml',
    this.size = 260.0,
  });

  final double percentage;
  final int totalMl;
  final int goalMl;
  final String unit;
  final double size;

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  void _updateAnimation(double targetPercentage) {
    _animation = Tween<double>(
      begin: _animation.value,
      end: targetPercentage.clamp(0.0, 1.2),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward(from: 0.0);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: AppConstants.progressAnimationMs),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.percentage.clamp(0.0, 1.2),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void didUpdateWidget(ProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _updateAnimation(widget.percentage);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getProgressColor(BuildContext context, double percentage) {
    final colorScheme = Theme.of(context).colorScheme;
    if (percentage >= 1.0) return AppColors.goalAchieved;
    if (percentage >= 0.6) return colorScheme.primary;
    if (percentage >= 0.3) return AppColors.goalWarning;
    return AppColors.goalCritical;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _RingPainter(
                  percentage: _animation.value,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  progressColor:
                      _getProgressColor(context, widget.percentage),
                  strokeWidth: 20.0,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.totalMl.toDouble().toHydrationString(widget.unit),
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'of ${widget.goalMl.toDouble().toHydrationString(widget.unit)} goal',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.percentage >= 1.0)
                    Text(
                      '🎉 Goal reached!',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.goalAchieved,
                      ),
                    )
                  else
                    Text(
                      '${widget.goalMl - widget.totalMl > 0 ? (widget.goalMl - widget.totalMl).toDouble().toHydrationString(widget.unit) : "0ml"} to go',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.percentage,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  final double percentage;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    if (percentage <= 0.0) return;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * percentage.clamp(0.0, 1.0);
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);

    if (percentage > 1.0) {
      final overflowPaint = Paint()
        ..color = AppColors.goalAchieved.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 4
        ..strokeCap = StrokeCap.round;
      final overflowSweep = 2 * pi * (percentage - 1.0).clamp(0.0, 0.2);
      canvas.drawArc(rect, startAngle, overflowSweep, false, overflowPaint);
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) => true;
}
