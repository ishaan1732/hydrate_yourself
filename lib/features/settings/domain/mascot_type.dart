enum MascotType {
  relaxed,
  winter,
  summer,
  sports,
}

extension MascotTypeExtension on MascotType {
  String get assetPath {
    switch (this) {
      case MascotType.relaxed:
        return 'assets/images/jumbo_relaxed.png';
      case MascotType.winter:
        return 'assets/images/jumbo_winter.png';
      case MascotType.summer:
        return 'assets/images/jumbo_summer.png';
      case MascotType.sports:
        return 'assets/images/jumbo_sports.png';
    }
  }

  String get label {
    switch (this) {
      case MascotType.relaxed:
        return 'Comfy';
      case MascotType.winter:
        return 'Winter';
      case MascotType.summer:
        return 'Summer';
      case MascotType.sports:
        return 'Sports';
    }
  }
}
