# Kế hoạch triển khai: Tích hợp và Tải động danh sách sự cố chờ xử lý vào màn hình Vận hành của Chủ nhà

Tài liệu này trình bày chi tiết kế hoạch các bước sửa đổi và tích hợp dữ liệu thật từ `TicketCubit` vào mục "Sự cố cần xử lý" tại màn hình Vận hành của Chủ nhà (`LandlordOperationsScreen`).

---

## 1. Bối cảnh & Mục tiêu

### Bối cảnh hiện tại:
- Tại [landlord_operations_screen.dart](file:///f:/Documents/Flutter/smart_stay_client/lib/features/landlord_dashboard/presentation/screens/landlord_operations_screen.dart#L280-L361), mục **"Sự cố cần xử lý"** (Issues) đang hiển thị badge số lượng tĩnh là `'2'` và danh sách hai thẻ `_IssueCard` tĩnh được hardcode (P.102 - Điều hòa không mát và P.305 - Đèn hành lang tầng 3 hỏng).
- Ứng dụng đã có `TicketCubit` cung cấp ở phạm vi toàn cục (Global BlocProvider), có phương thức `loadLandlordTickets()` để lấy danh sách sự cố thật từ API và lưu trữ trong trạng thái `TicketLoaded`.

### Mục tiêu:
- Tự động gọi `loadLandlordTickets()` khi màn hình Vận hành (`LandlordOperationsScreen`) khởi chạy.
- Sử dụng `BlocBuilder<TicketCubit, TicketState>` để lắng nghe danh sách sự cố từ Cubit.
- Lọc các sự cố **đang chờ xử lý** (trạng thái là `TicketStatus.pending` hoặc `TicketStatus.inProgress`).
- Cập nhật số lượng sự cố đang chờ trên Badge đỏ.
- Hiển thị danh sách các sự cố đang chờ thật sự dưới dạng các thẻ `_IssueCard` động.
- Tính toán thời gian tạo sự cố một cách trực quan bằng tiếng Việt (ví dụ: "3 giờ trước", "Vừa xong", v.v.).
- Điều hướng mượt mà đến màn hình chi tiết sự cố `/landlord/operations/issue-detail` và truyền `Ticket` qua tham số `extra` tương ứng.

---

## 2. Kế hoạch chi tiết (Bite-sized Tasks)

### Task 1: Tự động tải danh sách sự cố khi màn hình Vận hành được mở [COMPLETED]
- **File cần chỉnh sửa:** `lib/features/landlord_dashboard/presentation/screens/landlord_operations_screen.dart`
- **Nội dung:** Trong phương thức `initState()` của `_LandlordOperationsScreenState`, gọi:
  ```dart
  context.read<TicketCubit>().loadLandlordTickets();
  ```

### Task 2: Định nghĩa hàm format thời gian tiện ích tiếng Việt `_formatTimeAgo` [COMPLETED]
- **File cần chỉnh sửa:** `lib/features/landlord_dashboard/presentation/screens/landlord_operations_screen.dart`
- **Nội dung:** Thêm hàm Helper `_formatTimeAgo(DateTime dateTime)` vào file hoặc trong lớp `_LandlordOperationsScreenState`:
  ```dart
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} ngày trước';
    } else {
      // Trả về định dạng ngày dd/MM/yyyy cơ bản
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    }
  }
  ```

### Task 3: Bọc phần Tiêu đề & Badge sự cố trong `BlocBuilder` [COMPLETED]
- **File cần chỉnh sửa:** `lib/features/landlord_dashboard/presentation/screens/landlord_operations_screen.dart`
- **Vị trí:** Dòng `~280-333`
- **Thay đổi:** Bọc SliverToBoxAdapter này trong `BlocBuilder<TicketCubit, TicketState>` để đếm số lượng ticket có trạng thái `pending` và `inProgress`. Hiển thị số lượng đó trên badge đỏ. Nếu số lượng bằng 0, ta có thể ẩn badge hoặc hiển thị số 0.

### Task 4: Bọc phần Danh sách sự cố trong `BlocBuilder` và tải động [COMPLETED]
- **File cần chỉnh sửa:** `lib/features/landlord_dashboard/presentation/screens/landlord_operations_screen.dart`
- **Vị trí:** Dòng `~335-361`
- **Thay đổi:** 
  - Thay thế phần `SliverPadding` tĩnh bằng `BlocBuilder<TicketCubit, TicketState>`.
  - Trong `builder`:
    - Nếu trạng thái là `TicketLoading`: Trả về một sliver loading widget (CircularProgressIndicator).
    - Nếu trạng thái là `TicketError`: Trả về sliver text thông báo lỗi.
    - Nếu trạng thái là `TicketLoaded` hoặc các trạng thái cập nhật thành công:
      - Lọc các ticket có `status == TicketStatus.pending || status == TicketStatus.inProgress`.
      - Nếu danh sách lọc rỗng: Trả về một `SliverToBoxAdapter` thông báo "Không có sự cố nào cần xử lý".
      - Nếu có dữ liệu: Sử dụng `SliverList` với `SliverChildBuilderDelegate` để tạo danh sách `_IssueCard` động.
      - Thiết lập `onTap: () => context.push('/landlord/operations/issue-detail', extra: ticket)`.

### Task 5: Cập nhật tài liệu & Tracking [COMPLETED]
- **Files:**
  - `docs/CHANGELOG.md`
  - `docs/plans/task.md`
- **Nội dung:** Ghi nhận thay đổi nghiệp vụ vận hành, sửa đổi mã nguồn và đánh dấu Task là hoàn thành.

---

## 3. Kế hoạch kiểm nghiệm (Verification Plan)

### Kiểm thử UI & Tương tác tĩnh (Static/Dynamic UI Checks):
1. Khi màn hình **Vận hành** mở lên, ứng dụng gửi request tải ticket. Có hiển thị spinner loading mượt mà không?
2. Badge số lượng trên tiêu đề có cập nhật đúng khớp với tổng số ticket đang hiển thị bên dưới không?
3. Các card `_IssueCard` có hiển thị đúng: Tên phòng (`roomName`), Vấn đề (`title`), Tên người thuê (`tenantName`), thời gian format bằng tiếng Việt (`timeAgo`) và tag "Khẩn" nếu là `urgent`/`high` priority không?
4. Click vào một card sự cố xem có điều hướng chính xác đến màn hình chi tiết `/landlord/operations/issue-detail` và hiển thị đúng thông tin của ticket đó không.

---
Tôi đã lập kế hoạch chi tiết, hãy phản hồi xác nhận để tôi có thể bắt đầu triển khai các bước tiếp theo ngay lập tức!
