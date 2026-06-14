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
  // (storedMl, displayOz)
  static const _ozPresets = [(120, 4), (240, 8), (355, 12), (475, 16)];

  late int _selectedPreset;
  late int _customMl;

  @override
  void initState() {
    super.initState();
    _customMl = widget.currentSizeMl;
    if (widget.unit == 'oz') {
      _selectedPreset = _ozPresets.any((e) => e.$1 == widget.currentSizeMl)
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

  int _ozToMl(double oz) {
    final rawMl = oz / 0.033814;
    return ((rawMl / 5).round() * 5);
  }

  String _emojiForMl(int ml) {
    if (ml <= 160) return '🍵';
    if (ml <= 270) return '☕';
    if (ml <= 400) return '🥤';
    if (ml <= 560) return '🍶';
    return '🧴';
  }

  String _emojiForOz(int oz) {
    if (oz <= 5) return '🍵';
    if (oz <= 9) return '☕';
    if (oz <= 13) return '🥤';
    return '🍶';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Cup Size',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Preset buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: widget.unit == 'oz'
                    ? [
                        for (int i = 0; i < _ozPresets.length; i++) ...[
                          if (i > 0) const SizedBox(width: 10),
                          _buildPresetTile(
                            context,
                            mlValue: _ozPresets[i].$1,
                            displayAmount: '${_ozPresets[i].$2} oz',
                            emoji: _emojiForOz(_ozPresets[i].$2),
                          ),
                        ],
                      ]
                    : [
                        for (int i = 0; i < _mlPresets.length; i++) ...[
                          if (i > 0) const SizedBox(width: 10),
                          _buildPresetTile(
                            context,
                            mlValue: _mlPresets[i],
                            displayAmount: '${_mlPresets[i]} ml',
                            emoji: _emojiForMl(_mlPresets[i]),
                          ),
                        ],
                      ],
              ),
            ),

            const SizedBox(height: 20),

            // Custom amount section
            if (widget.unit == 'oz') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Custom amount',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: theme.textTheme.labelLarge
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                  Text(
                    '${_mlToDisplayOz(_customMl)} oz',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Custom',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
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
                  Flexible(
                    child: Text(
                      '$_customMl ml selected',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
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
      ),
    );
  }

  Widget _buildPresetTile(
    BuildContext context, {
    required int mlValue,
    required String displayAmount,
    required String emoji,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedPreset == mlValue;

    return GestureDetector(
      onTap: () => setState(() {
        _selectedPreset = mlValue;
        _customMl = mlValue;
      }),
      child: Container(
        width: 72,
        height: 72,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.2)
              : colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 2),
                Text(
                  displayAmount,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
