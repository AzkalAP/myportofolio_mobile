import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

void main() {
  testWidgets('home action opens Experience and system back returns home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: MyHomePage()));

    await tester.tap(find.text('Add Experience'));
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceFormPage), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(ExperienceFormPage), findsNothing);
    expect(find.text('Welcome to MyPortfolio Mobile!'), findsOneWidget);
  });

  testWidgets('drawer Add Experience opens the Experience form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: MyHomePage()));
    await _openDrawer(tester);

    final addExperienceEntry = find.descendant(
      of: find.byType(Drawer),
      matching: find.text('Add Experience'),
    );
    await tester.tap(addExperienceEntry);
    await tester.pumpAndSettle();

    expect(find.byType(ExperienceFormPage), findsOneWidget);
    expect(find.text('Add Experience'), findsOneWidget);
  });

  testWidgets('Home from the Experience drawer returns to the dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: MyHomePage()));
    await tester.tap(find.text('Add Experience'));
    await tester.pumpAndSettle();
    await _openDrawer(tester);

    final homeEntry = find.descendant(
      of: find.byType(Drawer),
      matching: find.text('Home'),
    );
    await tester.tap(homeEntry);
    await tester.pumpAndSettle();

    expect(find.byType(ExperienceFormPage), findsNothing);
    expect(find.text('Welcome to MyPortfolio Mobile!'), findsOneWidget);
  });
}

Future<void> _openDrawer(WidgetTester tester) async {
  await tester.dragFrom(const Offset(1, 300), const Offset(300, 0));
  await tester.pumpAndSettle();
}
