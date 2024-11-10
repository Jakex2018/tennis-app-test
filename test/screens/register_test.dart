import 'package:com.tennis.arshh/modules/auth/register/widget/form_register.dart';
import 'package:com.tennis.arshh/modules/auth/register/widget/register_footer.dart';
import 'package:com.tennis.arshh/modules/auth/register/widget/register_header.dart';
import 'package:com.tennis.arshh/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'RegisterScreen renders RegisterHeader, FormRegister, and RegisterFooter',
      (WidgetTester tester) async {
   
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterScreen(),
      ),
    );

    expect(find.byType(RegisterHeader), findsOneWidget);

    expect(find.byType(FormRegister), findsOneWidget);

    expect(find.byType(RegisterFooter), findsOneWidget);

    expect(find.byType(SingleChildScrollView), findsOneWidget);

    final size = tester.getSize(find.byType(SingleChildScrollView));
    expect(size.height, greaterThan(0));
    expect(size.width, greaterThan(0));
  });

  testWidgets('RegisterScreen scrolls when keyboard is shown',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterScreen(),
      ),
    );

    await tester.tap(find.byType(TextFormField).first);
    await tester.pumpAndSettle();

    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
