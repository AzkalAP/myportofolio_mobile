# MyPortfolio Mobile - Azkal Azkiya Arifi Putra
- **Name:** Azkal Azkiya Arifi Putra
- **NPM:** 2506636991
- **Class:** PBP KEIKEIAI (KKI)

## Project Description
MyPortfolio Mobile is the Flutter companion to my personal portfolio website. That's it for now :p

## Technology
- Flutter
- Dart
- Material 3
- Material UI
- Flutter widget tests

## Local Setup
1. Install the Flutter SDK and a supported target, such as an Android emulator or Chrome.

2. Open the project directory and fetch its packages:

   `flutter pub get`

3. Check available run targets:

   `flutter devices`

4. Run the app on a connected device, or launch its web version in Chrome:

   `flutter run`

   `flutter run -d chrome`

5. Run static analysis and widget tests:

   `flutter analyze`

   `flutter test`

## Project Structure

```text
lib/main.dart                         Flutter app entry point and MaterialApp theme
lib/screens/menu.dart                 Portfolio dashboard
lib/screens/project_form.dart         Tutorial 09 Add Project form
lib/screens/experience_form.dart     Assignment 8 Experience form
lib/widgets/left_drawer.dart          Shared drawer and navigation entries
lib/widgets/project_card.dart        Reusable portfolio action card
test/widget_test.dart                 Dashboard, colors, SnackBars, and project form tests
test/experience_form_test.dart        Experience form validation and summary tests
test/experience_navigation_test.dart  Experience navigation tests
android/                              Android platform runner
ios/                                  iOS platform runner
web/                                  Web app entry point and web assets
```

## Features
- Displays my NPM, name, and class in three information cards.
- Provides View Projects, Add Project, Add Experience, and Logout action cards with distinct colors.
- Shows a SnackBar identifying the action when an action card is tapped.
- Opens the Experience form from the home action card or shared drawer.
- Validates Experience details, then displays them in a summary dialog.
- Reuses the drawer across the home, Add Project, and Experience screens.
- Uses a Material 3 color scheme based on indigo, with amber as its secondary color.

## Testing

Run the checks from the project root:

- `flutter analyze` checks the Dart code for errors and lint issues.
- `flutter test` checks the dashboard, action colors, SnackBar feedback, project form, Experience validation, summary dialog, and navigation.

## Weekly Progress

### Week 1
- Set up the Flutter project and separated the app entry point from the menu screen.
- Built a stateless portfolio dashboard with reusable information and action cards.
- Added a Material 3 theme and SnackBar feedback for the action cards.

### Assignment 7

1. A widget tree is the nested arrangement of widgets that describes the user interface. A parent widget contains and configures its child widgets. For example, `MaterialApp` is the app root, `Scaffold` provides the page structure, and the scaffold body contains layout widgets such as `Padding`, `Column`, and `Row`, which in turn contain the information and action cards. Flutter passes layout constraints down from parents to children; the children determine their sizes within those constraints, and parents position them.

2. `MyApp` and `MyHomePage` are custom stateless widgets for app setup and the portfolio screen. `MaterialApp` configures the app's Material theme and home page. `Scaffold` supplies the main page structure, and `AppBar` displays the title. `Padding` adds space around content; `Column` and `Row` arrange children vertically and horizontally; `Center` centers content; and `GridView.count` arranges the action cards in a grid. `InfoCard` is a custom widget that displays one piece of identity information using `Card`, `Container`, `Column`, `Text`, and `SizedBox`. `ItemCard` is a custom action widget; it uses `Material` for its colored surface and `InkWell` for tap interaction, with `Icon`, `Text`, and `Padding` for its content. A `SnackBar` displays tap feedback. `ItemHomepage` stores an action's name, icon, and color; it is a data model, not a widget.

3. `MaterialApp` configures a Flutter app that follows Material Design. It provides app-wide features such as the theme, navigation, and home page. Placing it at the root makes that configuration available to the screens and widgets below it in the tree. In this project it applies the Material 3 color scheme and opens `MyHomePage`.

4. A `StatelessWidget` does not own mutable state; its appearance is determined by its configuration and inherited values. A `StatefulWidget` is paired with a `State` object that stores mutable values and can request a rebuild when they change, for example by calling `setState`. A stateless widget is suitable when the displayed content does not change locally, as with this portfolio dashboard. A stateful widget is needed for interactions that update local UI data, such as a counter or editable form.

5. `BuildContext` represents a widget's location in the widget tree. It lets a widget find information and services provided by its ancestors. This screen uses its context to read the theme with `Theme.of(context)`, get the available screen width with `MediaQuery.of(context)`, and find the `ScaffoldMessenger` that displays SnackBars.

6. Hot reload applies supported Dart code changes to a running app while preserving its current in-memory state. It rebuilds affected widgets but does not rerun `main` or `initState`. Hot restart restarts the Dart application from its entry point and clears its in-memory state. A full restart or rebuild is needed for changes hot reload cannot apply, such as native Android or iOS code, plugin or platform configuration changes, and some startup initialization changes.

### Assignment 8

1. `Navigator.push()` adds a new route above the current route, `Navigator.pushReplacement()` replaces the current route, and `Navigator.pop()` removes the top route to reveal the one below it. The Add Experience card opens the form with `Navigator.push()`, so Back returns to the dashboard. The drawer's Home option uses `Navigator.pushReplacement()` to replace the form with the home screen.

2. `Scaffold` gives each screen a consistent page structure, while `AppBar` provides its title and top-level controls. The same `LeftDrawer` is used on the dashboard and form screens, so navigation stays consistent. The home and Experience app bars both use the theme's primary color; the drawer header also uses indigo, matching the portfolio palette.

3. The form uses a vertical `Column` inside a `SingleChildScrollView`, with `Padding` around each field. The padding separates controls, and the scroll view lets users reach fields and Save when the form is taller than the screen or the keyboard reduces the available space. The date fields open date pickers rather than requiring users to type dates.

4. `GlobalKey<FormState>` gives the Save handler access to the form state. Each field's `validator` checks its value, and `validate()` runs those checks before the summary dialog is shown. For example, a title containing only spaces is rejected because trimming it leaves an empty value. An input type or keyboard only guides what a user can type; it does not guarantee valid data. The optional URL is separately checked for a valid HTTP(S) scheme, and an end date cannot be earlier than the start date.

## AI Disclosure

I used GitHub Copilot in VS Code as a development assistant for this project. The assistance included understanding some aspects of the Tutorials, suggesting, planning, drafting the Assignments, and helping with some questions I asked.

I carefully reviewed and understood every change the AI proposed. I also modified the code whenever I thought the AI was wrong, verified everything with flutter analyze and flutter test, and implemented my own features :D