# [Delete Room & Property] Implementation Plan

> **For Antigravity:** REQUIRED WORKFLOW: Use `.agent/workflows/execute-plan.md` to execute this plan in single-flow mode.

**Goal:** Triển khai chức năng xóa Phòng và Khu trọ từ màn hình chi tiết, đảm bảo có xác nhận và kiểm tra ràng buộc.

**Architecture:** Tuân thủ Clean Architecture. Thêm phương thức DELETE vào DataSources, Repositories và cập nhật BLoC/Cubit để xử lý trạng thái xóa.

**Tech Stack:** Flutter, BLoC (Cubit), Dio, Freezed.

---

### Task 1: Cập nhật Tầng Data (Data Layer) - Room & Property [COMPLETED]
- [x] Step 1: Thêm `deleteRoom` vào RoomRemoteDataSource
- [x] Step 2: Cập nhật RoomRepository và RoomRepositoryImpl
- [x] Step 3: Thêm `deleteProperty` vào PropertyRemoteDataSource
- [x] Step 4: Cập nhật PropertyRepository và PropertyRepositoryImpl

### Task 2: Cập nhật Tầng Presentation (Cubit) - RoomDetail & Property [COMPLETED]
- [x] Step 1: Cập nhật `RoomDetailState` & `PropertyState`
- [x] Step 2: Run build_runner to update freezed files
- [x] Step 3: Triển khai hàm `deleteRoom` & `deleteProperty`

### Task 3: Cập nhật Giao diện (UI) [COMPLETED]
- [x] Step 1: Thêm IconButton (Trash) vào AppBar của LandlordRoomDetailScreen
- [x] Step 2: Thêm tính năng xóa Khu trọ (Long press chip) tại Trang chủ
- [x] Step 3: Implement các hộp thoại xác nhận xóa
- [x] Step 4: Thêm BlocListener để xử lý phản hồi

### Task 4: Hoàn thiện và Cập nhật Changelog [COMPLETED]
- [x] Step 1: Kiểm tra lại toàn bộ luồng xóa
- [x] Step 2: Cập nhật `docs/CHANGELOG.md`
