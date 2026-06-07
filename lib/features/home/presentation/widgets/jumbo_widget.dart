import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JumboWidget extends StatefulWidget {
  const JumboWidget({
    super.key,
    required this.tapAmount,
    required this.onTap,
  });

  final int tapAmount;
  final VoidCallback onTap;

  @override
  State<JumboWidget> createState() => _JumboWidgetState();
}

class _JumboWidgetState extends State<JumboWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    HapticFeedback.mediumImpact();
    await _bounceController.forward();
    await _bounceController.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _bounceController,
      builder: (_, _) => GestureDetector(
        onTap: _handleTap,
        child: Transform.scale(
          scale: 1.0 - _bounceController.value * 0.08,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/elephant.png',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Tap Jumbo · +${widget.tapAmount}ml',
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
    );
  }
}
