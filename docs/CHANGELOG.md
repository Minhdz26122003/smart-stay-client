# Changelog - Smart Stay

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
