# Smart Stay MVP Base Architecture Implementation Plan

> **For Antigravity:** REQUIRED WORKFLOW: Use `.agent/workflows/execute-plan.md` to execute this plan in single-flow mode.

**Goal:** Initialize the Smart Stay Flutter app with Clean Architecture feature-first structure, BLoC state management, theme system, GoRouter, and a mock Authentication flow.

**Architecture:** Feature-first Clean Architecture (core, features/auth, features/landlord, features/tenant, features/marketplace). Using BLoC for state management, get_it for Dependency Injection, and GoRouter for declarative routing.

**Tech Stack:** Flutter, flutter_bloc, go_router, get_it, freezed, json_serializable, dartz

---

### Task 1: Setup Core Dependencies & Project Config

**Files:**
- Modify: `pubspec.yaml`

**Step 1: Write the failing test**
Run: `flutter pub get`
Expected: Passes but we are missing essential packages for upcoming steps.

**Step 2: Write minimal implementation**
Add to `pubspec.yaml` under `dependencies`:
```yaml
  flutter_bloc: ^8.1.5
  go_router: ^13.2.0
  get_it: ^7.6.4
  equatable: ^2.0.5
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  dartz: ^0.10.1
```
Add to `dev_dependencies`:
```yaml
  build_runner: ^2.4.8
  freezed: ^2.4.7
  json_serializable: ^6.7.1
  bloc_test: ^9.1.5
  mocktail: ^1.0.3
```

**Step 3: Run test to verify it passes**
Run: `flutter pub get`
Expected: PASS (All dependencies resolved successfully)

**Step 4: Commit**
```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: setup core dependencies for bloc, routing, and di"
```

---

### Task 2: Implement Core Theme System

**Files:**
- Create: `lib/core/theme/app_colors.dart`
- Create: `lib/core/theme/app_theme.dart`
- Create: `test/core/theme/app_theme_test.dart`

**Step 1: Write the failing test**
Create `test/core/theme/app_theme_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_stay_client/core/theme/app_theme.dart';

void main() {
  test('AppTheme returns light theme with Harmonious Host primary color', () {
    final theme = AppTheme.lightTheme;
    expect(theme.primaryColor.value, 0xFF00685F); // Deep Teal
  });
}
```

**Step 2: Run test to verify it fails**
Run: `flutter test test/core/theme/app_theme_test.dart`
Expected: FAIL (AppTheme undefined)

**Step 3: Write minimal implementation**
Create `lib/core/theme/app_colors.dart`:
```dart
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF00685F);
  static const secondary = Color(0xFF855300);
  static const container = Color(0xFFFEA619);
  static const background = Color(0xFFF8F9FF);
  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF121C2A);
  // Semantic colors will be added in ThemeExtension later
}
```
Create `lib/core/theme/app_theme.dart`:
```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.onSurface),
      ),
    );
  }
}
```

**Step 4: Run test to verify it passes**
Run: `flutter test test/core/theme/app_theme_test.dart`
Expected: PASS

**Step 5: Commit**
```bash
git add lib/core/theme/ test/core/theme/
git commit -m "feat(core): implement harmonious host theme system"
```

---

### Task 3: Setup GoRouter & Main App Shell

**Files:**
- Create: `lib/core/routes/app_router.dart`
- Create: `lib/features/auth/presentation/pages/welcome_page.dart`
- Modify: `lib/main.dart`

**Step 1: Write the failing test**
Run: `flutter test`
Expected: Existing counter test in main fails once we alter `main.dart`

**Step 2: Write minimal implementation**
Create `lib/features/auth/presentation/pages/welcome_page.dart`:
```dart
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Welcome to Smart Stay')));
  }
}
```
Create `lib/core/routes/app_router.dart`:
```dart
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';

final appRouter = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomePage(),
    ),
  ],
);
```
Modify `lib/main.dart`:
```dart
import 'package:flutter/material.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const SmartStayApp());
}

class SmartStayApp extends StatelessWidget {
  const SmartStayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Stay',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
```
Delete existing boilerplate test `test/widget_test.dart`.

**Step 3: Run test to verify it passes**
Run: `flutter analyze`
Expected: PASS (No analyzer errors)

**Step 4: Commit**
```bash
git add lib/core/routes/ lib/features/auth/ lib/main.dart
git rm test/widget_test.dart
git commit -m "feat(core): setup go_router and main app entry point"
```

---

### Task 4: Setup Dependency Injection

**Files:**
- Create: `lib/core/di/injection_container.dart`
- Modify: `lib/main.dart`
- Test: `test/core/di/injection_test.dart`

**Step 1: Write the failing test**
Create `test/core/di/injection_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_stay_client/core/di/injection_container.dart';

void main() {
  test('Di is initialized completely', () async {
    await initDI();
    expect(GetIt.I.isRegistered<String>(instanceName: 'test_ready'), true);
  });
}
```

**Step 2: Run test to verify it fails**
Run: `flutter test test/core/di/injection_test.dart`
Expected: FAIL (initDI undefined)

**Step 3: Write minimal implementation**
Create `lib/core/di/injection_container.dart`:
```dart
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // Core/External components to be added here
  
  // Dummy reg to pass test
  sl.registerLazySingleton<String>(() => 'Ready', instanceName: 'test_ready');
}
```
Modify `lib/main.dart` to initialize DI:
```dart
import 'package:flutter/material.dart';
import 'core/di/injection_container.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDI();
  runApp(const SmartStayApp());
}
...
```

**Step 4: Run test to verify it passes**
Run: `flutter test test/core/di/injection_test.dart`
Expected: PASS

**Step 5: Commit**
```bash
git add .
git commit -m "chore(core): configure get_it dependency injection container"
```
