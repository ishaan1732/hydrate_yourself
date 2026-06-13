import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/mascot_type.dart';
import '../settings_provider.dart';

part 'mascot_provider.g.dart';

@riverpod
class SelectedMascot extends _$SelectedMascot {
  static const _key = 'selected_mascot';

  @override
  MascotType build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_key);
    return MascotType.values.firstWhere(
      (m) => m.name == stored,
      orElse: () => MascotType.classic,
    );
  }

  Future<void> setMascot(MascotType mascot) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, mascot.name);
    state = mascot;
  }
}
