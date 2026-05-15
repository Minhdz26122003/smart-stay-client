# Business Requirements Document (BRD) - Smart Stay

## 1. Chân dung người dùng (User Personas)
### 1.1. Chủ nhà (Landlord)
- Quản lý danh sách phòng, hợp đồng, và danh sách người thuê.
- Theo dõi chỉ số điện nước và hóa đơn hàng tháng.
- Tiếp nhận và xử lý các yêu cầu bảo trì (Tickets).
- Theo dõi thông tin thiết bị IoT trong phòng.

### 1.2. Người thuê (Tenant)
- Xem thông tin phòng, hợp đồng và hóa đơn cá nhân.
- Gửi yêu cầu hỗ trợ/sửa chữa (Ticket).
- Điều khiển các thiết bị IoT được cấp quyền (khóa cửa, công tắc).

## 2. Các chức năng chính (Core Features)
- **Quản lý Listing:** Đăng tin cho thuê, quản lý trạng thái phòng.
- **Hệ thống Ticket:** Luồng xử lý sự cố từ lúc báo lỗi đến khi hoàn thành.
- **Tích hợp IoT:** Giao tiếp qua MQTT/WebSocket để lấy dữ liệu cảm biến và điều khiển thiết bị.
- **Hệ thống Hợp đồng & Hóa đơn:** Tự động hóa việc tính tiền phòng và dịch vụ.

## 3. Công nghệ quan trọng (Key Technologies)
- **Mobile:** Flutter (BLoC, Clean Architecture, GoRouter, Freezed).
- **Backend:** .NET 8 (Microservices, gRPC, YARP).
- **Infrastructure:** PostgreSQL, Redis, MinIO, MQTT Broker.

## 4. Do & Don't
### Do:
- Tuân thủ nghiêm ngặt Clean Architecture (Feature-first).
- Sử dụng Enums cho các trạng thái (Status, Priority, Category).
- Đảm bảo tính Immutable cho State và Model (Freezed).
### Don't:
- Hardcode màu sắc hoặc giá trị cấu hình (Sử dụng ThemeExtension và AppConfig).
- Gọi API trực tiếp trong UI (Bắt buộc qua Repository và BLoC).
