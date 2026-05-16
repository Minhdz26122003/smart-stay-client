# [Fix Room Delete Refresh] Implementation Plan

> **For Antigravity:** REQUIRED WORKFLOW: Use `.agent/workflows/execute-plan.md` to execute this plan in single-flow mode.

**Goal:** Sửa luồng xóa phòng để sau khi xóa thành công, màn danh sách phòng tự tải lại dữ liệu và không gây hiểu nhầm là chưa xóa.

**Architecture:** Giữ nguyên Clean Architecture hiện có. Sửa ở presentation flow bằng cách để màn chi tiết trả kết quả xóa thành công về màn danh sách, rồi dùng `RoomCubit` reload lại danh sách theo `propertyId` của phòng vừa xóa.

**Tech Stack:** Flutter, flutter_bloc, GoRouter, flutter_test, mocktail.

---

### Task 1: Ghi regression test cho luồng quay lại từ màn chi tiết

**Files:**
- Create: `test/features/landlord_dashboard/presentation/screens/landlord_rooms_screen_test.dart`
- Modify: `docs/plans/task.md`

**Step 1: Write the failing test**

Viết widget test chứng minh khi `LandlordRoomsScreen` mở màn chi tiết, màn chi tiết `pop(true)`, thì `RoomCubit.loadRooms(propertyId)` phải được gọi lại.

**Step 2: Run test to verify it fails**

Run: `flutter test test/features/landlord_dashboard/presentation/screens/landlord_rooms_screen_test.dart`
Expected: FAIL vì màn rooms hiện chưa chờ kết quả trả về từ route detail nên chưa reload.

### Task 2: Sửa luồng navigation của room delete

**Files:**
- Modify: `lib/features/landlord_dashboard/presentation/screens/landlord_rooms_screen.dart`
- Modify: `lib/features/landlord_dashboard/presentation/screens/landlord_room_detail_screen.dart`

**Step 1: Write minimal implementation**

- Cho `LandlordRoomsScreen` `await context.push(...)`.
- Nếu route trả `true`, gọi `context.read<RoomCubit>().loadRooms(room.propertyId)`.
- Cho `LandlordRoomDetailScreen` dùng `context.pop(true)` sau khi delete thành công.

**Step 2: Run test to verify it passes**

Run: `flutter test test/features/landlord_dashboard/presentation/screens/landlord_rooms_screen_test.dart`
Expected: PASS

### Task 3: Verify và cập nhật changelog

**Files:**
- Modify: `docs/CHANGELOG.md`

**Step 1: Run focused verification**

Run: `flutter test test/features/landlord_dashboard/presentation/screens/landlord_rooms_screen_test.dart`
Expected: PASS

**Step 2: Update changelog**

Thêm entry ngày `2026-05-16` cho bugfix refresh dữ liệu sau xóa phòng trong `docs/CHANGELOG.md`.
