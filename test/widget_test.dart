import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/menu.dart';

void main() {
  testWidgets('shows the portfolio owner information and actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: MyHomePage()));

    expect(find.byType(InfoCard), findsNWidgets(3));
    expect(find.text('2506636991'), findsOneWidget);
    expect(find.text('Azkal Azkiya Arifi Putra'), findsOneWidget);
    expect(find.text('PBP KKI'), findsOneWidget);
    expect(find.text('View Projects'), findsOneWidget);
    expect(find.text('Add Project'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('renders a distinct color for each action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: MyHomePage()));

    final actionCards = find.byType(ItemCard);
    const expectedColors = [Colors.blue, Colors.green, Colors.red];

    expect(actionCards, findsNWidgets(expectedColors.length));
    for (var index = 0; index < expectedColors.length; index++) {
      final materialFinder = find
          .descendant(
            of: actionCards.at(index),
            matching: find.byType(Material),
          )
          .first;
      expect(
        tester.widget<Material>(materialFinder).color,
        expectedColors[index],
      );
    }
  });

  for (final actionName in ['View Projects', 'Add Project', 'Logout']) {
    testWidgets('shows feedback when $actionName is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: MyHomePage()));

      await tester.tap(find.text(actionName));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('You pressed the $actionName button!'), findsOneWidget);
    });
  }
}
