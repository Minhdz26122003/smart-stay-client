# Design Document - Chức năng Xóa Phòng và Khu trọ

## 1. Tổng quan (Overview)
Tài liệu này mô tả thiết kế cho chức năng xóa dữ liệu Phòng (Room) và Khu trọ (Property) dành cho ứng dụng Smart Stay phiên bản Landlord.

## 2. Mục tiêu (Objectives)
- Cho phép chủ nhà dọn dẹp các dữ liệu không còn sử dụng.
- Đảm bảo an toàn dữ liệu bằng cách ngăn chặn việc xóa các mục đang có ràng buộc nghiệp vụ (hợp đồng, người thuê).

## 3. Thiết kế chi tiết (Detailed Design)

### 3.1. Logic nghiệp vụ
- **Loại hình xóa:** Xóa vật lý (Hard Delete).
- **Ràng buộc (Constraints):**
    - **Phòng:** Chỉ được xóa khi trạng thái là `Available`. Nếu đang ở trạng thái `Occupied` hoặc có hợp đồng chờ xử lý, hệ thống sẽ ngăn chặn.
    - **Khu trọ:** Chỉ được xóa khi không còn phòng nào bên trong.
- **Kiểm tra (Validation):**
    - **Frontend:** Làm mờ hoặc hiển thị cảnh báo ngay trên nút xóa nếu trạng thái hiện tại không hợp lệ.
    - **Backend:** Thực hiện kiểm tra cuối cùng trước khi xóa bản ghi khỏi DB.

### 3.2. Giao diện người dùng (UI/UX)
- **Vị trí:** Biểu tượng thùng rác (Trash icon) trên thanh AppBar của màn hình Chi tiết Phòng/Khu trọ.
- **Luồng xác nhận:** Hiển thị `AlertDialog` xác nhận (Hủy / Xóa). Không yêu cầu nhập text xác nhận.
- **Phản hồi:** Sử dụng `SnackBar` thông báo kết quả và tự động `pop` về màn hình danh sách khi thành công.

### 3.3. Cấu trúc kỹ thuật
- **Data Layer:** Thêm phương thức `DELETE` vào `RoomRemoteDataSource` và `PropertyRemoteDataSource`.
- **Domain Layer:** Cập nhật Repository Interface và Implementation.
- **Presentation Layer:** Cập nhật BLoC/Cubit để quản lý trạng thái xóa (`loading`, `success`, `error`).

## 4. Kế hoạch triển khai (Implementation Plan)
Sẽ được chi tiết hóa trong file kế hoạch thực hiện riêng.
