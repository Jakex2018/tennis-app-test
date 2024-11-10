import 'package:com.tennis.arshh/modules/auth/login/widget/form_body.dart';
import 'package:com.tennis.arshh/modules/auth/login/widget/login_header.dart';
import 'package:com.tennis.arshh/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LoginScreen renders LoginHeader and FormBody',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    expect(find.byType(LoginHeader), findsOneWidget);

    expect(find.byType(FormBody), findsOneWidget);

    expect(find.byType(SingleChildScrollView), findsOneWidget);

    final size = tester.getSize(find.byType(SingleChildScrollView));
    expect(size.height, greaterThan(0));
    expect(size.width, greaterThan(0));
  });

  testWidgets('LoginScreen scrolls when keyboard is shown',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    await tester.tap(find.byType(TextFormField).first);
    await tester.pumpAndSettle();

    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
