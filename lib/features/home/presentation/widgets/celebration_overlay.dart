import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';

class CelebrationOverlay extends StatefulWidget {
  const CelebrationOverlay({
    super.key,
    required this.isVisible,
    required this.unit,
  });

  final bool isVisible;
  final String unit;

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  static const _dropPositions = [
    (0.1, 0.2), (0.9, 0.15), (0.2, 0.8), (0.85, 0.75),
    (0.15, 0.5), (0.9, 0.5), (0.5, 0.1), (0.5, 0.9),
    (0.3, 0.25), (0.7, 0.2), (0.25, 0.7), (0.75, 0.8),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: widget.isVisible
          ? _buildCelebration()
          : const SizedBox.shrink(),
    );
  }

  Widget _buildCelebration() {
    return IgnorePointer(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.goalAchieved.withValues(alpha: 0.15),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      size: 72,
                      color: AppColors.goalAchieved,
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.0, 0.0),
                        end: const Offset(1.0, 1.0),
                        duration: 500.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 300.ms),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.goalAchieved,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(
                      '🎉 Daily Goal Achieved!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                      .animate()
                      .slideY(
                        begin: 0.5,
                        end: 0.0,
                        duration: 400.ms,
                        delay: 300.ms,
                        curve: Curves.easeOutCubic,
                      )
                      .fadeIn(duration: 300.ms, delay: 300.ms),
                ],
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: List.generate(_dropPositions.length, (index) {
                  final pos = _dropPositions[index];
                  return Positioned(
                    left: pos.$1 * constraints.maxWidth,
                    top: pos.$2 * constraints.maxHeight,
                    child: Icon(
                      Icons.water_drop,
                      size: 20 + (index % 3) * 8.0,
                      color: AppColors.primary.withValues(alpha: 0.6),
                    )
                        .animate()
                        .scale(
                          begin: const Offset(0, 0),
                          end: const Offset(1, 1),
                          delay: Duration(milliseconds: 100 * index),
                          duration: 600.ms,
                          curve: Curves.elasticOut,
                        )
                        .fadeIn(
                          delay: Duration(milliseconds: 100 * index),
                        )
                        .then()
                        .fadeOut(delay: 1200.ms, duration: 600.ms),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
