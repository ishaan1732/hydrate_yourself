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
  static const _mlPresets = [150, 250, 330, 500];
  static const _ozPresetData = [
    (237, '8 oz'),
    (355, '12 oz'),
    (473, '16 oz'),
    (591, '20 oz'),
  ];

  late int _selectedPreset;
  late int _customMl;

  @override
  void initState() {
    super.initState();
    _customMl = widget.currentSizeMl;
    if (widget.unit == 'oz') {
      _selectedPreset =
          _ozPresetData.any((e) => e.$1 == widget.currentSizeMl)
              ? widget.currentSizeMl
              : -1;
    } else {
      _selectedPreset =
          _mlPresets.contains(widget.currentSizeMl) ? widget.currentSizeMl : -1;
    }
  }

  double _mlToOzDouble(int ml) => ml * 0.033814;

  String _mlToDisplayOz(int ml) {
    final oz = ml * 0.033814;
    final rounded = (oz * 2).round() / 2.0;
    if (rounded % 1 == 0) return rounded.toInt().toString();
    return rounded.toStringAsFixed(1);
  }

  int _ozToMl(double oz) => (oz / 0.033814).round();

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

          // Preset buttons
          if (widget.unit == 'oz')
            Row(
              children: [
                for (final (ml, label) in _ozPresetData) ...[
                  if (ml != _ozPresetData.first.$1) const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _customMl = ml;
                        _selectedPreset = ml;
                      }),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: _selectedPreset == ml
                              ? colorScheme.primary.withValues(alpha: 0.2)
                              : colorScheme.surfaceContainerHighest,
                          border: Border.all(
                            color: _selectedPreset == ml
                                ? colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              label,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: _selectedPreset == ml
                                    ? colorScheme.primary
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            )
          else
            Row(
              children: _mlPresets
                  .map((ml) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _buildPresetButton(context, ml),
                        ),
                      ))
                  .toList(),
            ),

          const SizedBox(height: 20),

          // Custom amount section
          if (widget.unit == 'oz') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Custom amount',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                Text(
                  '${_mlToDisplayOz(_customMl)} oz',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              min: 2.0,
              max: 40.0,
              divisions: 76,
              value: _mlToOzDouble(_customMl).clamp(2.0, 40.0),
              label: '${_mlToDisplayOz(_customMl)} oz',
              onChanged: (val) {
                final roundedOz = (val * 2).round() / 2.0;
                setState(() {
                  _customMl = _ozToMl(roundedOz);
                  _selectedPreset = -1;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('2 oz',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant)),
                Text('20 oz',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant)),
                Text('40 oz',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant)),
              ],
            ),
          ] else ...[
            Text(
              'Custom',
              style: theme.textTheme.labelLarge
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 10),
            Slider(
              min: 50,
              max: 1000,
              divisions: 19,
              value: _customMl.toDouble().clamp(50, 1000),
              onChanged: (v) => setState(() {
                _customMl = v.round();
                _selectedPreset = -1;
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_customMl ml selected',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ],

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
              child: Text(
                widget.unit == 'oz'
                    ? 'Set Cup Size — ${_mlToDisplayOz(_customMl)} oz'
                    : 'Set Cup Size — $_customMl ml',
              ),
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
              ml.toString(),
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
