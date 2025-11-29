# ✈️ Flight Management System
A Flutter-based Windows desktop application that allows users to manage flights, store travel documents, translate languages, and convert currencies.

---

## 📌 Quick Links
- **Communication Channel:** *https://discord.gg/9WkK585cRg*
- **Shared Google Folder:** *https://drive.google.com/drive/u/2/folders/1nGN5eugkkD60EATT8uIWbhy8Uw9e3N7E*

---

## 👥 Team Members
Joshua Martenson • Zayn Khan • Mohamad Hamade • Abhu Sharma • Alexander Ayeye

---

# 🧭 User Guide

## 📘 High-Level Overview
The Flight Management System provides:
- Account creation and login  
- Flight storage and management  
- Document uploading and viewing  
- Language translation tools  
- Currency conversion utilities  

This system is designed as a **Windows desktop application** built with Flutter and Dart.

---

## 🛠️ Prerequisites
Before installation, ensure the following are installed:

1. **Windows OS**
2. **Flutter SDK** (with Windows desktop support enabled)
3. **Dart SDK**  
4. **Visual Studio Code**
5. **Visual Studio (Desktop development with C++)** ← *important requirement*
6. **Nuget** (for TTS)

Verify Flutter setup:
```bash
flutter doctor
```

---

## Installation & Setup

**1.** Install all prerequisites listed above.

**2.** Open Visual Studio Code (or your preferred IDE).

**3.** Clone the repository:
```bash
git clone https://github.com/MRU-F25-COMP2603/2633-term-project-free-bird.git
```
**4.** Install Dependencies:
```bash
flutter pub get
```
**5.** Run the application:
```bash
flutter run
```

---

## Troubleshooting
**App fails to start/dependency errors**  
Delete pubspec.lock and re-run:
```bash
rm pubspec.lock
flutter pub get
```
**Flutter doesn't detect Windows support**  
Run and follow recommendations:
```bash
flutter doctor
```

---

## Reporting Bugs (User)

When creating a GitHub issue, include:

* Steps to reproduce

* Expected behavior

* Actual behavior

* Screenshots / logs (attach if available)

* Environment info (OS version, Flutter version, etc.)

---

# 🧑‍💻 DEVELOPER GUIDE
## Project Structure
```bash
root/
 ├─ .github/        # Github Actions settings
 ├─ .vscode/        # Visual Studio flutter integration
 ├─ lib/            # Main application code (UI and business logic)
 ├─ test/           # Unit and widget tests
 ├─ windows/        # Windows runner and native files
 │    ├─ flutter/   # Flutter installation and plugins
 │    └─ runner/    # Main.cpp and relevant settings
 ├─ firebase.json   # Firebase keys and settings
 └─ pubspec.yaml    # Flutter package definitions
```

---

## Build & Run (Developer)

**1.** Ensure prerequisites are installed (see User Guide).

**2.** From repo root:
```bash
flutter clean
flutter pub get
flutter run
```

---

# Tests
## Running tests
```bash
flutter test
```
Tests are configured to run manually via the above command and upon all commits/pull requests.
## Adding tests:
**1.** Open the test/ directory
**2.** Create a new test file or update an existing one. Use the standard Flutter test structure:
```bash
void main() {
  testWidgets('should navigate to dashboard after login', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(MyApp());

    // Act
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
```
**3.** Run before committing:
```bash
flutter test
```
