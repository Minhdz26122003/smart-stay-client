## 📐 Step 1 Output — Phân tích thiết kế & Kế hoạch Component

### 🎨 Design System: "Harmonious Host"

| Token                | Giá trị                                                             |
| -------------------- | ------------------------------------------------------------------- |
| **Font Headlines**   | Be Vietnam Pro (Bold/Semibold)                                      |
| **Font Body/Labels** | Manrope (Regular/Medium)                                            |
| **Primary**          | `#00685f` (Deep Teal)                                               |
| **Secondary**        | `#855300` / Container `#fea619` (Warm Amber)                        |
| **Background**       | `#f8f9ff`                                                           |
| **Surface**          | `#ffffff`                                                           |
| **On Surface**       | `#121c2a` (KHÔNG dùng pure black `#000`)                            |
| **Border radius**    | `xl` = 24px/pill cho buttons, `lg` = 8px cho cards                  |
| **Elevation**        | Tonal layering + ambient shadow `0px 12px 32px rgba(18,28,42,0.06)` |

> **Quy tắc vàng "No-Line"** : Tuyệt đối không dùng 1px divider. Phân cách bằng `background shift` + `spacing gap`. **Glassmorphism** : Bottom Tab dùng `backdrop-filter: blur(20px)` với `surface` semi-transparent.

---

### 🗃️ Inventory màn hình visible trong Stitch project

#### 🔐 Auth / Onboarding (6 màn — không nhóm role)

| #   | Label            | Screen ID     |
| --- | ---------------- | ------------- |
| 1   | Welcome / Splash | `5b6637c1...` |
| 2   | Đăng nhập        | `712cfa9c...` |
| 3   | Đăng ký          | `90fb37bc...` |
| 4   | Quên mật khẩu    | `9fda350f...` |
| 5   | Xác nhận OTP     | `c5d154cb...` |
| 6   | Tạo mật khẩu mới | `a27019fc...` |

#### 🏠 Landlord / Chủ nhà (~17 màn visible)

| #   | Label                       | Screen ID     |
| --- | --------------------------- | ------------- |
| 1   | Trang Chủ Dashboard         | `5ef14361...` |
| 2   | Vận hành                    | `c2bbb98b...` |
| 3   | Tài chính                   | `7428f5d8...` |
| 4   | Cá nhân                     | `7c45227d...` |
| 5   | Thông báo                   | `9db9c500...` |
| 6   | Chốt Hóa Đơn Tháng          | `3909f379...` |
| 7   | Chi Tiết Phòng              | `35d03acb...` |
| 8   | Đăng Phòng Cho Thuê         | `1b60978b...` |
| 9   | Room Management List        | `8485696b...` |
| 10  | Giao diện Chụp Đồng hồ OCR  | `eff95db2...` |
| 11  | Tin nhắn & Lịch hẹn         | `cd40093c...` |
| 12  | Quản lý Đăng tin            | `b1d1a695...` |
| 13  | Quản lý Sự Cố               | `a762f223...` |
| 14  | Thông tin nhận tiền         | `063021ff...` |
| 15  | Phòng 301 - Cấu hình        | `0e324d60...` |
| 16  | Tạo HĐ - Thông tin chi tiết | `ea74a638...` |
| 17  | Bảng tin khu trọ            | `f5d1b699...` |

#### 🏡 Tenant / Người thuê (~11 màn visible)

| #   | Label                 | Screen ID      |
| --- | --------------------- | -------------- |
| 1   | Tenant Dashboard Home | `2a969e5e...`  |
| 2   | Thông Báo             | `2dc2f2c5...`  |
| 3   | Hóa Đơn               | `9331e304...`  |
| 4   | Chi tiết Hóa Đơn      | `9cd688f3...`  |
| 5   | Dịch Vụ               | `92fdef31...`  |
| 6   | Tài khoản             | `eea1dbe7...`  |
| 7   | Khai báo khách        | `16b9b4de...`  |
| 8   | Thủ tục trả phòng     | `0f33634b...`  |
| 9   | Chi tiết hợp đồng     | `1d0ae366...`  |
| 10  | Báo Sự Cố Mới         | `889eefa9...`  |
| 11  | Chi Tiết Sự Cố        | `b2b662653...` |

#### 👤 Seeker / Người tìm (~9 màn visible)

| #   | Label                        | Screen ID       |
| --- | ---------------------------- | --------------- |
| 1   | Khám Phá (Explore)           | `7bb9017e...`   |
| 2   | Chi tiết phòng (Room Detail) | `d31d85bd...`   |
| 3   | Bộ Lọc Nâng Cao              | `b29840cc...`   |
| 4   | Thông báo                    | `85f7dd7b...`   |
| 5   | Tài khoản                    | `ee92066598...` |
| 6   | Danh Sách Tin Nhắn           | `e2fb69cf...`   |
| 7   | Trò chuyện với Chủ nhà       | `9a98c10c...`   |
| 8   | Đặt Lịch Xem Phòng           | `03e8b556...`   |
| 9   | Lịch Hẹn Xem Phòng           | `175e1e1c...`   |

---

### 🏗️ Cấu trúc Component sẽ xây dựng

```text
lib/
├── core/
│   ├── network/
│   ├── error/
│   ├── theme/
│   └── widgets/
├── features/
│   ├── auth/
│   ├── landlord/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── blocs/
│   │       ├── pages/
│   │       └── widgets/
│   ├── tenant/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── marketplace/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── billing/
│   └── operations/
```

---

### ⚠️ Lưu ý UI/UX quan trọng trước khi code

| Hạng mục              | Quyết định                                                                      |
| --------------------- | ------------------------------------------------------------------------------- |
| **Touch Targets**     | Các Component luôn tối thiểu `minHeight: 48`                                    |
| **Typography Body**   | Dùng `Theme.of(context).textTheme` thay vì hardcode kích thước                  |
| **Dividers**          | KHÔNG dùng Divider 1px. Thay bằng `SizedBox` hoặc margin/padding                |
| **Primary CTA**       | Luôn ở vùng **thumb zone** (bottom fixed / bottomBar)                           |
| **Theme & Colors**    | Luôn map màu từ `Theme.of(context).extension<AppColors>()`                      |
| **State Management**  | Bắt buộc dùng `flutter_bloc`. Cubit cho UI ngắn hạn, BLoC cho logic phức tạp    |
| **Routing**           | Trợ giúp định tuyến qua `go_router`                                             |
| **Models**            | Dùng `freezed` + `json_serializable` cho data/domain models                     |

### Files chuẩn bị tạo

| File                               | Mô tả                                                        |
| ---------------------------------- | ------------------------------------------------------------ |
| `lib/core/theme/app_colors.dart`   | Chứa dữ liệu color extensions                                |
| `lib/core/theme/app_theme.dart`    | Config ThemeData(light, dark)                                |
| `lib/routes/app_router.dart`       | Cấu hình tất cả định tuyến bằng GoRouter                     |
| `lib/core/widgets/...`             | Các Global widget: CustomButton, CustomTextField...          |
