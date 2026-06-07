import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class _SplashParticle {
  _SplashParticle({
    required this.direction,
    required this.size,
    required this.ctrl,
  });

  final Offset direction;
  final double size;
  final AnimationController ctrl;
}

class JumboWidget extends StatefulWidget {
  const JumboWidget({
    super.key,
    required this.tapAmount,
    required this.onTap,
    this.unit = 'ml',
  });

  final int tapAmount;
  final VoidCallback onTap;
  final String unit;

  @override
  State<JumboWidget> createState() => _JumboWidgetState();
}

class _JumboWidgetState extends State<JumboWidget>
    with TickerProviderStateMixin {
  late AnimationController _bounceCtrl;
  final List<_SplashParticle> _particles = [];

  static const _directions = [
    Offset(-0.8, -1.0), Offset(-0.4, -1.2), Offset(0.0, -1.3),
    Offset(0.4, -1.2),  Offset(0.8, -1.0), Offset(-1.0, -0.6),
    Offset(1.0, -0.6),  Offset(-1.1, -0.2), Offset(1.1, -0.2),
    Offset(-0.3, -0.9),
  ];

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    for (final p in _particles) {
      p.ctrl.dispose();
    }
    super.dispose();
  }

  void _handleTap() {
    _bounceCtrl.forward().then((_) => _bounceCtrl.reverse());
    HapticFeedback.mediumImpact();
    _spawnSplash();
    widget.onTap();
  }

  void _spawnSplash() {
    for (int i = 0; i < _directions.length; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600 + i * 20),
      );
      final particle = _SplashParticle(
        direction: _directions[i],
        size: 6.0 + (i % 4) * 1.5,
        ctrl: ctrl,
      );
      ctrl.forward().then((_) {
        if (!mounted) return;
        setState(() => _particles.remove(particle));
        ctrl.dispose();
      });
      setState(() => _particles.add(particle));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ..._particles.map((p) => AnimatedBuilder(
              animation: p.ctrl,
              builder: (_, _) {
                final progress = p.ctrl.value;
                final distance = progress * 60.0;
                final opacity = (1.0 - progress).clamp(0.0, 1.0);
                return Positioned(
                  left: 190 * 0.475 + p.direction.dx * distance - p.size / 2,
                  top: 160 * 0.78 + p.direction.dy * distance - p.size / 2,
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      width: p.size,
                      height: p.size * 1.3,
                      decoration: BoxDecoration(
                        color: const Color(0xFF38BDF8),
                        borderRadius: BorderRadius.circular(p.size),
                      ),
                    ),
                  ),
                );
              },
            )),
        GestureDetector(
          onTap: _handleTap,
          child: AnimatedBuilder(
            animation: _bounceCtrl,
            builder: (_, child) => Transform.scale(
              scale: 1.0 - _bounceCtrl.value * 0.1,
              child: child,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/jumbo.svg',
                  width: 190,
                  height: 160,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0EA5E9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0EA5E9).withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.unit == 'oz'
                        ? 'Tap Jumbo · +${(widget.tapAmount * 0.0338).toStringAsFixed(1)}oz'
                        : 'Tap Jumbo · +${widget.tapAmount}ml',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
