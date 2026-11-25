import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('rejects empty and whitespace-only required fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp(const ExperienceFormPage()));

    await tester.enterText(
      find.byKey(const ValueKey('experience-title')),
      '  \t',
    );
    await tester.enterText(
      find.byKey(const ValueKey('experience-organization')),
      ' ',
    );
    await tester.enterText(
      find.byKey(const ValueKey('experience-description')),
      '\n  ',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a title.'), findsOneWidget);
    expect(find.text('Enter an organization.'), findsOneWidget);
    expect(find.text('Enter a description.'), findsOneWidget);
    expect(find.text('Select a start date.'), findsOneWidget);
  });

  testWidgets('rejects an end date earlier than the start date', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp(const ExperienceFormPage()));
    await _enterRequiredText(tester);
    await _selectDate(tester, 'experience-start-date', '20');
    await _selectDate(tester, 'experience-end-date', '19');

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(
      find.text('End date must be on or after start date.'),
      findsOneWidget,
    );
  });

  testWidgets('rejects a URL without a valid HTTP(S) scheme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp(const ExperienceFormPage()));
    await _enterRequiredText(tester);
    await _selectDate(tester, 'experience-start-date', '15');
    await tester.enterText(
      find.byKey(const ValueKey('experience-url')),
      'ftp://example.com',
    );

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid HTTP(S) URL.'), findsOneWidget);
  });

  testWidgets('shows entered values and closes back to the form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp(const ExperienceFormPage()));
    await _enterRequiredText(tester);
    await _selectDate(tester, 'experience-start-date', '15');
    await tester.enterText(
      find.byKey(const ValueKey('experience-url')),
      'https://example.com/experience',
    );

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Title: Software Engineer'), findsOneWidget);
    expect(find.text('Organization: Example Studio'), findsOneWidget);
    expect(
      find.text('Description: Built portfolio applications.'),
      findsOneWidget,
    );
    expect(find.textContaining('Start Date: 20'), findsOneWidget);
    expect(find.text('End Date: Not provided'), findsOneWidget);
    expect(find.text('URL: https://example.com/experience'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    expect(find.byType(ExperienceFormPage), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
  });

  testWidgets('allows an omitted optional URL', (WidgetTester tester) async {
    await tester.pumpWidget(testApp(const ExperienceFormPage()));
    await _enterRequiredText(tester);
    await _selectDate(tester, 'experience-start-date', '15');

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('URL: Not provided'), findsOneWidget);
  });
}

Future<void> _enterRequiredText(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const ValueKey('experience-title')),
    'Software Engineer',
  );
  await tester.enterText(
    find.byKey(const ValueKey('experience-organization')),
    'Example Studio',
  );
  await tester.enterText(
    find.byKey(const ValueKey('experience-description')),
    'Built portfolio applications.',
  );
}

Future<void> _selectDate(
  WidgetTester tester,
  String fieldKey,
  String day,
) async {
  await tester.tap(find.byKey(ValueKey(fieldKey)));
  await tester.pumpAndSettle();
  await tester.tap(find.text(day));
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}
