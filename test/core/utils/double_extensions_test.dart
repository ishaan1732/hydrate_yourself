import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_yourself/core/extensions/double_extensions.dart';

void main() {
  group('HydrationExtensions', () {
    test('500 ml to oz is close to 16.9', () {
      expect(500.0.mlToOz, closeTo(16.9, 0.1));
    });

    test('16.9 oz to ml is close to 499.7', () {
      expect(16.9.ozToMl, closeTo(499.7, 0.1));
    });

    test('500 ml formatted as ml → "500ml"', () {
      expect(500.0.toHydrationString('ml'), equals('500ml'));
    });

    test('1200 ml formatted as ml → "1.2L"', () {
      expect(1200.0.toHydrationString('ml'), equals('1.2L'));
    });

    test('500 ml formatted as oz → "16.9oz"', () {
      expect(500.0.toHydrationString('oz'), equals('16.9oz'));
    });
  });
}
