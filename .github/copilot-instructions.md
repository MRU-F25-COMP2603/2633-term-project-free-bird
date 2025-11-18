# AI Agent Instructions for Free Bird Project

## Project Overview
Free Bird is a Flutter application developed as a term project. The project is in its early stages, using Flutter's standard architecture and Material Design components.

## Project Structure
- `/lib`: Contains the Dart source code
  - `main.dart`: Entry point and root widget definition
- `/test`: Contains widget tests
  - `widget_test.dart`: Example widget test for the counter functionality
- `/windows`: Windows-specific platform code and configuration
- `/build`: Build artifacts (should not be edited directly)

## Development Environment
- Flutter SDK version: ^3.9.2
- Dependencies:
  - cupertino_icons: ^1.0.8
  - flutter_lints: ^5.0.0 (dev)

## Key Development Workflows

### Building and Running
```bash
# Run the application in debug mode
flutter run

# Hot reload (while app is running)
r

# Hot restart (while app is running)
R

# Build release version
flutter build windows  # For Windows platform
```

### Testing
```bash
# Run all widget tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart
```

## State Management
The project currently uses Flutter's built-in `setState` for state management in the `MyHomePage` widget. When adding new stateful features:
1. Define state variables in the corresponding State class
2. Use `setState(() {})` to trigger UI updates
3. Keep state management local to widgets unless there's a specific need for global state

## Project Conventions
1. Widget Structure:
   - Stateless widgets use `const` constructors
   - Required parameters use the `required` keyword
   - Widget files follow the pattern of one widget per file (to be implemented)

2. Code Organization:
   - Main app widget: `MyApp` in `main.dart`
   - Page widgets: Create in separate files under `/lib/pages` (to be implemented)
   - Reusable widgets: Place in `/lib/widgets` (to be implemented)

## Integration Points
- Material Design: The app uses Flutter's Material Design components
- Platform Integration: Windows-specific code is in the `/windows` directory

## Testing Approach
Widget tests follow the pattern in `widget_test.dart`:
1. Create widget using `tester.pumpWidget()`
2. Interact using `tester.tap()`, `tester.drag()`, etc.
3. Verify using `expect()` with finder matchers

---
Note: This project is in active development. New patterns and conventions may emerge as the project grows.