import 'package:flutter/material.dart';

class AddCustomDrinkSheet extends StatefulWidget {
  const AddCustomDrinkSheet({super.key, required this.onAdd});

  final void Function(String name, String emoji, double coefficient) onAdd;

  @override
  State<AddCustomDrinkSheet> createState() => _AddCustomDrinkSheetState();
}

class _AddCustomDrinkSheetState extends State<AddCustomDrinkSheet> {
  String _selectedEmoji = '🥤';
  late final TextEditingController _nameController;
  double _coefficient = 0.8;

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
              Text(
                'Add Custom Drink',
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
          const SizedBox(height: 16),
          Text('Choose emoji',
              style: theme.textTheme.labelLarge
                  ?.copyWith(color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _emojis.map((emoji) {
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
                    child: Text(emoji, style: const TextStyle(fontSize: 22)),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Drink name',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              prefixText: '$_selectedEmoji  ',
            ),
          ),
          const SizedBox(height: 16),
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
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isEmpty) return;
                widget.onAdd(name, _selectedEmoji, _coefficient);
                Navigator.pop(context);
              },
              child: const Text('Add Drink'),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
