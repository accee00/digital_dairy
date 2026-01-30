/// Represents the shift type for milk collection (morning or evening).
enum ShiftType {
  /// Morning shift.
  morning,

  /// Evening shift.
  evening;

  /// Creates a [ShiftType] from a string value.
  ///
  /// Throws [ArgumentError] if the value is not 'Morning' or 'Evening'.
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

  /// Returns the string representation of this shift type.
  String get value {
    switch (this) {
      case ShiftType.morning:
        return 'Morning';
      case ShiftType.evening:
        return 'Evening';
    }
  }

  /// Returns the display value for UI purposes.
  String get displayVal {
    switch (this) {
      case ShiftType.morning:
        return 'Morning';
      case ShiftType.evening:
        return 'Evening';
    }
  }
}
