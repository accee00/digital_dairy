///
enum ShiftType {
  ///
  morning,

  ///
  evening,
}

extension ShiftTypeValue on ShiftType {
  String get value {
    switch (this) {
      case ShiftType.morning:
        return 'Morning';
      case ShiftType.evening:
        return 'Evening';
    }
  }

  /// Converts a string [value] to its corresponding [ShiftType].
  ///
  /// This function takes a string input [value] and returns the matching [ShiftType].
  /// It supports 'Morning' and 'Evening' as valid inputs.
  ///
  /// Throws [ArgumentError] if the input [value] does not correspond to any [ShiftType].
  ///
  /// Example:
  /// ```dart
  /// ShiftType type = ShiftType.from('Morning'); // Returns ShiftType.morning
  /// ```
  ///
  /// [value] - The shift type as a string.
  /// Returns the corresponding [ShiftType] if valid, otherwise throws an exception.
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
}
