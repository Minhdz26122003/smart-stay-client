# Smart Stay Client 🏠📱

Smart Stay Client là ứng dụng di động quản lý phòng trọ / căn hộ cho thuê, hỗ trợ cả hai vai trò: **Chủ trọ (Landlord)** và **Khách thuê (Tenant)**. Dự án được triển khai trên nền tảng Flutter với các tiêu chuẩn kiến trúc phần mềm nghiêm ngặt.

---

## 🛠 Công nghệ & Thư viện sử dụng

Dự án này sử dụng những công nghệ và pattern mới nhất dành cho Flutter, tuân thủ các quy định khắt khe về **Clean Architecture**:

- **Framework:** Flutter SDK `^3.11.0`
- **Quản lý trạng thái (State Management):** `flutter_bloc` (Sử dụng cả `Bloc` và `Cubit`)
- **Điều hướng (Routing):** `go_router` (Kết hợp `StatefulShellRoute` cho Botton Navigation)
- **Kiến trúc (Architecture):** Feature-first Clean Architecture
- **Dependency Injection:** `get_it`
- **Data Model & JSON:** `freezed`, `json_serializable`, `json_annotation`
- **Mạng (Networking):** `dio`, `pretty_dio_logger`
- **Bảo mật lưu trữ:** `flutter_secure_storage`
- **Lập trình hàm (Functional Programming):** `dartz`
- **So sánh đối tượng:** `equatable`

---

## 🏗 Kiến trúc thư mục (Clean Architecture - Feature First)

Toàn bộ ứng dụng được chia theo từng tính năng độc lập (Feature-based). Mỗi tính năng nằm trong `lib/features/{feature_name}/` và BẮT BUỘC có 3 tầng riêng biệt:

```text
lib/
├── core/
│   ├── routes/          # Cấu hình GoRouter (app_router.dart)
│   ├── theme/           # Cấu hình giao diện (ThemeExtension)
│   └── widgets/         # Components dùng chung UI toàn app
├── features/
│   ├── auth/            # Tính năng Xác thực (Đăng nhập, Đăng ký, OTP...)
│   ├── landlord_dashboard/ # Các màn hình dành cho Chủ trọ
│   ├── tenant_dashboard/   # Các màn hình dành cho Khách thuê
│   ├── room/            # Quản lý Phòng (vào data, domain)
│   ├── invoice/         # Quản lý Hóa đơn
│   ├── ticket/          # Hệ thống phản hồi / Báo lỗi
│   └── ...
```

### Chi tiết 3 tầng bên trong mỗi Feature:
1. **`data/`**: Chứa Repositories, Data Sources (API, Local Storage) và Models (Freezed Models + JSON serialization).
2. **`domain/`**: Chứa Entities và UseCases. Nơi lưu trữ logic nghiệp vụ cốt lõi không phụ thuộc vào UI hay external package.
3. **`presentation/`**: Chứa UI Widgets, Screens và BLoC/Cubit. Nhiệm vụ duy nhất là render UI và điều phối sự kiện. Không chứa logic nghiệp vụ thuần hoặc gọi API trực tiếp.

---

## 🚀 Các tính năng chính

### 🧑‍💼 Phân hệ Chủ trọ (Landlord)
Cấu trúc 5 tab tích hợp sâu vào hệ thống `StatefulShellRoute`:
1. **Trang chủ:** Thống kê tổng quan.
2. **Tài chính:** Quản lý hóa đơn thu/chi, chi tiết hóa đơn, xác nhận thanh toán.
3. **Vận hành:** 
   - Quản lý danh sách phòng, chi tiết phòng, đăng phòng mới.
   - Quản lý hợp đồng.
   - Quản lý sự cố bảo trì (`Issues / Tickets`).
   - Ghi chỉ số Điện/Nước hẹn giờ thực tế (`Meter Scan`).
   - Quản lý Tin đăng.
4. **Thông báo:** Quản lý Notification từ hệ thống.
5. **Hồ sơ:** Thông tin tài khoản chủ trọ.

### 🧑‍💻 Phân hệ Khách thuê (Tenant)
Cấu trúc 5 tab linh hoạt:
1. **Trang chủ:** Thông tin phòng đang thuê hiện tại.
2. **Hóa đơn:** Xem hóa đơn, lịch sử thanh toán hằng tháng.
3. **Dịch vụ hỗ trợ:** Báo cáo sự cố (`Report Issue`), yêu cầu bảo trì, xem trạng thái xử lý.
4. **Thông báo:** Thông báo nhắc lịch đóng tiền, thông báo từ chủ nhà.
5. **Hồ sơ:** Thông tin hợp đồng đang hiệu lực, thông tin cá nhân.

---

## 🚦 Quy định phát triển (Code Rules)

Khi tham gia phát triển dự án này, dev cần nắm bắt các quy tắc (Rules):
1. **State Management:** Cấm sử dụng `Provider`, `Riverpod`, hay `GetX`. Chỉ dùng `flutter_bloc`. Các trường hợp đơn giản dùng `Cubit`, phức tạp dùng `Bloc`. Tương tác UI bằng `BlocBuilder`, `BlocListener`, `BlocConsumer`.
2. **Routing:** Chỉ sử dụng `go_router`. Tuyệt đối không dùng `Navigator.push/pop` truyền thống. Hệ thống phân luồng phân quyền người dùng thông qua thuộc tính `redirect` của Router.
3. **Models:** Không bao giờ tự viết `fromJson/toJson`. Toàn bộ Model bắt buộc gen ra qua package `freezed` và `json_serializable`. Lệnh gen: `dart run build_runner build -d`.
4. **UI & Theme:** Không bao giờ Hardcode màu sắc. Đọc màu từ Theme hệ thống qua `Theme.of(context).extension<AppColors>()`.

---

## ⚙️ Hướng dẫn cài đặt & Khởi chạy

**1. Clone dự án và cài đặt Package**
```bash
flutter pub get
```

**2. Generate code (Freezed / JSON Serializable)**
Nếu có thay đổi Model, chạy lệnh:
```bash
dart run build_runner build --delete-conflicting-outputs
```

**3. Khởi chạy ứng dụng**
```bash
flutter run
```
