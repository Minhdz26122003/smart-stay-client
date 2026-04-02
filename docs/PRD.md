# TÀI LIỆU YÊU CẦU SẢN PHẨM (PRD)

## DỰ ÁN: RENTAL ROOM MANAGER (RRM)

| Thông tin        | Chi tiết                                                         |
| ---------------- | ---------------------------------------------------------------- |
| **Tên sản phẩm** | Rental Room Manager (RRM)                                        |
| **Phiên bản**    | 1.0                                                              |
| **Ngày tạo**     | 2026-03-19                                                       |
| **Tác giả**      | Minh Nguyen                                                      |
| **Trạng thái**   | Đang soạn thảo                                                   |
| **Công nghệ**    | Flutter (Frontend), .NET 9 (Backend), PostgreSQL (Database), SignalR, Firebase FCM |

---

## 1. GIỚI THIỆU SẢN PHẨM

### 1.1 Mô tả sản phẩm

RRM là ứng dụng di động đa vai trò (Super App) dành cho hệ sinh thái nhà trọ Việt Nam. Ứng dụng cung cấp nền tảng duy nhất cho **Chủ nhà quản lý vận hành**, **Người thuê theo dõi sinh hoạt phí** và **Người tìm phòng khám phá phòng trống**. Giao diện được tối ưu theo từng vai trò thông qua cơ chế **Role-based UI**.

### 1.2 Đối tượng người dùng (User Personas)

#### Persona 1: Anh Hùng — Chủ nhà trọ

- **Tuổi:** 45, sở hữu 2 khu trọ (tổng 30 phòng) tại TP.HCM.
- **Thói quen:** Dùng sổ tay ghi chép, chốt điện/nước cuối tháng mất 3 giờ, nhắn Zalo thu tiền.
- **Nỗi đau:** Quên thu tiền 2-3 phòng/tháng, tranh cãi cọc khi khách trả phòng, không biết khi nào HĐ hết hạn.
- **Mong muốn:** Một app "bấm 1 nút là xong" — chốt tiền, gửi bill, biết ai nợ.

#### Persona 2: Chị Linh — Người thuê trọ

- **Tuổi:** 26, nhân viên văn phòng, thuê phòng trọ quận Bình Thạnh.
- **Thói quen:** Nhận tin nhắn Zalo tiền phòng, chuyển khoản rồi chụp biên lai gửi lại.
- **Nỗi đau:** Không biết số điện cũ/mới bao nhiêu, vòi nước hỏng nhắn 3 ngày mới được sửa.
- **Mong muốn:** Biết rõ mình đang trả cho cái gì, báo hỏng 1 cái là chủ nhà biết ngay.

#### Persona 3: Em Khoa — Sinh viên tìm phòng

- **Tuổi:** 20, sinh viên năm 2 vừa chuyển trường, cần tìm trọ gần trường mới.
- **Thói quen:** Lướt Facebook group "Phòng trọ giá rẻ" — thấy quá nhiều bài trùng, ảnh cũ, gọi thì hết phòng.
- **Nỗi đau:** Mất 3 ngày đi xem 8 phòng, chỉ 2 cái đúng với ảnh đăng.
- **Mong muốn:** Xem được giá thật, ảnh thật, chat hỏi luôn, đặt lịch xem phòng cho tiện.

### 1.3 Vòng đời người dùng trên RRM (User Lifecycle)

```
Guest (Tìm phòng) ──→ Chốt thuê ──→ Tenant (Người thuê) ──→ Trả phòng ──→ Guest (Quay lại tìm)
                                           ↑
Landlord (Đăng tin) ───────────────────────┘ (Xác nhận HĐ)
```

---

## 2. YÊU CẦU CHỨC NĂNG (FUNCTIONAL REQUIREMENTS)

### 2.1 Module Xác Thực & Hồ Sơ Người Dùng (Auth & Profile)

| ID         | Yêu cầu                                                       | Vai trò          | Mức ưu tiên   |
| ---------- | ------------------------------------------------------------- | ---------------- | ------------- |
| FR-AUTH-01 | Đăng ký tài khoản bằng Số điện thoại + OTP                    | Tất cả           | P0 (Bắt buộc) |
| FR-AUTH-02 | Đăng nhập bằng SĐT + OTP hoặc mật khẩu                        | Tất cả           | P0            |
| FR-AUTH-03 | Chuyển đổi vai trò Chủ nhà ↔ Người thuê trên cùng 1 tài khoản | Tất cả           | P0            |
| FR-AUTH-04 | Cập nhật hồ sơ cá nhân: Tên, ảnh đại diện, số CCCD            | Tất cả           | P0            |
| FR-AUTH-05 | Chụp & lưu trữ ảnh CCCD 2 mặt (mã hóa)                        | Tenant, Landlord | P0            |
| FR-AUTH-06 | Đăng xuất / Xóa tài khoản theo GDPR-VN                        | Tất cả           | P1            |

---

### 2.2 Module Quản Lý Bất Động Sản (Property & Room Management)

| ID         | Yêu cầu                                                                                      | Vai trò  | Mức ưu tiên |
| ---------- | -------------------------------------------------------------------------------------------- | -------- | ----------- |
| FR-PROP-01 | Tạo/sửa/xóa Khu trọ (Property): Tên, địa chỉ, nội quy, tiện ích chung                        | Landlord | P0          |
| FR-PROP-02 | Tạo/sửa/xóa Phòng (Room): Tên, giá thuê cơ bản, loại phòng (VIP/Thường), diện tích           | Landlord | P0          |
| FR-PROP-03 | Quản lý trạng thái phòng: Trống / Đang thuê / Đang sửa / Giữ chỗ                             | Landlord | P0          |
| FR-PROP-04 | Dashboard tổng quan: Số phòng trống, đang thuê, tổng doanh thu tháng, tổng nợ                | Landlord | P0          |
| FR-PROP-05 | Thêm ảnh chụp phòng (Gallery) để sử dụng cho Marketplace                                     | Landlord | P1          |
| FR-PROP-06 | Cấu hình giá dịch vụ theo khu trọ: Giá điện/kWh, giá nước/m³, phí rác, phí wifi, phí quản lý | Landlord | P0          |
| FR-PROP-07 | Hỗ trợ cấu hình giá dịch vụ theo từng phòng riêng (ghi đè giá khu trọ)                       | Landlord | P1          |

---

### 2.3 Module Hợp Đồng & Bàn Giao Tài Sản (Contract & Inventory)

| ID        | Yêu cầu                                                                                | Vai trò          | Mức ưu tiên |
| --------- | -------------------------------------------------------------------------------------- | ---------------- | ----------- |
| FR-CTR-01 | Tạo hợp đồng thuê phòng: Phòng, Người thuê đại diện, Tiền cọc, Ngày bắt đầu/kết thúc   | Landlord         | P0          |
| FR-CTR-02 | Scan/Chụp ảnh bản cứng hợp đồng đã ký, lưu dạng ảnh/PDF                                | Landlord         | P0          |
| FR-CTR-03 | Người thuê xem được nội dung hợp đồng của mình mọi lúc trên app                        | Tenant           | P0          |
| FR-CTR-04 | Cảnh báo tự động khi hợp đồng sắp hết hạn (30 ngày trước)                              | Landlord         | P1          |
| FR-CTR-05 | Gia hạn hợp đồng: Cập nhật ngày kết thúc mới, giữ lại lịch sử HĐ cũ                    | Landlord         | P1          |
| FR-CTR-06 | Tạo biên bản bàn giao tài sản lúc nhận phòng: Danh sách thiết bị + Ảnh chụp tình trạng | Landlord         | P0          |
| FR-CTR-07 | Đối chiếu tài sản lúc trả phòng: So sánh tình trạng Check-in vs Check-out              | Landlord, Tenant | P1          |
| FR-CTR-08 | Thêm người ở ghép (Roommate): Tên, SĐT, ảnh CCCD (cần Landlord phê duyệt)              | Tenant           | P1          |

---

### 2.4 Module Kế Toán & Hóa Đơn (Billing & Invoice)

| ID         | Yêu cầu                                                                                  | Vai trò          | Mức ưu tiên |
| ---------- | ---------------------------------------------------------------------------------------- | ---------------- | ----------- |
| FR-BILL-01 | Nhập chỉ số điện/nước mới hàng tháng cho từng phòng                                      | Landlord         | P0          |
| FR-BILL-02 | Hệ thống tự động tính: Lượng tiêu thụ = Số mới - Số cũ tháng trước                       | Hệ thống         | P0          |
| FR-BILL-03 | OCR Camera: Chụp ảnh đồng hồ điện/nước → Tự động nhận dạng chỉ số                        | Landlord         | P2          |
| FR-BILL-04 | Tạo hóa đơn tự động: Tiền phòng + Điện + Nước + Dịch vụ phụ (Rác, Wifi, Quản lý...)      | Hệ thống         | P0          |
| FR-BILL-05 | Gửi thông báo (Push + In-app) cho Tenant khi có hóa đơn mới                              | Hệ thống         | P0          |
| FR-BILL-06 | Người thuê xem hóa đơn chi tiết: Số cũ/mới, đơn giá, thành tiền từng khoản               | Tenant           | P0          |
| FR-BILL-07 | Quản lý trạng thái thanh toán: "Chưa thu" / "Đã thu" / "Thu thiếu" (ghi nhận số tiền nợ) | Landlord         | P0          |
| FR-BILL-08 | Lịch sử hóa đơn: Xem lại tất cả hóa đơn các tháng trước                                  | Landlord, Tenant | P0          |
| FR-BILL-09 | Hiển thị mã QR chuyển khoản trên hóa đơn (theo thông tin ngân hàng của Landlord)         | Tenant           | P1          |
| FR-BILL-10 | Nhắc nợ tự động: Gửi notification nhắc thanh toán theo lịch cấu hình (VD: 3 ngày/lần)    | Hệ thống         | P1          |
| FR-BILL-11 | Hỗ trợ tính giá điện bậc thang (nếu Landlord cấu hình)                                   | Hệ thống         | P2          |
| FR-BILL-12 | Hỗ trợ tính phí theo đầu người (VD: phí rác 20k/người/tháng)                             | Hệ thống         | P1          |

---

### 2.5 Module Sàn Giao Dịch (Marketplace)

| ID        | Yêu cầu                                                                                  | Vai trò         | Mức ưu tiên |
| --------- | ---------------------------------------------------------------------------------------- | --------------- | ----------- |
| FR-MKT-01 | Đăng tin cho thuê phòng trống: Ảnh, giá, mô tả, tiện ích, cấu hình phí                   | Landlord        | P1          |
| FR-MKT-02 | Tìm kiếm phòng theo: Khu vực, Khoảng giá, Diện tích, Tiện ích                            | Guest           | P1          |
| FR-MKT-03 | Bộ lọc nâng cao: Có máy giặt, cho nuôi pet, có ban công, số người ở tối đa               | Guest           | P2          |
| FR-MKT-04 | Xem chi tiết phòng: Gallery ảnh, bản đồ, danh sách đầy đủ chi phí (thuê + dịch vụ + cọc) | Guest           | P1          |
| FR-MKT-05 | Lưu phòng vào danh sách "Yêu thích"                                                      | Guest           | P2          |
| FR-MKT-06 | Chat in-app giữa Guest và Landlord để hỏi thêm thông tin                                 | Guest, Landlord | P1          |
| FR-MKT-07 | Đặt lịch hẹn xem phòng: Chọn ngày/giờ, Landlord xác nhận/từ chối                         | Guest, Landlord | P2          |
| FR-MKT-08 | Tự động ẩn bài đăng khi phòng chuyển sang trạng thái "Đang thuê"                         | Hệ thống        | P1          |
| FR-MKT-09 | Gợi ý tự động đăng lại khi phòng trở về trạng thái "Trống"                               | Hệ thống        | P2          |

---

### 2.6 Module Vận Hành & Hỗ Trợ (Operations)

| ID        | Yêu cầu                                                                                 | Vai trò  | Mức ưu tiên |
| --------- | --------------------------------------------------------------------------------------- | -------- | ----------- |
| FR-OPS-01 | Người thuê tạo ticket sự cố: Tiêu đề, Mô tả, Ảnh đính kèm                               | Tenant   | P0          |
| FR-OPS-02 | Landlord cập nhật trạng thái ticket: "Đã tiếp nhận" → "Đang sửa" → "Hoàn tất"           | Landlord | P0          |
| FR-OPS-03 | Người thuê theo dõi tiến độ xử lý ticket real-time                                      | Tenant   | P0          |
| FR-OPS-04 | Bảng tin chung (Notice Board): Landlord đăng thông báo cho toàn khu trọ hoặc từng phòng | Landlord | P1          |
| FR-OPS-05 | Người thuê xem danh sách thông báo của khu trọ mình đang ở                              | Tenant   | P1          |
| FR-OPS-06 | Tạo khảo sát/bình chọn để lấy ý kiến cư dân (VD: "Có nên lắp thêm wifi 5GHz?")          | Landlord | P2          |
| FR-OPS-07 | Người thuê tham gia bình chọn/trả lời khảo sát                                          | Tenant   | P2          |

---

### 2.7 Module An Ninh & Kiểm Soát (Security & Access)

| ID        | Yêu cầu                                                                             | Vai trò  | Mức ưu tiên    |
| --------- | ----------------------------------------------------------------------------------- | -------- | -------------- |
| FR-SEC-01 | Người thuê khai báo khách ghé thăm: Tên, SĐT, thời gian đến/đi, ở qua đêm hay không | Tenant   | P2             |
| FR-SEC-02 | Landlord nhận thông báo khi có khai báo khách mới                                   | Landlord | P2             |
| FR-SEC-03 | Đăng ký biển số xe (xe máy/ô tô) kèm ảnh nhận dạng                                  | Tenant   | P2             |
| FR-SEC-04 | Nút báo động khẩn cấp SOS: Gửi alert đến Landlord + tất cả Tenant cùng khu trọ      | Tenant   | P2             |
| FR-SEC-05 | Nhật ký ra vào cá nhân (nếu tích hợp thiết bị IoT ở giai đoạn sau)                  | Tenant   | P3 (Tương lai) |

---

### 2.8 Module Quy Trình Trả Phòng (Check-out)

| ID       | Yêu cầu                                                                             | Vai trò          | Mức ưu tiên |
| -------- | ----------------------------------------------------------------------------------- | ---------------- | ----------- |
| FR-CO-01 | Khởi tạo quy trình trả phòng: Chốt số điện/nước cuối cùng                           | Landlord         | P1          |
| FR-CO-02 | Đối chiếu tài sản bàn giao: So sánh tình trạng ban đầu vs hiện tại                  | Landlord         | P1          |
| FR-CO-03 | Tính toán tiền cọc hoàn trả: Cọc ban đầu - Nợ - Hư hỏng tài sản                     | Hệ thống         | P1          |
| FR-CO-04 | Ghi nhận đánh giá 2 chiều: Tenant đánh giá Landlord & ngược lại (1-5 sao + comment) | Tenant, Landlord | P2          |
| FR-CO-05 | Chuyển đổi Tenant về trạng thái Guest sau khi hoàn tất trả phòng                    | Hệ thống         | P1          |

---

### 2.9 Module Hồ Sơ Cư Trú & Pháp Lý (Residency)

| ID        | Yêu cầu                                                                     | Vai trò  | Mức ưu tiên |
| --------- | --------------------------------------------------------------------------- | -------- | ----------- |
| FR-RES-01 | Quản lý danh sách cư dân đang ở từng phòng (HĐ chính + người ở ghép)        | Landlord | P0          |
| FR-RES-02 | Xuất danh sách cư trú ra PDF/Excel đúng form mẫu Công An (khai báo tạm trú) | Landlord | P1          |
| FR-RES-03 | Lưu trữ ảnh CCCD 2 mặt của tất cả cư dân (mã hóa AES-256)                   | Hệ thống | P0          |

---

## 3. YÊU CẦU PHI CHỨC NĂNG (NON-FUNCTIONAL REQUIREMENTS)

### 3.1 Hiệu năng (Performance)

| ID          | Yêu cầu                                     | Chỉ tiêu                          |
| ----------- | ------------------------------------------- | --------------------------------- |
| NFR-PERF-01 | Thời gian phản hồi API trung bình           | ≤ 500ms cho 95% requests          |
| NFR-PERF-02 | Thời gian đẩy thông báo real-time (SignalR) | ≤ 3 giây từ lúc trigger           |
| NFR-PERF-03 | Thời gian OCR nhận dạng chỉ số đồng hồ      | ≤ 5 giây / 1 ảnh                  |
| NFR-PERF-04 | App khởi động (cold start)                  | ≤ 3 giây trên thiết bị trung bình |

### 3.2 Bảo mật (Security)

| ID         | Yêu cầu                        | Chi tiết                                                              |
| ---------- | ------------------------------ | --------------------------------------------------------------------- |
| NFR-SEC-01 | Xác thực                       | JWT Bearer Token với refresh token rotation                           |
| NFR-SEC-02 | Mã hóa dữ liệu nhạy cảm (CCCD) | AES-256 encryption at rest                                            |
| NFR-SEC-03 | Truyền tải dữ liệu             | HTTPS/TLS 1.3 bắt buộc (encryption in transit)                        |
| NFR-SEC-04 | Phân quyền                     | Role-based Access Control (RBAC) — Tenant chỉ thấy dữ liệu phòng mình |
| NFR-SEC-05 | Tuân thủ pháp luật             | Nghị định 13/2023/NĐ-CP về bảo vệ dữ liệu cá nhân                     |

### 3.3 Khả năng mở rộng (Scalability)

| ID           | Yêu cầu          | Chi tiết                                                |
| ------------ | ---------------- | ------------------------------------------------------- |
| NFR-SCALE-01 | Hỗ trợ đồng thời | ≥ 1,000 người dùng online cùng lúc (giai đoạn MVP)      |
| NFR-SCALE-02 | Cơ sở dữ liệu    | Thiết kế schema tối ưu cho multi-tenant (nhiều khu trọ) |

### 3.4 Tương thích (Compatibility)

| ID            | Yêu cầu  | Chi tiết                                                                   |
| ------------- | -------- | -------------------------------------------------------------------------- |
| NFR-COMPAT-01 | Android  | Hỗ trợ Android ≥ 8.0 (API 26)                                              |
| NFR-COMPAT-02 | iOS      | Hỗ trợ iOS ≥ 14.0                                                          |
| NFR-COMPAT-03 | Ngôn ngữ | Tiếng Việt là ngôn ngữ mặc định, hỗ trợ i18n cho Tiếng Anh (giai đoạn sau) |

### 3.5 Trải nghiệm người dùng (UX)

| ID        | Yêu cầu       | Chi tiết                                                            |
| --------- | ------------- | ------------------------------------------------------------------- |
| NFR-UX-01 | Onboarding    | Hướng dẫn từng bước cho người dùng mới (đặc biệt Landlord lớn tuổi) |
| NFR-UX-02 | Offline-first | Cho phép xem hóa đơn, hợp đồng đã tải về khi không có mạng          |
| NFR-UX-03 | Responsive    | Giao diện tối ưu cho cả phone và tablet                             |

---

## 4. KIẾN TRÚC KỸ THUẬT CAO CẤP (HIGH-LEVEL ARCHITECTURE)

### 4.1 Sơ đồ kiến trúc tổng quan

```
┌──────────────────────────────────────────────────────────┐
│                      FLUTTER APP                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────────┐   │
│  │ Landlord │  │  Tenant  │  │  Guest/Marketplace   │   │
│  │ Features │  │ Features │  │       Features       │   │
│  └────┬─────┘  └────┬─────┘  └──────────┬───────────┘   │
│       └──────────────┼──────────────────┘                │
│                      │                                   │
│          ┌───────────┴───────────┐                       │
│          │   State Management    │                       │
│          │    (flutter_bloc)     │                       │
│          └───────────┬───────────┘                       │
└──────────────────────┼───────────────────────────────────┘
                       │ HTTPS + SignalR (WSS)
┌──────────────────────┼───────────────────────────────────┐
│                .NET 9 BACKEND                            │
│  ┌───────────────────┴───────────────────┐               │
│  │           API Gateway / Controllers   │               │
│  └───┬──────────┬──────────┬─────────┬───┘               │
│      │          │          │         │                   │
│  ┌───┴───┐ ┌───┴───┐ ┌───┴───┐ ┌───┴────┐              │
│  │Billing│ │Contract││  OCR  │ │  Chat  │              │
│  │Engine │ │Service ││Engine │ │Service │              │
│  └───────┘ └───────┘ └───────┘ └────────┘              │
│                                                          │
│  ┌──────────────────────────────────────┐                │
│  │            SignalR Hubs              │                │
│  │ BillingHub │ OperationHub │ AlertHub │                │
│  └──────────────────────────────────────┘                │
│                                                          │
│  ┌──────────────────────────────────────┐                │
│  │     Background Workers (Hangfire)    │                │
│  │ Nhắc nợ │ Cảnh báo HĐ │ Auto-hide    │                │
│  └──────────────────────────────────────┘                │
└──────────────────────┬───────────────────────────────────┘
                       │
┌──────────────────────┼───────────────────────────────────┐
│              DATA LAYER                                  │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐   │
│  │ PostgreSQL  │  │ Blob Storage │  │  Firebase    │   │
│  │ (Main DB)   │  │ (Images/PDF) │  │  (FCM/Auth)  │   │
│  └─────────────┘  └──────────────┘  └──────────────┘   │
└──────────────────────────────────────────────────────────┘
```

### 4.2 Mô hình dữ liệu (Data Model)

| Bảng (Entity)     | Các trường chính                                                     | Mô tả                              |
| ----------------- | -------------------------------------------------------------------- | ---------------------------------- |
| **User**          | ID, Name, Phone, Email, Role[], FCM_Token, CCCD_Photos               | Người dùng (có thể giữ nhiều Role) |
| **Property**      | ID, LandlordID, Name, Address, Rules, SharedAmenities                | Khu nhà trọ / chung cư mini        |
| **Room**          | ID, PropertyID, Name, Type, BasePrice, Area_m2, Status               | Phòng trong khu trọ                |
| **Contract**      | ID, RoomID, TenantID, DepositAmount, Start, End, Status              | Hợp đồng thuê phòng                |
| **Inventory**     | ID, ContractID, ItemName, CheckIn_Photos, CheckOut_Photos, Condition | Thiết bị bàn giao                  |
| **ServiceConfig** | ID, PropertyID, RoomID(nullable), Type, UnitPrice, CalcMethod        | Cấu hình giá dịch vụ               |
| **MeterReading**  | ID, RoomID, Type(E/W), OldUnit, NewUnit, Photo_OCR, Month, Year      | Chỉ số đồng hồ                     |
| **Invoice**       | ID, RoomID, ContractID, TotalAmount, Details_JSON, Status, CreatedAt | Hóa đơn thanh toán                 |
| **Ticket**        | ID, RoomID, TenantID, Title, Description, Photos, Status, Priority   | Phiếu báo sự cố                    |
| **Listing**       | ID, RoomID, Photos, Description, IsActive, CreatedAt                 | Tin đăng trên Marketplace          |
| **Booking**       | ID, ListingID, GuestID, ProposedDate, Status                         | Lịch hẹn xem phòng                 |
| **ChatMessage**   | ID, ConversationID, SenderID, Content, Timestamp                     | Tin nhắn chat                      |
| **Review**        | ID, ReviewerID, RevieweeID, ContractID, Rating, Comment              | Đánh giá 2 chiều                   |
| **Vehicle**       | ID, TenantID, PlateNumber, VehicleType, Photo                        | Xe đăng ký                         |
| **VisitorLog**    | ID, TenantID, VisitorName, Phone, Purpose, StayOvernight, DateTime   | Khai báo khách ghé                 |
| **Announcement**  | ID, PropertyID, RoomID(nullable), Title, Content, CreatedAt          | Thông báo khu trọ                  |
| **Poll**          | ID, PropertyID, Question, Options_JSON, Deadline                     | Khảo sát ý kiến                    |

---

## 5. LUỒNG NGHIỆP VỤ CHÍNH (KEY USER FLOWS)

### 5.1 Luồng 1: Chủ nhà — Chốt hóa đơn cuối tháng

```
1. Landlord mở app → Chọn Khu trọ → Bấm "Chốt hóa đơn tháng"
2. Danh sách phòng hiện ra với ô nhập "Chỉ số mới" Điện & Nước
3. (Tuỳ chọn) Bấm icon Camera → Chụp ảnh đồng hồ → OCR tự động điền số
4. Hệ thống tính:
   - Điện tiêu thụ = Số mới - Số cũ (tháng trước) → × Đơn giá
   - Nước tiêu thụ = Số mới - Số cũ (tháng trước) → × Đơn giá
   - Phí dịch vụ = Tổng (Rác + Wifi + Quản lý + ...) theo cấu hình
   - TỔNG = Tiền phòng + Điện + Nước + Dịch vụ
5. Landlord xem preview → Bấm "Xác nhận & Gửi hóa đơn"
6. Hệ thống:
   - Lưu MeterReading + Invoice vào DB
   - Push notification + In-app alert đến Tenant qua SignalR
7. Tenant mở app → Xem hóa đơn chi tiết → Quét QR chuyển khoản
8. Landlord đánh dấu "Đã thu" khi nhận được tiền
```

### 5.2 Luồng 2: Người tìm phòng — Từ tìm kiếm đến ký hợp đồng

```
1. Guest mở app → Vào tab "Tìm phòng" (Marketplace)
2. Lọc theo Khu vực "Quận Bình Thạnh" + Giá "2-4 triệu" + "Có máy giặt"
3. Xem kết quả → Bấm vào phòng ưng ý → Xem Gallery + Chi phí đầy đủ + Reviews
4. Bấm "Chat với chủ nhà" hoặc "Đặt lịch xem phòng"
5. Landlord nhận notification → Phản hồi chat/Xác nhận lịch
6. Guest đi xem phòng thực tế → Đồng ý thuê
7. Landlord tạo Hợp đồng trên app + Biên bản bàn giao tài sản
8. Guest xác nhận trên app → Hệ thống chuyển vai trò thành Tenant
9. Bài đăng phòng tự động ẩn khỏi Marketplace
```

### 5.3 Luồng 3: Người thuê — Báo sự cố

```
1. Tenant mở app → Bấm "Báo sự cố" (hoặc icon + trên Dashboard)
2. Chọn loại sự cố: Điện / Nước / Thiết bị / Khác
3. Mô tả vấn đề + Chụp ảnh minh họa
4. Bấm "Gửi" → Ticket được tạo, trạng thái "Chờ xử lý"
5. Landlord nhận notification → Mở ticket → Cập nhật "Đã tiếp nhận"
6. Landlord liên hệ thợ → Cập nhật "Đang sửa" (có thể ghi chú ngày hẹn)
7. Thợ sửa xong → Landlord cập nhật "Hoàn tất"
8. Tenant nhận notification xác nhận sự cố đã được xử lý
```

### 5.4 Luồng 4: Trả phòng (Check-out)

```
1. Landlord khởi tạo "Trả phòng" cho phòng cụ thể
2. Hệ thống chốt số điện/nước cuối cùng, tạo hóa đơn tháng cuối
3. Landlord kiểm tra tài sản bàn giao:
   - So sánh ảnh Check-in vs ảnh hiện tại
   - Ghi nhận hư hỏng (nếu có) kèm mức phí khấu trừ
4. Hệ thống tính: Cọc hoàn trả = Tiền cọc ban đầu - Nợ còn lại - Phí hư hỏng
5. Landlord & Tenant cùng xác nhận số tiền
6. (Tùy chọn) Cả hai bên để lại đánh giá 1-5 sao + nhận xét
7. Hệ thống:
   - Chuyển Tenant → Guest
   - Phòng → Trạng thái "Trống"
   - Gợi ý Landlord đăng lại bài trên Marketplace
```

---

## 6. THIẾT KẾ GIAO DIỆN TỔNG QUAN (UI WIREFRAME OVERVIEW)

### 6.1 Cấu trúc điều hướng theo vai trò

**Guest (Người tìm phòng):**

```
Bottom Tab: [🏠 Trang chủ] [🔍 Tìm phòng] [❤️ Yêu thích] [💬 Tin nhắn] [👤 Tài khoản]
```

**Tenant (Người thuê):**

```
Bottom Tab: [🏠 Dashboard] [📄 Hóa đơn] [🔧 Sự cố] [📢 Bảng tin] [👤 Tài khoản]
```

**Landlord (Chủ nhà):**

```
Bottom Tab: [📊 Tổng quan] [🏘️ Khu trọ] [💰 Thu chi] [📋 Vận hành] [👤 Tài khoản]
```

### 6.2 Các màn hình trọng tâm

| #   | Màn hình               | Vai trò         | Mô tả                                                                          |
| --- | ---------------------- | --------------- | ------------------------------------------------------------------------------ |
| 1   | Dashboard Landlord     | Landlord        | Tổng quan: Phòng trống/đang thuê, Doanh thu tháng, Nợ phải thu, HĐ sắp hết hạn |
| 2   | Dashboard Tenant       | Tenant          | Hóa đơn mới nhất, Trạng thái ticket, Thông báo gần đây                         |
| 3   | Marketplace Feed       | Guest           | Danh sách phòng dạng card kèm ảnh, giá, vị trí, đánh giá                       |
| 4   | Room Detail            | Guest           | Gallery ảnh, bảng chi phí đầy đủ, bản đồ, reviews, nút Chat/Đặt lịch           |
| 5   | Billing - Chốt hoá đơn | Landlord        | Danh sách phòng với ô nhập chỉ số + nút chụp OCR                               |
| 6   | Invoice Detail         | Tenant          | Bảng chi tiết từng khoản + QR thanh toán                                       |
| 7   | Ticket List & Detail   | Tenant/Landlord | Danh sách sự cố + Timeline trạng thái                                          |
| 8   | Contract View          | Tenant          | Xem HĐ đã scan + Thông tin biên bản bàn giao                                   |

---

## 7. MỨC ƯU TIÊN TRIỂN KHAI (PRIORITIZATION)

### 7.1 Bảng phân loại ưu tiên

| Mức                   | Mô tả                                        | Tổng số tính năng |
| --------------------- | -------------------------------------------- | ----------------- |
| **P0 (Must-have)**    | Thiếu thì app không hoạt động được           | 20                |
| **P1 (Should-have)**  | Quan trọng nhưng có thể chờ 1-2 sprint       | 16                |
| **P2 (Nice-to-have)** | Nâng cao trải nghiệm, làm sau MVP            | 12                |
| **P3 (Future)**       | Kế hoạch dài hạn, phụ thuộc yếu tố bên ngoài | 2                 |

### 7.2 Kế hoạch phân giai đoạn

| Giai đoạn  | Thời gian  | Modules                                                              | Mức ưu tiên |
| ---------- | ---------- | -------------------------------------------------------------------- | ----------- |
| **MVP**    | Tháng 1-4  | Auth, Property/Room, Contract/Inventory, Billing (cơ bản), Ticketing | P0          |
| **Growth** | Tháng 5-7  | Marketplace, Chat, Reviews, OCR, Smart Dunning, Check-out            | P1 + P2     |
| **Scale**  | Tháng 8-10 | Security/Access, Polls, Payment Gateway, Web Admin, i18n             | P2 + P3     |

---

## 8. TIÊU CHÍ CHẤP NHẬN SẢN PHẨM (ACCEPTANCE CRITERIA)

### 8.1 Giai đoạn MVP

| ID    | Tiêu chí                                                                      | Kết quả mong đợi                               |
| ----- | ----------------------------------------------------------------------------- | ---------------------------------------------- |
| AC-01 | Đăng ký thành công bằng SĐT + OTP                                             | Tài khoản được tạo, token JWT trả về           |
| AC-02 | Tạo khu trọ + 5 phòng + cấu hình giá dịch vụ                                  | Dữ liệu lưu đúng, Dashboard hiển thị chính xác |
| AC-03 | Nhập chỉ số điện/nước → Tạo hóa đơn → Push notification                       | Tenant nhận thông báo ≤ 5 giây                 |
| AC-04 | Hóa đơn hiển thị chi tiết: Số cũ, số mới, lượng tiêu thụ, đơn giá, thành tiền | Tất cả giá trị tính toán chính xác             |
| AC-05 | Tạo ticket sự cố kèm ảnh → Landlord thấy trong danh sách                      | Ticket hiển thị đúng thông tin + ảnh           |
| AC-06 | Landlord cập nhật trạng thái ticket → Tenant nhận real-time update            | Trạng thái cập nhật ≤ 3 giây                   |
| AC-07 | Tạo hợp đồng + Biên bản bàn giao → Tenant xem được trên app                   | Dữ liệu hiển thị chính xác, ảnh tải nhanh      |
| AC-08 | CCCD được mã hóa lưu trữ, không truy cập được trực tiếp từ Storage            | Kiểm tra bảo mật pass                          |

---

_Phiên bản: 1.0 — Tài liệu này sẽ được cập nhật theo từng sprint và khi có thay đổi về yêu cầu sản phẩm._
