import 'package:eventix/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeContextX', () {
    testWidgets(
      'given a light theme when isDark is read then it is false',
      (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(capturedContext.isDark, isFalse);
        expect(capturedContext.theme, isA<ThemeData>());
        expect(capturedContext.textTheme, isA<TextTheme>());
        expect(capturedContext.colorScheme, isA<ColorScheme>());
      },
    );

    testWidgets(
      'given a dark theme when isDark is read then it is true',
      (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(capturedContext.isDark, isTrue);
      },
    );
  });
}
