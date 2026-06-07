import 'package:flutter/material.dart';

class CupSizeSheet extends StatefulWidget {
  const CupSizeSheet({
    super.key,
    required this.currentSizeMl,
    required this.unit,
    required this.onSizeSelected,
  });

  final int currentSizeMl;
  final String unit;
  final void Function(int sizeMl) onSizeSelected;

  @override
  State<CupSizeSheet> createState() => _CupSizeSheetState();
}

class _CupSizeSheetState extends State<CupSizeSheet> {
  static const _presets = [150, 250, 330, 500];
  static const _ozSteps = [4, 6, 8, 10, 12, 16, 20, 24, 32];
  static const _mlSteps = [118, 177, 237, 296, 355, 473, 591, 710, 946];

  late int _selectedPreset;
  late int _customMl;

  @override
  void initState() {
    super.initState();
    _customMl = widget.currentSizeMl;
    _selectedPreset =
        _presets.contains(widget.currentSizeMl) ? widget.currentSizeMl : -1;
  }

  String _mlToNaturalOz(int ml) {
    int closestIdx = 0;
    int minDiff = (_mlSteps[0] - ml).abs();
    for (int i = 1; i < _mlSteps.length; i++) {
      final diff = (_mlSteps[i] - ml).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closestIdx = i;
      }
    }
    if (minDiff < 30) return _ozSteps[closestIdx].toString();
    return (ml * 0.0338).toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Cup Size',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: _presets
                .map((ml) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _buildPresetButton(context, ml),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          Text('Custom',
              style: theme.textTheme.labelLarge
                  ?.copyWith(color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: 10),
          if (widget.unit == 'ml')
            Slider(
              min: 50,
              max: 1000,
              divisions: 19,
              value: _customMl.toDouble().clamp(50, 1000),
              onChanged: (v) => setState(() {
                _customMl = v.round();
                _selectedPreset = -1;
              }),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_ozSteps.length, (i) {
                  final isSelected = _customMl == _mlSteps[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _customMl = _mlSteps[i];
                        _selectedPreset = -1;
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary.withValues(alpha: 0.2)
                              : colorScheme.surfaceContainerHighest,
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_ozSteps[i]} oz',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.unit == 'oz'
                    ? '${_mlToNaturalOz(_customMl)} oz selected'
                    : '$_customMl ml selected',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                widget.onSizeSelected(_customMl);
                Navigator.pop(context);
              },
              child: const Text('Set Cup Size'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButton(BuildContext context, int ml) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedPreset == ml;

    return GestureDetector(
      onTap: () => setState(() {
        _selectedPreset = ml;
        _customMl = ml;
      }),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.2)
              : colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.unit == 'oz' ? _mlToNaturalOz(ml) : ml.toString(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
            Text(
              widget.unit,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
