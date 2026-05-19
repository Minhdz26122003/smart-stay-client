# Landlord Contracts Screen Implementation Plan

> **For Antigravity:** REQUIRED WORKFLOW: Use `.agent/workflows/execute-plan.md` to execute this plan in single-flow mode.

**Goal:** Create a high-fidelity, dynamic Landlord Contracts Screen accessible from the Operations tab's Quick Actions, using existing Property/Room state to display room contracts, with premium styling, search/filter controls, and creation/detail navigation.

**Architecture:** 
- Clean Architecture (Feature-first). The screen will be placed inside `lib/features/landlord_dashboard/presentation/screens/landlord_contracts_screen.dart`.
- Uses `flutter_bloc` to read the active `RoomCubit` state. Lenders manage contracts under properties; we load the property's occupied/reserved rooms to represent active contracts.
- Generates beautiful, realistic contract objects dynamically using room name and price, combined with common Vietnamese names for tenants to provide a rich, zero-config UX.
- Integrates fully into the `GoRouter` configuration in `lib/core/routes/app_router.dart`.

**Tech Stack:** Flutter, BLoC, GoRouter, Vanilla Material 3 (with custom extension styling).

---

## 1. Thiết kế Giao diện & Trải nghiệm (UI/UX Specification)
Màn hình **Quản lý Hợp đồng (`LandlordContractsScreen`)** sẽ mang phong cách Glassmorphism & Modern Dark/Light sang trọng:
- **Header:** Tiêu đề "Quản lý hợp đồng" nổi bật, thanh tìm kiếm bo góc mềm mại, icon Search và các bộ lọc nhanh tinh tế.
- **Stat Cards (Chỉ số tổng quan):**
  - *Tổng số hợp đồng:* Số phòng đang thuê (`RoomStatus.occupied`).
  - *Sắp hết hạn:* Số hợp đồng còn dưới 30 ngày (sinh ngẫu nhiên có kiểm soát).
  - *Đã cọc giữ chỗ:* Số phòng đã cọc (`RoomStatus.reserved`).
- **Tab/Filter Chips:** Bộ lọc nhanh trạng thái hợp đồng: *Tất cả*, *Đang hoạt động*, *Sắp hết hạn*, *Giữ chỗ*.
- **Danh sách Hợp đồng (Premium List):**
  - Hiển thị dạng Card bo góc rộng, bóng đổ mịn màng.
  - Mỗi thẻ hiển thị: Icon hợp đồng thanh lịch, tên phòng (ví dụ: `P.102`), tên khách thuê (ví dụ: `Trần Thị Bình`), giá thuê, tiền đặt cọc, khoảng thời gian hiệu lực và Badge trạng thái (Đang hoạt động - xanh lá, Sắp hết hạn - cam, Giữ chỗ - tím).
  - Hỗ trợ nhấn để chuyển tiếp đến màn hình chi tiết phòng/hợp đồng (`LandlordRoomDetailScreen`) tương ứng.
- **Nút hành động nổi (FAB):** Nút tròn nổi chứa biểu tượng `+` và nhãn "Tạo hợp đồng" co giãn mượt mượt khi cuộn để dẫn tới `/landlord/operations/create-contract`.

---

## 2. Kế hoạch triển khai chi tiết (Bite-sized Tasks)

### Task 1: Định nghĩa Route mới trong Router của Ứng dụng
- **File cần chỉnh sửa:** `lib/core/routes/app_router.dart:150-155`
- **Nội dung:** Thêm route `contracts` dưới nhánh `/landlord/operations` dẫn đến `LandlordContractsScreen`.
- **Code thay đổi:**
  ```dart
  GoRoute(
    path: 'contracts',
    builder: (_, __) => const LandlordContractsScreen(),
  ),
  ```

### Task 2: Tạo màn hình giao diện LandlordContractsScreen (Khung xương & State)
- **File cần tạo mới:** `lib/features/landlord_dashboard/presentation/screens/landlord_contracts_screen.dart`
- **Nội dung:** Khai báo lớp `LandlordContractsScreen` là một `StatefulWidget` với Scaffold cơ bản và kết nối `RoomCubit` để lấy danh sách phòng thực tế.
- **Code ban đầu:**
  ```dart
  import 'package:flutter/material.dart';
  import 'package:go_router/go_router.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import '../../../room/presentation/cubit/room_cubit.dart';
  import '../../../room/presentation/cubit/room_state.dart';
  import '../../../room/domain/entities/room.dart';
  ```

### Task 3: Xây dựng cấu trúc Hợp đồng giả lập cao cấp dựa trên phòng thật
- **File cần chỉnh sửa:** `lib/features/landlord_dashboard/presentation/screens/landlord_contracts_screen.dart`
- **Nội dung:** Viết class nội bộ `_MockContract` và helper generator để chuyển đổi từ thực thể `Room` thật sang thông tin hợp đồng sinh động (tên tenant ngẫu nhiên, ngày bắt đầu/kết thúc, tiền cọc, tiền thuê).
- **Code chi tiết:**
  ```dart
  class _MockContract {
    final Room room;
    final String tenantName;
    final String tenantPhone;
    final DateTime startDate;
    final DateTime endDate;
    final double deposit;
    final String statusLabel; // 'Đang hoạt động', 'Sắp hết hạn', 'Giữ chỗ'
    final Color statusColor;

    _MockContract({
      required this.room,
      required this.tenantName,
      required this.tenantPhone,
      required this.startDate,
      required this.endDate,
      required this.deposit,
      required this.statusLabel,
      required this.statusColor,
    });
  }
  ```

### Task 4: Triển khai Bộ lọc & Tìm kiếm (Search & Tab Filters)
- **File cần chỉnh sửa:** `lib/features/landlord_dashboard/presentation/screens/landlord_contracts_screen.dart`
- **Nội dung:** Thêm ô nhập liệu tìm kiếm theo Tên phòng/Tên khách thuê và các Tab filter chip trạng thái. Cập nhật logic lọc danh sách hợp đồng tức thời.

### Task 5: Hoàn thiện Giao diện Premium và Thao tác Danh sách
- **File cần chỉnh sửa:** `lib/features/landlord_dashboard/presentation/screens/landlord_contracts_screen.dart`
- **Nội dung:** Viết chi tiết giao diện danh sách Card, các Stat Cards chỉ số tổng quan ở phía trên và FloatingActionButton để tạo hợp đồng. Kết nối điều hướng `onTap` sang màn hình chi tiết phòng với `roomId`.

### Task 6: Cập nhật điều hướng Quick Action trong Operations Screen
- **File cần chỉnh sửa:** `lib/features/landlord_dashboard/presentation/screens/landlord_operations_screen.dart:114-121`
- **Nội dung:** Sửa đường dẫn `onTap` của Quick Action "Hợp đồng" từ `/landlord/operations/create-contract` thành `/landlord/operations/contracts`.

### Task 7: Tài liệu & Cập nhật Nhật ký phát triển (Changelog)
- **Files cần chỉnh sửa:**
  - `docs/CHANGELOG.md`
  - `docs/plans/task.md`
  - Đánh dấu hoàn tất toàn bộ kế hoạch triển khai này.

---
## 3. Cách xác minh và kiểm thử (Verification & Testing)
- **Kiểm tra biên dịch:** Đảm bảo dự án compile thành công mà không có bất kỳ lỗi phân tích tĩnh (Static Analysis) hay cảnh báo linter nào.
- **Kiểm tra trực quan:**
  - Nhấp vào "Hợp đồng" trên tab Vận hành, ứng dụng phải chuyển sang màn hình danh sách hợp đồng mượt mà.
  - Danh sách hợp đồng phải phản ánh đúng các phòng đang thuê của khu trọ hiện tại.
  - Ô tìm kiếm và bộ lọc Tab hoạt động nhạy bén, lọc đúng dữ liệu.
  - Nút Tạo hợp đồng (FAB) chuyển hướng chính xác đến màn hình tạo hợp đồng.
  - Click vào thẻ hợp đồng chuyển hướng đúng đến chi tiết phòng đó.
