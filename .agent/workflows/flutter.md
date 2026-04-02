---
description: Xây dựng Tính năng Flutter (Feature Development)
---

---

## description: Xây dựng Tính năng Flutter với BLoC (Feature Development)

**Mô tả:** Quy trình chuẩn mực để phát triển một tính năng mới trên ứng dụng Flutter IoT, sử dụng BLoC và Clean Architecture.
**Điều kiện kích hoạt:** Khi người dùng yêu cầu "Tạo màn hình...", "Làm tính năng...", "Tích hợp API...".

## Giai đoạn 1: Phân tích Kiến trúc & Trạng thái

**[Skill kích hoạt: `flutter-architecting-apps`, `bloc-state-management`]**

1. **Cấu trúc thư mục:** Tạo `lib/features/{tên_tính_năng}` với 3 tầng: `data`, `domain`, `presentation`.
2. **Thiết kế State (Freezed):** Tạo file `{feature}_state.dart` bằng `freezed`. Xác định các trạng thái: `initial`, `loading`, `success`, `failure`.
3. **Khai báo BLoC/Cubit:** - Nếu là Event-driven (IoT sensor data): Tạo `Bloc` với các `Event`.
   - Nếu là Logic đơn giản: Tạo `Cubit`.
4. **Data Layer:** Tạo Repository và DataModel (sử dụng `freezed` + `json_serializable`).

## Giai đoạn 2: Xây dựng Giao diện (Presentation)

**[Skill kích hoạt: `flutter-building-layouts`, `flutter-theming-apps`]**

1. **Lắp ráp UI:** Tạo màn hình (Stateless hoặc Stateful).
2. **Cung cấp State:** Sử dụng `BlocProvider` để inject BLoC vào đúng phạm vi (scope) cần thiết.
3. **Tiêu thụ State:** - Dùng `BlocBuilder` để render UI dựa trên state.
   - Dùng `BlocListener` để xử lý các side-effects (hiển thị Dialog, Snackbar, chuyển màn hình).
4. **Áp dụng Theme:** Đọc styling từ `Theme.of(context).extension<AppColors>()`.

## Giai đoạn 3: Điều hướng & Kết nối

**[Skill kích hoạt: `flutter-implementing-navigation-and-routing`]**

1. **Khai báo Route:** Bổ sung path vào `app_router.dart`.
2. **Bảo mật:** Sử dụng `context.read<AuthBloc>().state` trong logic `redirect` của `go_router` để chặn truy cập trái phép.
3. **Luồng dữ liệu:** - Trigger event/method từ UI: `context.read<MyBloc>().add(MyEvent())`.
   - UI tự động cập nhật khi BLoC `emit` state mới.

## Quy định đầu ra:

- Luôn nhắc người dùng chạy `dart run build_runner build -d` để sinh code cho `freezed` và `json_serializable`.
- Code mẫu phải bao gồm đầy đủ: `State` class (freezed), `Bloc/Cubit` class và đoạn mã `BlocProvider/BlocBuilder` trong UI.
