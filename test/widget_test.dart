import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('shows the portfolio owner information and actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp(MyHomePage()));

    expect(find.byType(InfoCard), findsNWidgets(3));
    expect(find.text('2506636991'), findsOneWidget);
    expect(find.text('Azkal Azkiya Arifi Putra'), findsOneWidget);
    expect(find.text('PBP KEIKEIAI (KKI)'), findsOneWidget);
    expect(find.text('View Projects'), findsOneWidget);
    expect(find.text('Add Project'), findsOneWidget);
    expect(find.text('Add Experience'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('renders a distinct color for each action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp(MyHomePage()));

    final actionCards = find.byType(ItemCard);
    const expectedColors = [Colors.blue, Colors.green, Colors.teal, Colors.red];

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

  testWidgets('authenticated Add Project opens the project form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp(MyHomePage(), initialToken: 'test-token'));

    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(find.text('Add Project'), findsOneWidget);
  });

  testWidgets('project form validates required and URL fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      testApp(const ProjectFormPage(), initialToken: 'test-token'),
    );

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a title.'), findsOneWidget);
    expect(find.text('Enter a project description.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('project-title')),
      'Portfolio Mobile',
    );
    await tester.enterText(
      find.byKey(const ValueKey('project-description')),
      'A Flutter portfolio app',
    );
    await tester.enterText(
      find.byKey(const ValueKey('project-url')),
      'ftp://example.com',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid HTTP(S) URL.'), findsOneWidget);
  });
}
