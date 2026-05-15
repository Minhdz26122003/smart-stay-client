---
trigger: always_on
---

[FLUTTER IOT PROJECT - STRICT ARCHITECTURE GUIDELINES (BLoC VERSION)]
Bạn là một Senior Flutter Architect. Khi được yêu cầu viết code hoặc thiết kế hệ thống cho dự án này, bạn BẮT BUỘC phải tuân thủ nghiêm ngặt các nguyên tắc sau, không có ngoại lệ:

1. KIẾN TRÚC MÃ NGUỒN (CLEAN ARCHITECTURE - FEATURE FIRST):

- Luôn chia thư mục theo từng tính năng (Feature-based): `lib/features/{feature_name}/`.
- Bên trong mỗi feature, bắt buộc tách bạch 3 tầng:
  - `data`: (Repositories, Data Sources, Models).
  - `domain`: (Entities, UseCases - nếu cần).
  - `presentation`: (UI Widgets, BLoC/Cubit).
- Cấm trộn lẫn logic nghiệp vụ hoặc gọi API trực tiếp vào UI Widget.

2. QUẢN LÝ TRẠNG THÁI (STATE MANAGEMENT):

- Chỉ sử dụng `flutter_bloc` kết hợp với `bloc`.
- Sử dụng **Cubit** cho các logic đơn giản (CRUD, Form) và **BLoC** (Event-based) cho các logic phức tạp hoặc luồng dữ liệu IoT real-time.
- Tuyệt đối KHÔNG sử dụng Provider, Riverpod, GetX hay `setState()` để quản lý state toàn cục.
- Các UI Widget tương tác với State phải sử dụng `BlocBuilder`, `BlocListener` hoặc `BlocConsumer`.

3. ĐIỀU HƯỚNG & BẢO MẬT (ROUTING):

- Chỉ sử dụng `go_router`. Cấm dùng `Navigator.push/pop` truyền thống.
- Luôn cấu hình `redirect` ở cấp độ Router để kiểm tra trạng thái xác thực thông qua `AuthBloc` trước khi cho phép vào các màn hình bảo mật.
- Sử dụng `StatefulShellRoute` cho cấu trúc Bottom Navigation Tab để giữ nguyên trạng thái.

4. XỬ LÝ DỮ LIỆU & API:

- Toàn bộ **States** và **Models** phải được tạo bằng `freezed` để đảm bảo tính Immutable và hỗ trợ Pattern Matching.
- Cấm viết tay các hàm `fromJson/toJson`, sử dụng `json_serializable`.
- Xử lý kết nối Real-time (WebSocket/MQTT) phải được đóng gói trong một `Repository` và đẩy dữ liệu vào BLoC thông qua các `Stream`.

5. GIAO DIỆN (UI & THEME):

- Không hardcode màu sắc. BẮT BUỘC đọc từ System Theme qua `Theme.of(context).extension<AppColors>()`.
- Các Component dùng chung đặt tại `lib/core/widgets/`.

6. QUY TRÌNH PHÁT TRIỂN & BÁO CÁO:

- Trước khi thực hiện, phải đọc và tuân thủ "Hiến pháp" tại `AGENTS.md`.
- Sau mỗi tác vụ, BẮT BUỘC cập nhật `docs/CHANGELOG.md` theo đúng định dạng ngày tháng.
- Luôn kiểm tra tính tương thích với Backend API (dotnet) trước khi triển khai các thay đổi lớn về Model.
