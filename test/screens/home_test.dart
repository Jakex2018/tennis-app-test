import 'package:com.tennis.arshh/modules/home/widget/app_bar_content.dart';
import 'package:com.tennis.arshh/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:com.tennis.arshh/modules/home/widget/body_page.dart';
import 'package:com.tennis.arshh/modules/home/widget/bottom_nav_bar_shadow.dart';

void main() {
  testWidgets(
      'HomeScreen renders AppbarContent, BodyPage, and BottomNavBarShadow',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    expect(find.byType(AppbarContent), findsOneWidget);

    expect(find.byType(BodyPage), findsOneWidget);

    expect(find.byType(BottomNavBarShadow), findsOneWidget);

    expect(find.byType(DefaultTabController), findsOneWidget);

    final tabController =
        tester.widget<DefaultTabController>(find.byType(DefaultTabController));
    expect(tabController.length, 3);
  });

  testWidgets('HomeScreen switches tabs correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    expect(find.byType(Tab), findsNWidgets(3));
    expect(find.byType(TabBar), findsOneWidget);

    await tester.tap(find.text('Tab 2'));
    await tester.pumpAndSettle();

    expect(find.text('Second Tab'), findsOneWidget);

    await tester.tap(find.text('Tab 1'));
    await tester.pumpAndSettle();

    expect(find.text('First Tab'), findsOneWidget);
  });
}
