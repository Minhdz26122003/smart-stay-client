# Ticket Payload Normalization Implementation Plan

> **For Antigravity:** REQUIRED WORKFLOW: Use `.agent/workflows/execute-plan.md` to execute this plan in single-flow mode.

**Goal:** Make ticket parsing accept the backend payload currently returned by the API without crashing the landlord issues flow.

**Architecture:** Normalize ticket payload values at the data-model boundary so the rest of the app can keep using the existing `Ticket` entity contract. Add a focused regression test around `TicketModel.fromJson`, then update display helpers to consume normalized category data instead of a hardcoded label.

**Tech Stack:** Flutter, Dart, freezed, json_serializable, flutter_test

---

### Task 1: Reproduce the backend payload mismatch

**Files:**
- Modify: `test/features/ticket/data/models/ticket_model_test.dart`

**Step 1: Write the failing test**
- Use the real API shape with `category: "Water"`, `priority: "Medium"`, and `status: "Pending"`.

**Step 2: Run test to verify it fails**
- Run `flutter test test/features/ticket/data/models/ticket_model_test.dart`
- Expected: FAIL with a cast or enum parsing error from `TicketModel.fromJson`.

### Task 2: Normalize model parsing

**Files:**
- Modify: `lib/features/ticket/data/models/ticket_model.dart`
- Modify: `lib/features/ticket/data/models/ticket_model.g.dart`

**Step 1: Add custom JSON converters**
- Parse `category` from either integer or backend string labels.
- Parse `priority` from either integer or backend string labels.
- Parse `status` from either integer or backend string labels such as `Pending`.

**Step 2: Regenerate generated code**
- Run `dart run build_runner build --delete-conflicting-outputs`

### Task 3: Use normalized category display

**Files:**
- Modify: `lib/features/ticket/domain/entities/ticket_extensions.dart`
- Modify: `lib/features/landlord_dashboard/presentation/screens/landlord_issue_detail_screen.dart`

**Step 1: Add category display helper**
- Map normalized category integers to human-readable labels.

**Step 2: Replace hardcoded detail label**
- Show the parsed ticket category instead of the fixed `Báo lỗi điện/nước` text.

### Task 4: Verify

**Files:**
- Test: `test/features/ticket/data/models/ticket_model_test.dart`

**Step 1: Re-run focused test**
- Run `flutter test test/features/ticket/data/models/ticket_model_test.dart`
- Expected: PASS

**Step 2: Run analyzer for touched files**
- Run `flutter analyze lib/features/ticket lib/features/landlord_dashboard/presentation/screens/landlord_issue_detail_screen.dart`
- Expected: no new issues in touched code.
