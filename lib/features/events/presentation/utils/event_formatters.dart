import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

String formatEventPrecio(double value) {
  final String integerPart = value.round().toString();
  final StringBuffer buffer = StringBuffer();
  for (int i = 0; i < integerPart.length; i++) {
    if (i > 0 && (integerPart.length - i) % 3 == 0) buffer.write('.');
    buffer.write(integerPart[i]);
  }
  return '\$$buffer';
}

String formatEventFecha(DateTime fecha) =>
    '${fecha.day.toString().padLeft(2, '0')}/'
    '${fecha.month.toString().padLeft(2, '0')}/'
    '${fecha.year}';

Color eventCuposColor(
  BuildContext context,
  int cuposDisponibles,
  int capacidad,
) {
  final double ratio = capacidad == 0 ? 0 : cuposDisponibles / capacidad;
  if (cuposDisponibles == 0) return Theme.of(context).colorScheme.error;
  final AppSemanticColors semanticColors = context.appSemanticColors;
  return ratio > 0.2 ? semanticColors.success : semanticColors.warning;
}
