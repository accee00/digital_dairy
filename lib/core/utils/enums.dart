enum ShiftType {
  morning,
  evening;

  static ShiftType from(String value) {
    switch (value) {
      case 'Morning':
        return ShiftType.morning;
      case 'Evening':
        return ShiftType.evening;
      default:
        throw ArgumentError('Invalid shift type: $value');
    }
  }

  String get value {
    switch (this) {
      case ShiftType.morning:
        return 'Morning';
      case ShiftType.evening:
        return 'Evening';
    }
  }

  String get displayVal {
    switch (this) {
      case ShiftType.morning:
        return 'Morning';
      case ShiftType.evening:
        return 'Evening';
    }
  }
}
