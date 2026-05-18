# Changelog - Smart Stay

## [2026-05-18] - UI & Image Load Fix
### Added
- **AppNetworkImage:** Tạo mới widget hiển thị hình ảnh từ mạng dùng chung cho toàn bộ ứng dụng, tích hợp logic định dạng và thay thế tự động hostname local (`storage.smartstay.local`, `localhost`, `127.0.0.1`) sang IP host của Backend để chạy được trên thiết bị di động thật và máy giả lập. Tích hợp shimmer loading và biểu tượng lỗi placeholder trang nhã để nâng cao trải nghiệm thẩm mỹ.

### Fixed
- **LandlordListingsScreen:** 
  - Tích hợp `AppNetworkImage` để sửa lỗi không load được ảnh tin đăng (SocketException).
  - Tăng khoảng đệm bên dưới (`bottom padding`) của danh sách tin đăng từ `16` lên `88` để tránh việc thẻ tin cuối cùng bị đè lên bởi nút FloatingActionButton "Đăng tin mới".

## [2026-05-16] - Feature
### Added
- Chuc nang xoa Phong (Room) va Khu tro (Property).
- Tich hop API delete trong RoomRemoteDataSource va PropertyRemoteDataSource.
- Cap nhat RoomDetailCubit va PropertyCubit de quan ly trang thai xoa.
- Them nut xoa vao AppBar cua LandlordRoomDetailScreen voi hop thoai xac nhan va rang buoc (khong xoa phong dang thue).
- Them tinh nang nhan giu (Long press) vao cac chip khu tro o Trang chu de kich hoat xoa khu tro.
- Hien thi phan hoi qua SnackBar (Loading, Success, Error).
- Hoan thien luong tao ticket cho tenant voi payload `propertyId`, `roomId`, `title`, `description`, `category`, `priority`.
- Cap nhat ticket sang trang thai `Pending`, `InProgress`, `Resolved`, `Cancelled`.
- Noi man hinh tenant services / report issue / issue detail voi du lieu ticket that va ho tro huy yeu cau khi ticket con `Pending`.
- Cap nhat landlord issues / issue detail de ho tro `Tiep nhan`, `Hoan tat`, `Huy` va reload danh sach sau khi doi trang thai.

## [2026-05-16] - UI Fix
### Fixed
- **LandlordRoomsScreen:** Xu ly loi overflow khi ten phong qua dai bang cach su dung Flexible va TextOverflow.ellipsis.

## [2026-05-15] - Refactor & Documentation
### Added
- Khoi tao cau truc thu muc `docs/` (brief, BRD, plans, changelog).
- Them ke hoach Master Plan cho cac giai doan tiep theo.

### Fixed
- **Ticket Model:** Chuyen doi tu `int` sang `Native Enums` cho Category va Priority.
- **UI:** Sua loi non-exhaustive switch trong man hinh chi tiet phong cua chu nha.
- **Serialization:** Loai bo cac JsonConverter thu cong, thay bang `@JsonValue` va `unknownEnumValue`.

### Refactored
- Cap nhat `TicketEntity` va `TicketModel` de dam bao an toan kieu du lieu.
- Lam sach `ticket_extensions.dart`.
