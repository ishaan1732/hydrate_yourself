import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCustomDrinkSheet extends StatefulWidget {
  const AddCustomDrinkSheet({super.key, required this.onAdd});

  final Future<void> Function(
      String name, String emoji, double coefficient, String colorHex) onAdd;

  @override
  State<AddCustomDrinkSheet> createState() => _AddCustomDrinkSheetState();
}

class _AddCustomDrinkSheetState extends State<AddCustomDrinkSheet> {
  String _selectedEmoji = '🥤';
  static const _noIcon = '';
  late final TextEditingController _nameController;
  double _coefficient = 0.8;
  bool _saving = false;

  static const _palette = [
    '#E53935', '#8E24AA', '#3949AB', '#00897B',
    '#F4511E', '#F9A825', '#AD1457', '#2E7D32',
  ];
  String _selectedColor = '#E53935';

  static const _emojis = [
    '🥤', '🧃', '🧋', '🍵', '☕', '🫖', '🧉', '🥛', '🍺', '🍹',
    '🍶', '🫗', '🥂', '🍷', '🌊', '❄️',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hex) {
    final buffer = StringBuffer()..write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
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
                      'Add Custom Drink',
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
            const SizedBox(height: 16),

            // ── Color picker ─────────────────────────────────────────────────
            Text('Color',
                style: theme.textTheme.labelLarge
                    ?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _palette.map((hex) {
                  final isSelected = _selectedColor == hex;
                  final color = _hexToColor(hex);
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedColor = hex),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: isSelected ? 36 : 32,
                        height: isSelected ? 36 : 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check,
                                size: 16, color: Colors.white)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // ── Emoji picker ─────────────────────────────────────────────────
            Text('Choose emoji',
                style: theme.textTheme.labelLarge
                    ?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // "No icon" option pinned at top
                GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = _noIcon),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _selectedEmoji == _noIcon
                          ? colorScheme.primary.withValues(alpha: 0.2)
                          : colorScheme.surfaceContainerHighest,
                      border: Border.all(
                        color: _selectedEmoji == _noIcon
                            ? colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(Icons.block_rounded,
                        size: 20, color: colorScheme.onSurfaceVariant),
                  ),
                ),
                ..._emojis.map((emoji) {
                  final isSelected = _selectedEmoji == emoji;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedEmoji = emoji),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? colorScheme.primary.withValues(alpha: 0.2)
                            : colorScheme.surfaceContainerHighest,
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child:
                            Text(emoji, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

            // ── Name field ───────────────────────────────────────────────────
            TextField(
              controller: _nameController,
              maxLength: 30,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: InputDecoration(
                labelText: 'Drink name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixText:
                    _selectedEmoji.isEmpty ? null : '$_selectedEmoji  ',
              ),
            ),
            const SizedBox(height: 16),

            // ── Hydration coefficient ────────────────────────────────────────
            Text('Hydration coefficient',
                style: theme.textTheme.labelLarge
                    ?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text(
              'How much this drink counts toward hydration (1.0 = same as water)',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    value: _coefficient,
                    onChanged: (v) => setState(() => _coefficient = v),
                  ),
                ),
                SizedBox(
                  width: 36,
                  child: Text(
                    _coefficient.toStringAsFixed(1),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0.1\nMinimal',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant)),
                Text('0.5\nMedium',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant)),
                Text('1.0\nFull',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saving
                    ? null
                    : () async {
                        final name = _nameController.text.trim();
                        if (name.isEmpty) return;
                        setState(() => _saving = true);
                        final nav = Navigator.of(context);
                        await widget.onAdd(
                            name, _selectedEmoji, _coefficient, _selectedColor);
                        if (mounted) nav.pop();
                      },
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Add Drink'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
