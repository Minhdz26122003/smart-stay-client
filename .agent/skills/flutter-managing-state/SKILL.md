---
name: "flutter-managing-state"
description: "Manages application and ephemeral state in a Flutter app using flutter_bloc. Use when sharing data between widgets or handling complex UI state transitions."
metadata:
  model: "models/gemini-3.1-pro-preview"
  last_modified: "Thu, 02 Apr 2026 21:00:00 GMT"
---
# Managing State in Flutter (BLoC/Cubit)

## Contents
- [Core Concepts](#core-concepts)
- [Architecture and Data Flow](#architecture-and-data-flow)
- [Workflow: Selecting a State Management Approach](#workflow-selecting-a-state-management-approach)
- [Workflow: Implementing with Cubit/BLoC](#workflow-implementing-with-cubitbloc)
- [Examples](#examples)

## Core Concepts

Flutter's UI is declarative; it is built to reflect the current state of the app (`UI = f(state)`). 

*   **Ephemeral State (Local State):** State contained neatly within a single widget. Manage this using a `StatefulWidget` and `setState()`.
*   **App State (Shared State):** State shared across the app. Manage this using the `flutter_bloc` package with `Cubit` (for simpler logic) or `Bloc` (for complex, event-driven logic).

## Architecture and Data Flow

Implement **Unidirectional Data Flow (UDF)** with **BLoC/Cubit** for scalable app state management.

*   **Model (Data Layer):** Repositories handle data fetching and provide models.
*   **Logic (BLoC/Cubit):** Manages the UI state. Emits new states based on method calls (Cubit) or events (BLoC).
*   **View (UI Layer):** Consumes states using `BlocBuilder`, `BlocConsumer`, or `BlocListener` to rebuild the UI.

## Workflow: Selecting a State Management Approach

*   **If managing Ephemeral State:** Use `StatefulWidget` and `setState()`.
*   **If managing logic with standard CRUD or Form validation:** Use **`Cubit`**.
*   **If managing complex logic (WebSockets, step-by-step flows, debounce/throttle):** Use **`Bloc`**.

## Workflow: Implementing with Cubit/BLoC

**Task Progress:**
- [ ] 1. Define State classes (preferably using `freezed`).
- [ ] 2. Create the `Cubit` or `Bloc` class.
- [ ] 3. Inject the Cubit/Bloc using `BlocProvider`.
- [ ] 4. Consume the State in the View using `BlocBuilder` or `BlocConsumer`.

## Examples

### App State Implementation (Cubit)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 1. Model (Repository)
class CartRepository {
  Future<void> saveItemToCart(String item) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

// 2. State
class CartState {
  final List<String> items;
  final bool isLoading;
  final String? errorMessage;
  
  const CartState({this.items = const [], this.isLoading = false, this.errorMessage});
}

// 3. Cubit
class CartCubit extends Cubit<CartState> {
  final CartRepository repository;
  CartCubit({required this.repository}) : super(const CartState());

  Future<void> addItem(String item) async {
    emit(CartState(items: state.items, isLoading: true));
    try {
      await repository.saveItemToCart(item);
      final newItems = List<String>.from(state.items)..add(item);
      emit(CartState(items: newItems, isLoading: false));
    } catch (e) {
      emit(CartState(items: state.items, isLoading: false, errorMessage: 'Failed to add item'));
    }
  }
}

// 4. Injection
class CartApp extends StatelessWidget {
  const CartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(repository: CartRepository()),
      child: const CartScreen(),
    );
  }
}

// 5. View
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          if (state.isLoading) return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (_, index) => ListTile(title: Text(state.items[index])),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CartCubit>().addItem('New Item'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```
