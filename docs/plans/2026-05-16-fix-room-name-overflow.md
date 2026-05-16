# [UI Fix] Xử lý tràn chữ cho Tên phòng tại LandlordRoomsScreen Implementation Plan

> **For Antigravity:** REQUIRED WORKFLOW: Use `.agent/workflows/execute-plan.md` to execute this plan in single-flow mode.

**Goal:** Ngăn chặn lỗi Overflow bằng cách cho phép tên phòng tự thu nhỏ (ellipsis) khi quá dài, đảm bảo label trạng thái luôn hiển thị đúng vị trí.

**Architecture:** Sử dụng widget `Flexible` kết hợp với thuộc tính `overflow: TextOverflow.ellipsis` của widget `Text`.

**Tech Stack:** Flutter Framework.

---

### Task 1: Cập nhật Layout trong LandlordRoomsScreen

**Files:**
- Modify: `lib/features/landlord_dashboard/presentation/screens/landlord_rooms_screen.dart:189-214`

**Step 1: Cập nhật Row chứa tên phòng**

**Step 2: Chạy verify để đảm bảo không còn lỗi layout**

**Step 3: Cập nhật CHANGELOG.md**
