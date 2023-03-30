class DateTimeUtils {
  static const DateTimeUtils i = DateTimeUtils._();

  const DateTimeUtils._();

  String format(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-$day';
  }
}
