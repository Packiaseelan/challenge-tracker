String dateToString(DateTime date) {
  if (date == null) return DateTime.now().toIso8601String();
  return date.toIso8601String();
}

DateTime stringToDate(String date) {
  if (date.isEmpty) return DateTime.now();
  return DateTime.parse(date);
}

String dts(DateTime date) {
  if (date == null) return DateTime.now().toIso8601String();
  return '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
