# Reorganize Dashboard Screens Implementation Plan

> **For Antigravity:** REQUIRED WORKFLOW: Use `.agent/workflows/execute-plan.md` to execute this plan in single-flow mode.

**Goal:** Organize the presentation screens for `landlord_dashboard` and `tenant_dashboard` into semantic subfolders to improve maintainability and project structure.

**Architecture:** We will create sub-directories based on feature modules within the presentation/screens folders of both landlord and tenant dashboards, move the corresponding dart files into these sub-directories, and then update the import paths across the codebase (primarily in `app_router.dart` and shell screens).

**Tech Stack:** Flutter, Dart

---

### Task 1: Reorganize Landlord Dashboard Screens

**Files:**

- Move: Multiple files in `lib/features/landlord_dashboard/presentation/screens/`

**Step 1: Create sub-directories and move files**

Run the following commands to create directories and move files:

```bash
cd lib/features/landlord_dashboard/presentation/screens
mkdir -p board rooms appointments chat checkout contract finance home issues listings operations notifications profile

mv landlord_add_board_post_screen.dart landlord_board_screen.dart board/
mv landlord_add_room_screen.dart landlord_rooms_screen.dart landlord_room_detail_screen.dart rooms/
mv landlord_appointments_screen.dart appointments/
mv landlord_chat_screen.dart landlord_messages_screen.dart chat/
mv landlord_checkout_screen.dart checkout/
mv landlord_create_contract_screen.dart contract/
mv landlord_finance_screen.dart landlord_invoice_detail_screen.dart landlord_invoice_settle_screen.dart landlord_payment_info_screen.dart finance/
mv landlord_home_screen.dart home/
mv landlord_issue_detail_screen.dart landlord_issues_screen.dart issues/
mv landlord_listings_screen.dart landlord_post_room_screen.dart listings/
mv landlord_operations_screen.dart landlord_meter_scan_screen.dart operations/
mv landlord_notifications_screen.dart notifications/
mv landlord_profile_screen.dart profile/
# Note: landlord_shell_screen.dart remains at the root of screens/
cd ../../../../..
```

**Step 2: Commit**

```bash
git add lib/features/landlord_dashboard/presentation/screens/
git commit -m "refactor: reorganize landlord dashboard screens into subfolders"
```

---

### Task 2: Reorganize Tenant Dashboard Screens

**Files:**

- Move: Multiple files in `lib/features/tenant_dashboard/presentation/screens/`

**Step 1: Create sub-directories and move files**

Run the following commands to create directories and move files:

```bash
cd lib/features/tenant_dashboard/presentation/screens
mkdir -p chat contract home invoice issues room notifications profile services

mv tenant_chat_screen.dart chat/
mv tenant_contract_screen.dart contract/
mv tenant_home_screen.dart home/
mv tenant_invoice_detail_screen.dart tenant_invoices_screen.dart invoice/
mv tenant_issue_detail_screen.dart tenant_report_issue_screen.dart issues/
mv tenant_my_room_screen.dart room/
mv tenant_notifications_screen.dart notifications/
mv tenant_profile_screen.dart profile/
mv tenant_services_screen.dart services/
# Note: tenant_shell_screen.dart remains at the root of screens/
cd ../../../../..
```

**Step 2: Commit**

```bash
git add lib/features/tenant_dashboard/presentation/screens/
git commit -m "refactor: reorganize tenant dashboard screens into subfolders"
```

---

### Task 3: Update Import Paths

**Files:**

- Modify: `lib/core/routes/app_router.dart`
- Modify: Any other files that import these screens

**Step 1: Fix Import Errors**

Since files were moved, imports in routing and shell screens will be broken. We will rely on Dart's tooling to find and fix the broken imports, or update them manually using search and replace.

You can run `dart analyze` to find broken imports.
Update `app_router.dart`, `landlord_shell_screen.dart`, and `tenant_shell_screen.dart` to point to the new paths:

Example updates:

- `import 'package:smart_stay_client/features/landlord_dashboard/presentation/screens/landlord_home_screen.dart';`
  becomes
  `import 'package:smart_stay_client/features/landlord_dashboard/presentation/screens/home/landlord_home_screen.dart';`
- Make similar updates for all the moved screens.

**Step 2: Run flutter analyze to verify**

Run: `flutter analyze`
Expected: No issues found related to imports.

**Step 3: Commit**

```bash
git add lib/core/routes/app_router.dart lib/features/landlord_dashboard/presentation/screens/landlord_shell_screen.dart lib/features/tenant_dashboard/presentation/screens/tenant_shell_screen.dart
git commit -m "fix: update import paths for reorganized dashboard screens"
```
