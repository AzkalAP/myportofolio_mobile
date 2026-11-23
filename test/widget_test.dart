import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

void main() {
  testWidgets('shows the portfolio owner information and actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: MyHomePage()));

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
    await tester.pumpWidget(MaterialApp(home: MyHomePage()));

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

  for (final actionName in ['View Projects', 'Logout']) {
    testWidgets('shows feedback when $actionName is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: MyHomePage()));

      await tester.ensureVisible(find.text(actionName));
      await tester.tap(find.text(actionName));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('You pressed the $actionName button!'), findsOneWidget);
    });
  }

  testWidgets('Add Project opens the project form and shows feedback', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: MyHomePage()));

    await tester.tap(find.text('Add Project'));
    await tester.pump();
    expect(find.text('You pressed the Add Project button!'), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(find.text('Add Project Form'), findsOneWidget);
  });

  testWidgets('the form shows its default category and required errors', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));

    final categoryField = tester.widget<DropdownButtonFormField<String>>(
      find.byType(DropdownButtonFormField<String>),
    );
    expect(categoryField.initialValue, 'Web Development');

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a project name.'), findsOneWidget);
    expect(find.text('Enter a project description.'), findsOneWidget);
  });

  testWidgets('valid form values appear in the dialog and reset after OK', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Portfolio Mobile');
    await tester.enterText(fields.at(1), 'A Flutter portfolio app');
    await tester.enterText(fields.at(2), 'Flutter, Dart');
    await tester.enterText(fields.at(3), 'https://example.com');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Project Name: Portfolio Mobile'), findsOneWidget);
    expect(find.text('Description: A Flutter portfolio app'), findsOneWidget);
    expect(find.text('Category: Web Development'), findsOneWidget);
    expect(find.text('Technologies: Flutter, Dart'), findsOneWidget);
    expect(find.text('Link: https://example.com'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('Project Name: Portfolio Mobile'), findsNothing);
    expect(find.text('A Flutter portfolio app'), findsNothing);
  });

  testWidgets('the drawer opens the project form and returns home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: MyHomePage()));

    await tester.dragFrom(const Offset(1, 300), const Offset(300, 0));
    await tester.pumpAndSettle();
    expect(
      find.text('Explore personal projects and experiences!'),
      findsOneWidget,
    );

    final addProjectEntry = find.descendant(
      of: find.byType(Drawer),
      matching: find.text('Add Project'),
    );
    await tester.tap(addProjectEntry);
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);

    await tester.dragFrom(const Offset(1, 300), const Offset(300, 0));
    await tester.pumpAndSettle();
    final homeEntry = find.descendant(
      of: find.byType(Drawer),
      matching: find.text('Home'),
    );
    await tester.tap(homeEntry);
    await tester.pumpAndSettle();
    expect(find.text('Welcome to MyPortfolio Mobile!'), findsOneWidget);
  });
}
