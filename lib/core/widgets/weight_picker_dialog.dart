import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../extensions/double_extensions.dart';

Future<(double, String)?> showWeightPickerDialog({
  required BuildContext context,
  required double? currentWeightKg,
  required String currentUnit,
}) {
  bool isKg = currentUnit == AppConstants.unitKg;

  int minVal() => isKg ? 30 : 66;
  int maxVal() => isKg ? 250 : 550;

  int displayVal = currentWeightKg == null
      ? (isKg ? 70 : 154)
      : isKg
          ? currentWeightKg.round()
          : currentWeightKg.kgToLbs.round();

  displayVal = displayVal.clamp(minVal(), maxVal());

  final scrollController = FixedExtentScrollController(
    initialItem: displayVal - minVal(),
  );

  return showDialog<(double, String)?>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) {
        final colorScheme = Theme.of(ctx).colorScheme;

        void switchUnit(bool toKg) {
          setDialogState(() {
            if (toKg && !isKg) {
              displayVal =
                  displayVal.toDouble().lbsToKg.round().clamp(30, 250);
              isKg = true;
            } else if (!toKg && isKg) {
              displayVal =
                  displayVal.toDouble().kgToLbs.round().clamp(66, 550);
              isKg = false;
            }
          });
          scrollController.jumpToItem(displayVal - minVal());
        }

        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          title: const FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text('Your weight'),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _unitChip(
                          label: 'kg',
                          selected: isKg,
                          colorScheme: colorScheme,
                          onTap: () => switchUnit(true),
                        ),
                        _unitChip(
                          label: 'lbs',
                          selected: !isKg,
                          colorScheme: colorScheme,
                          onTap: () => switchUnit(false),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$displayVal',
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.primary,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isKg ? 'kg' : 'lbs',
                        style: TextStyle(
                          fontSize: 20,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 60,
                    height: 2,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 180,
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 44,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 40),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer
                                  .withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.2),
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                        CupertinoPicker(
                          scrollController: scrollController,
                          itemExtent: 44,
                          selectionOverlay: const SizedBox.shrink(),
                          onSelectedItemChanged: (index) {
                            setDialogState(() {
                              displayVal = minVal() + index;
                            });
                          },
                          children: List.generate(
                            maxVal() - minVal() + 1,
                            (i) {
                              final val = minVal() + i;
                              final isSelected = val == displayVal;
                              return Center(
                                child: Text(
                                  '$val',
                                  style: TextStyle(
                                    fontSize: isSelected ? 20 : 17,
                                    fontWeight: isSelected
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? colorScheme.onSurface
                                        : colorScheme.onSurface
                                            .withValues(alpha: 0.4),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: IgnorePointer(
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    colorScheme.surface,
                                    colorScheme.surface.withValues(alpha: 0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: IgnorePointer(
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    colorScheme.surface,
                                    colorScheme.surface.withValues(alpha: 0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('Cancel'),
              ),
            ),
            FilledButton(
              onPressed: () {
                final weightKg =
                    isKg ? displayVal.toDouble() : displayVal.toDouble().lbsToKg;
                Navigator.pop(
                  ctx,
                  (
                    weightKg,
                    isKg ? AppConstants.unitKg : AppConstants.unitLbs
                  ),
                );
              },
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('Confirm'),
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget _unitChip({
  required String label,
  required bool selected,
  required ColorScheme colorScheme,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? colorScheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
          color: selected
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    ),
  );
}
