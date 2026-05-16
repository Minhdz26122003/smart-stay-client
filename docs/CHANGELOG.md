# Changelog - Smart Stay

## [2026-05-16] - Feature
### Added
- Chức năng xóa Phòng (Room) và Khu trọ (Property).
- Tích hợp API delete trong RoomRemoteDataSource và PropertyRemoteDataSource.
- Cập nhật RoomDetailCubit và PropertyCubit để quản lý trạng thái xóa.
- Thêm nút xóa vào AppBar của LandlordRoomDetailScreen với hộp thoại xác nhận và ràng buộc (không xóa phòng đang thuê).
- Thêm tính năng nhấn giữ (Long press) vào các chip khu trọ ở Trang chủ để kích hoạt xóa khu trọ.
- Hiển thị phản hồi qua SnackBar (Loading, Success, Error).

## [2026-05-16] - UI Fix
### Fixed
- **LandlordRoomsScreen:** Xử lý lỗi overflow khi tên phòng quá dài bằng cách sử dụng Flexible và TextOverflow.ellipsis.

## [2026-05-15] - Refactor & Documentation
### Added
- Khởi tạo cấu trúc thư mục `docs/` (brief, BRD, plans, changelog).
- Thêm kế hoạch Master Plan cho các giai đoạn tiếp theo.

### Fixed
- **Ticket Model:** Chuyển đổi từ `int` sang `Native Enums` cho Category và Priority.
- **UI:** Sửa lỗi non-exhaustive switch trong màn hình chi tiết phòng của chủ nhà.
- **Serialization:** Loại bỏ các JsonConverter thủ công, thay bằng `@JsonValue` và `unknownEnumValue`.

### Refactored
- Cập nhật `TicketEntity` và `TicketModel` để đảm bảo an toàn kiểu dữ liệu.
- Làm sạch `ticket_extensions.dart`.
