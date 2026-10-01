import 'package:flutter/material.dart';

// Hora local del dispositivo y su ajuste 12/24 h, no un patrón fijo.
abstract final class TimeFormatter {
  static String format(BuildContext context, DateTime value) => MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay.fromDateTime(value.toLocal()),
    alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
  );
}
