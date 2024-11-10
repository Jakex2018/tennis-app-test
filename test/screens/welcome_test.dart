import 'package:com.tennis.arshh/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:com.tennis.arshh/modules/welcome/widget/background_image.dart'; // Ruta correcta
import 'package:com.tennis.arshh/modules/welcome/widget/welcome_content.dart'; // Ruta correcta

void main() {
  testWidgets('WelcomeScreen displays BackgroundImage and WelcomeContent',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomeScreen(),
      ),
    );

    expect(find.byType(BackgroundImage), findsOneWidget);
    expect(find.byType(WelcomeContent), findsOneWidget);

    expect(
      tester.getSize(find.byType(WelcomeScreen)),
      Size(
        tester.getSize(find.byType(WelcomeScreen)).width,
        tester.getSize(find.byType(WelcomeScreen)).height,
      ),
    );
  });
}
