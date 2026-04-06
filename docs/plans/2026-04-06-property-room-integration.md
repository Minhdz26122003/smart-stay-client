# Property & Room API Integration — Implementation Plan

> **For Antigravity:** REQUIRED WORKFLOW: Use `.agent/workflows/execute-plan.md` to execute this plan in single-flow mode.

**Goal:** Tích hợp API Property (Khu trọ) và Room (Phòng) vào màn hình `LandlordOperationsScreen` và `LandlordRoomsScreen` để hiển thị dữ liệu thật từ Server thay vì mock data.

**Architecture:** Tầng data giao tiếp qua `DioClient`. Các khối Cubit/BLoC quản lý trạng thái tải danh sách khu trọ và phòng. Giao diện thay thế dữ liệu hardcode bằng `BlocBuilder`.

**Tech Stack:** `flutter_bloc`, `dio`, `freezed`, `get_it`

---

## Ý Tưởng Thay Đổi Trên Giao Diện (Review Required)

> [!IMPORTANT]
> **Thiết kế UI cho Properties:** Hiện tại `LandlordOperationsScreen` đang nhóm chung tất cả trạng thái phòng. Chúng ta sẽ làm logic: 
> 1. Gọi API lấy danh sách **Properties** (Khu A, Khu B, ...).
> 2. Lấy khu trọ đầu tiên làm mặc định, hoặc tính tổng số lượng phòng trên tất cả các khu trọ để hiển thị widget "Trạng thái phòng" (Đang thuê, trống, bảo trì).
> 3. Trong `LandlordRoomsScreen`, cũng sẽ gọi API lấy danh sách phòng theo Property.

---

## Task 1: Định nghĩa Entities & Data Models cho Property

**Files:**
- Create: `lib/features/property/domain/entities/property.dart`
- Create: `lib/features/property/data/models/property_model.dart`

**Step 1: Viết PropertyModel & Entity (Dựa trên DB mockup)**

Thuộc tính: `id`, `name`, `addressStreet`, `addressWard`, `addressDistrict`, `addressCity`.

**Step 2: Commit**
```bash
git add lib/features/property/
git commit -m "feat: add Property entity and model"
```

---

## Task 2: Định nghĩa Entities & Data Models cho Room

**Files:**
- Create: `lib/features/room/domain/entities/room.dart`
- Create: `lib/features/room/data/models/room_model.dart`

**Step 1: Viết RoomModel & Entity**

Thuộc tính: `id`, `propertyId`, `name`, `type`, `basePrice`, `areaM2`, `status`, `maxOccupants`.
Status là số: 0 = Trống, 1 = Đang thuê, 2 = Bảo trì.

**Step 2: Commit**
```bash
git add lib/features/room/
git commit -m "feat: add Room entity and model"
```

---

## Task 3: Tạo Datasources & Repositories

**Files:**
- Create: `lib/features/property/data/datasources/property_remote_datasource.dart`
- Create: `lib/features/property/data/repositories/property_repository_impl.dart`
- Create: `lib/features/property/domain/repositories/property_repository.dart`
- Lặp lại tương tự cho `Room` (Endpoints: `/api/v1/properties` và `/api/v1/rooms/property/{propertyId}`)

**Step 1: Viết remote datasources dùng DioClient (kế thừa logic AppException)**

**Step 2: Viết repository implementations**

**Step 3: Commit**
```bash
git add lib/features/property/ lib/features/room/
git commit -m "feat: add properties and rooms remote datasources, repositories"
```

---

## Task 4: Khởi tạo DI (Dependency Injection)

**Files:**
- Modify: `lib/core/di/injection_container.dart`

**Step 1: Đăng ký Repositories & Datasources của Property và Room vào GetIt**

**Step 2: Commit**
```bash
git add lib/core/di/injection_container.dart
git commit -m "feat: register property and room di"
```

---

## Task 5: Tạo PropertyCubit & RoomCubit

**Files:**
- Create: `lib/features/property/presentation/cubit/property_cubit.dart`
- Create: `lib/features/room/presentation/cubit/room_cubit.dart`

**Step 1: Quản lý trạng thái**
- `PropertyCubit.loadProperties()`
- `RoomCubit.loadRooms(propertyId)`

**Step 2: Đăng ký Cubit lên GetIt và tiêm vào main.dart (MultiBlocProvider)**

**Step 3: Commit**
```bash
git add lib/features/property/presentation/ lib/features/room/presentation/ lib/main.dart lib/core/di/
git commit -m "feat: add property and room cubits"
```

---

## Task 6: Tích hợp vào LandlordOperationsScreen

**Files:**
- Modify: `lib/features/landlord_dashboard/presentation/screens/landlord_operations_screen.dart`

**Step 1: Wrap với BlocBuilder**
Chuyển hóa dữ liệu hardcode (Tổng 30 phòng, đang thuê 24, trống 4...) thành tính toán thực tế dựa trên số phòng trả về từ `RoomCubit` (được gọi sau khi nạp xong `Property`).

**Step 2: Cập nhật hàm tính toán thanh Progress**

**Step 3: Commit**
```bash
git add lib/features/landlord_dashboard/presentation/screens/landlord_operations_screen.dart
git commit -m "feat: integrate real room stats into operations screen"
```

---

## Task 7: Tích hợp vào LandlordRoomsScreen

**Files:**
- Modify: `lib/features/landlord_dashboard/presentation/screens/landlord_rooms_screen.dart`

**Step 1: Thay thế mock data `_rooms`**
Dùng dữ liệu danh sách `rooms` từ `RoomCubit` trong `BlocBuilder`.
Ánh xạ: 
- `status == 0` -> Trống (Cam)
- `status == 1` -> Đang thuê (Xanh lá)
- `status == 2` -> Bảo trì (Đỏ)

**Step 2: Commit**
```bash
git add lib/features/landlord_dashboard/presentation/screens/landlord_rooms_screen.dart
git commit -m "feat: display real rooms in room list screen"
```

---

## Verification Plan

- Chạy `flutter run`
- Đăng nhập bằng tài khoản Landlord (nếu đang lưu session thì vào thẳng Dashboard)
- Màn Operations: Hiện dữ liệu "Phòng thống kê" từ server.
- Bấm vào "Quản lý phòng": Hiện danh sách các phòng P.101, P.102, A01, A02 thật sự có trong DB mockdata.sql.
- Kiểm tra không xảy ra OverFlow hay Loading quay vô tận.
