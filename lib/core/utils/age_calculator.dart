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
