/// Calculates the age from a date of birth and returns a formatted string.
///
/// Returns 'Unknown' if [dob] is null. Otherwise returns a string like
/// '2 y 3 mo' for years and months, or just years/months if one is zero.
String calculateAge(DateTime? dob) {
  if (dob == null) {
    return 'Unknown';
  }

  final DateTime now = DateTime.now();
  int years = now.year - dob.year;
  int months = now.month - dob.month;

  if (months < 0) {
    years -= 1;
    months += 12;
  }

  if (years == 0) {
    return '$months mo';
  }
  if (months == 0) {
    return '$years y';
  }
  return '$years y $months mo';
}
