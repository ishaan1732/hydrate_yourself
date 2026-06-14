import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BatteryOptimizationHelper {
  static const _shownKey = 'battery_opt_dialog_shown';
  static const _channel =
      MethodChannel('com.ishaansharma.hydrate_yourself/device_info');

  // OEMs with aggressive battery killers
  static const _aggressiveOems = [
    'oneplus', 'xiaomi', 'redmi', 'oppo', 'vivo',
    'huawei', 'honor', 'realme', 'asus',
  ];

  static Future<bool> shouldShowDialog() async {
    if (!Platform.isAndroid) return false;

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_shownKey) ?? false) return false;

    try {
      final manufacturer =
          await _channel.invokeMethod<String>('getManufacturer') ?? '';
      return _aggressiveOems
          .any((oem) => manufacturer.toLowerCase().contains(oem));
    } catch (_) {
      return false;
    }
  }

  static Future<void> markShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_shownKey, true);
  }

  static void showSetupDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text('Enable reliable notifications'),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your phone's battery settings may delay "
                  'or block Hydrate Yourself reminders.',
                ),
                const SizedBox(height: 12),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'To fix this:',
                    style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('1. Open phone Settings'),
                const Text('2. Go to Battery → Battery Optimization'),
                const Text('3. Find Hydrate Yourself'),
                const Text("4. Select \"Don't optimize\""),
                const SizedBox(height: 12),
                const Text(
                  'This ensures you get reminders exactly when scheduled.',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              markShown();
              Navigator.of(ctx).pop();
            },
            child: const Text('Maybe later'),
          ),
          FilledButton(
            onPressed: () async {
              markShown();
              Navigator.of(ctx).pop();
              try {
                await _channel.invokeMethod('openBatterySettings');
              } catch (_) {}
            },
            child: const Text('Open settings'),
          ),
        ],
      ),
    );
  }
}
