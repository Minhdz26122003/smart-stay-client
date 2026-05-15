# Ticket Model Enums Refactoring Implementation Plan

> **For Antigravity:** REQUIRED WORKFLOW: Use `.agent/workflows/execute-plan.md` to execute this plan in single-flow mode.

**Goal:** Refactor the `Ticket` entity to use native `json_serializable` Enums for Category and Priority instead of custom converters parsing strings to integers.

**Architecture:** Use `@JsonEnum` with `unknownEnumValue` fallback. Modify the entity, run build_runner, and update UI references.

**Tech Stack:** Flutter, Dart, freezed, json_serializable

---

### Task 1: Update Entities

**Files:**
- Modify: `lib/features/ticket/domain/entities/ticket.dart`
- Modify: `lib/features/ticket/domain/entities/ticket_extensions.dart`

**Step 1: Define Enums and Annotations**
- In `ticket.dart`, define `TicketCategory` and `TicketPriority` enums.
- Use `@JsonValue` for accurate mapping.
- Annotate `TicketCategory` and `TicketPriority` with `@JsonEnum(alwaysCreate: true, unknownEnumValue: ...)`.
- Change the `category` and `priority` fields in `Ticket` class to use these new Enums instead of `int?`.

**Step 2: Update Extensions**
- Move `displayName` properties into the new enums or keep them in extensions, but adapt them to the new enum definitions.

### Task 2: Remove Old Converters

**Files:**
- Modify: `lib/features/ticket/data/models/ticket_model.dart`

**Step 1: Clean up Model**
- Change `int? category` to `TicketCategory? category`.
- Change `int? priority` to `TicketPriority? priority`.
- Remove the `@TicketCategoryConverter()` and `@TicketPriorityConverter()` annotations.
- Delete the old custom `JsonConverter` implementations at the bottom of the file.

**Step 2: Regenerate Code**
- Run: `dart run build_runner build --delete-conflicting-outputs`

### Task 3: Fix Test and UI 

**Files:**
- Modify: `test/features/ticket/data/models/ticket_model_test.dart`
- Modify: `lib/features/landlord_dashboard/presentation/screens/landlord_issue_detail_screen.dart`

**Step 1: Update Test Assertions**
- Assert `expect(model.category, TicketCategory.water)`.
- Assert `expect(model.priority, TicketPriority.medium)`.

**Step 2: Update UI references**
- Change `ticket.categoryName` to `ticket.category?.displayName ?? 'Khác'`.

**Step 3: Run Tests and verify**
- Run `flutter test test/features/ticket/data/models/ticket_model_test.dart`.
- Expected: PASS

**Step 4: Commit**
- `git commit -am "refactor: use native enums for ticket category and priority"`
