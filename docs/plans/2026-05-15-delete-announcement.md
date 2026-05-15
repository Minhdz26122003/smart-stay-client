# Delete Announcement Implementation Plan

> **For Antigravity:** REQUIRED WORKFLOW: Use `.agent/workflows/execute-plan.md` to execute this plan in single-flow mode.

**Goal:** Add a confirmed delete flow for landlord announcements that calls `DELETE /api/v1/announcements/{id}`, prevents duplicate taps while deleting, refreshes the list on success, and shows an error message on failure.

**Architecture:** Keep the API contract and repository layer unchanged because delete is already implemented there. Extend `AnnouncementState` and `AnnouncementCubit` with delete-specific states, then wire `LandlordBoardScreen` to show a confirmation dialog, disable the targeted card while deletion is in flight, and surface success/failure feedback through `SnackBar`.

**Tech Stack:** Flutter, Dart, flutter_bloc, dio, flutter_test, bloc_test, mocktail

---

### Task 1: Add a failing delete-flow cubit test

**Files:**
- Create: `test/features/announcement/presentation/cubit/announcement_cubit_test.dart`
- Modify: `lib/features/announcement/presentation/cubit/announcement_cubit.dart`
- Modify: `lib/features/announcement/presentation/cubit/announcement_state.dart`

**Step 1: Write the failing test**
- Add a cubit test that expects:
  - a delete-in-progress state carrying the target announcement id
  - then a refreshed loaded state after repository delete + reload succeed
- Add a second test that expects a delete-error state when repository delete fails.

**Step 2: Run test to verify it fails**
- Run: `flutter test test/features/announcement/presentation/cubit/announcement_cubit_test.dart`
- Expected: FAIL because delete-specific states do not exist yet.

**Step 3: Implement minimal state changes**
- Add delete-specific states to `announcement_state.dart`:
  - `AnnouncementDeleteInProgress`
  - `AnnouncementDeleteError`
- Update `AnnouncementCubit.deleteAnnouncement` to emit delete progress, call delete, reload announcements, and emit delete error without losing the existing list reload behavior.

**Step 4: Run test to verify it passes**
- Run: `flutter test test/features/announcement/presentation/cubit/announcement_cubit_test.dart`
- Expected: PASS.

### Task 2: Wire delete confirmation and UI feedback in landlord board

**Files:**
- Modify: `lib/features/landlord_dashboard/presentation/screens/landlord_board_screen.dart`

**Step 1: Add confirmation dialog**
- Replace the bottom-sheet-only delete action with:
  - bottom sheet action
  - then an `AlertDialog` confirmation before calling delete

**Step 2: Add UI loading/disable behavior**
- Detect `AnnouncementDeleteInProgress` in the board screen.
- Disable the target card’s delete action while its delete request is in flight.
- Optionally show a small spinner in place of the `more_vert` icon for that card only.

**Step 3: Add success/error feedback**
- Use `BlocListener`/`BlocConsumer` around the board content to show:
  - success `SnackBar` after a successful delete refresh
  - error `SnackBar` when deletion fails

**Step 4: Keep behavior scoped**
- Do not change create announcement flow.
- Do not refactor unrelated board interactions.

### Task 3: Verify the feature

**Files:**
- Test: `test/features/announcement/presentation/cubit/announcement_cubit_test.dart`
- Modify: `lib/features/landlord_dashboard/presentation/screens/landlord_board_screen.dart`

**Step 1: Run focused cubit test**
- Run: `flutter test test/features/announcement/presentation/cubit/announcement_cubit_test.dart`
- Expected: PASS.

**Step 2: Run analyzer on touched files**
- Run: `flutter analyze lib/features/announcement lib/features/landlord_dashboard/presentation/screens/landlord_board_screen.dart`
- Expected: no new analysis issues in touched code.

**Step 3: Manual acceptance**
- Open landlord board.
- Tap menu on a post.
- Tap delete.
- Confirm in dialog.
- Expected:
  - API delete is called with the announcement id
  - the delete action is blocked while request is running
  - list refreshes without the deleted item
  - failures show an error `SnackBar`
