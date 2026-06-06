import 'package:flutter/material.dart';

import 'progress_ring.dart';

class ProgressRingPreview extends StatefulWidget {
  const ProgressRingPreview({super.key});

  @override
  State<ProgressRingPreview> createState() => _ProgressRingPreviewState();
}

class _ProgressRingPreviewState extends State<ProgressRingPreview> {
  double _percentage = 0.0;
  final int _goalMl = 2500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress Ring Preview')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProgressRing(
              percentage: _percentage,
              totalMl: (_percentage * _goalMl).round(),
              goalMl: _goalMl,
              unit: 'ml',
            ),
            const SizedBox(height: 32),
            Text(
              'Drag to test: ${(_percentage * 100).round()}%',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            Slider(
              min: 0.0,
              max: 1.3,
              value: _percentage,
              divisions: 26,
              onChanged: (value) => setState(() => _percentage = value),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => setState(() => _percentage = 0.0),
                  child: const Text('0%'),
                ),
                OutlinedButton(
                  onPressed: () => setState(() => _percentage = 0.25),
                  child: const Text('25%'),
                ),
                OutlinedButton(
                  onPressed: () => setState(() => _percentage = 0.5),
                  child: const Text('50%'),
                ),
                OutlinedButton(
                  onPressed: () => setState(() => _percentage = 0.75),
                  child: const Text('75%'),
                ),
                OutlinedButton(
                  onPressed: () => setState(() => _percentage = 1.0),
                  child: const Text('100%'),
                ),
                OutlinedButton(
                  onPressed: () => setState(() => _percentage = 1.1),
                  child: const Text('110%'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
