import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

class EventixLogo extends StatelessWidget {
  const EventixLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    final Color primary = context.colorScheme.primary;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: primary,
        borderRadius: AppRadius.lgBorderRadius,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: primary.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        'E',
        style: AppTypography.headlineLarge.copyWith(
          color: context.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
