# TÀI LIỆU YÊU CẦU KINH DOANH (BRD)
## DỰ ÁN: RENTAL ROOM MANAGER (RRM)

| Thông tin | Chi tiết |
|-----------|----------|
| **Tên dự án** | Rental Room Manager (RRM) |
| **Phiên bản** | 1.0 |
| **Ngày tạo** | 2026-03-19 |
| **Tác giả** | Minh Nguyen |
| **Trạng thái** | Đang soạn thảo |

---

## 1. TÓM TẮT ĐIỀU HÀNH (EXECUTIVE SUMMARY)

### 1.1 Bối cảnh
Thị trường nhà trọ/chung cư mini tại Việt Nam hiện đang được vận hành rất thủ công. Phần lớn chủ nhà trọ sử dụng sổ tay giấy, bảng tính Excel hoặc các nhóm Zalo/Facebook để quản lý phòng, thu tiền và liên lạc với người thuê. Điều này dẫn đến:
- Sai sót trong tính toán hóa đơn điện nước.
- Xung đột và tranh cãi về tiền cọc, tài sản bàn giao.
- Mất thời gian quản lý hồ sơ cư trú (khai báo tạm trú).
- Khó khăn trong việc tìm kiếm khách thuê mới khi có phòng trống.

Về phía người thuê, họ thiếu sự minh bạch trong hóa đơn, gặp khó khăn khi báo cáo sự cố, và không có kênh giao tiếp chính thức với chủ nhà. Về phía người tìm phòng, họ phải lướt qua hàng trăm bài viết trên mạng xã hội với thông tin không đáng tin cậy và hình ảnh không thực tế.

### 1.2 Tầm nhìn sản phẩm
RRM là một **Siêu ứng dụng di động (Super App)** duy nhất phục vụ cả 3 nhóm đối tượng: **Chủ nhà**, **Người thuê** và **Người tìm phòng**, với giao diện thay đổi theo vai trò (Role-based UI). Ứng dụng số hóa toàn bộ vòng đời cho thuê — từ đăng tin, tìm phòng, ký hợp đồng, thanh toán hàng tháng, cho đến trả phòng và đánh giá.

### 1.3 Mục tiêu kinh doanh cốt lõi

| # | Mục tiêu | Chỉ số đo lường (KPI) |
|---|----------|----------------------|
| 1 | Giảm thời gian vận hành cho chủ nhà | Giảm ≥ 70% thời gian chốt hóa đơn hàng tháng so với làm tay |
| 2 | Tăng tỷ lệ lấp đầy phòng trống | Giảm ≥ 50% thời gian phòng trống trung bình nhờ Marketplace |
| 3 | Nâng cao sự minh bạch tài chính | 100% hóa đơn có chi tiết từng khoản mục để người thuê kiểm chứng |
| 4 | Số hóa hồ sơ pháp lý | 100% hợp đồng và CCCD được lưu trữ điện tử, xuất được form tạm trú |
| 5 | Xây dựng cộng đồng cho thuê văn minh | Hệ thống đánh giá 2 chiều (Chủ nhà ↔ Người thuê) |

---

## 2. CÁC BÊN LIÊN QUAN (STAKEHOLDERS)

| Vai trò | Mô tả | Nhu cầu chính |
|---------|--------|---------------|
| **Chủ nhà (Landlord)** | Sở hữu/quản lý 1 hoặc nhiều khu nhà trọ, chung cư mini | Quản lý phòng, tính tiền tự động, theo dõi công nợ, đăng tin cho thuê |
| **Người thuê (Tenant)** | Đang ở trọ, có hợp đồng thuê phòng đang hiệu lực | Xem hóa đơn minh bạch, báo sự cố, xem hợp đồng, thanh toán tiện lợi |
| **Người tìm phòng (Guest/Seeker)** | Đang tìm kiếm phòng trọ phù hợp | Tìm phòng theo tiêu chí, xem thông tin chân thực, liên hệ chủ nhà nhanh |
| **Quản trị hệ thống (Admin)** | Đội ngũ vận hành nền tảng RRM | Kiểm duyệt nội dung, xử lý khiếu nại, quản lý tài khoản |

---

## 3. PHÂN TÍCH VẤN ĐỀ THEO CHỦ THỂ (PROBLEM ANALYSIS)

### 3.1 Chủ nhà (Landlord) — Vấn đề hiện tại

| # | Vấn đề (Pain Point) | Hậu quả | Giải pháp RRM đề xuất |
|---|---------------------|----------|----------------------|
| P1 | Ghi chép sổ sách thủ công, dễ nhầm lẫn | Thất thoát tài chính, mất uy tín | Hệ thống tài chính tự động với Billing Engine |
| P2 | Mất nhiều thời gian đi chốt số điện/nước từng phòng | Tốn 2-4 giờ mỗi tháng cho 20 phòng | OCR chụp ảnh đồng hồ tự động nhận dạng chỉ số |
| P3 | Không kiểm soát được danh sách người thuê | Không biết ai nợ, ai sắp hết HĐ | Dashboard tổng quan + hệ thống cảnh báo tự động |
| P4 | Hồ sơ CCCD/tạm trú lộn xộn trên Zalo | Mất thời gian lục tìm khi công an yêu cầu | Kho lưu trữ CCCD tập trung, xuất form tạm trú 1 click |
| P5 | Quản lý tài sản bàn giao kém | Tranh cãi tiền cọc khi trả phòng | Biên bản bàn giao điện tử kèm ảnh minh chứng |
| P6 | Khó tìm khách mới lấp phòng trống | Phòng trống = mất tiền hàng tháng | Sàn giao dịch Marketplace tích hợp sẵn |

### 3.2 Người thuê (Tenant) — Vấn đề hiện tại

| # | Vấn đề (Pain Point) | Hậu quả | Giải pháp RRM đề xuất |
|---|---------------------|----------|----------------------|
| P7 | "Sốc" hóa đơn, không kiểm chứng được số liệu | Mất niềm tin với chủ nhà | Hóa đơn điện tử chi tiết: Số cũ/mới, đơn giá từng khoản |
| P8 | Báo sự cố qua tin nhắn bị "trôi" | Đồ hỏng không được sửa kịp thời | Hệ thống Ticket sự cố có trạng thái theo dõi |
| P9 | Không nhớ điều khoản hợp đồng | Bị bất lợi khi phát sinh tranh chấp | Lưu trữ hợp đồng điện tử xem được mọi lúc |
| P10 | Thanh toán thủ công, chụp ủy nhiệm chi | Phiền phức, dễ nhầm | Tích hợp mã QR thanh toán + xác nhận tự động |

### 3.3 Người tìm phòng (Guest/Seeker) — Vấn đề hiện tại

| # | Vấn đề (Pain Point) | Hậu quả | Giải pháp RRM đề xuất |
|---|---------------------|----------|----------------------|
| P11 | Ảnh quảng cáo khác thực tế | Mất thời gian đi xem, thất vọng | Hình ảnh xác thực + hệ thống Review từ người thuê cũ |
| P12 | Phụ phí mập mờ (điện 5k/số, phí rác cao) | Bị "lừa" bởi giá thuê rẻ ban đầu | Hiển thị đầy đủ mọi chi phí ngay trên bài đăng |
| P13 | Tìm phòng trên Facebook lộn xộn, bị spam | Tốn thời gian sàng lọc thông tin | Sàn giao dịch chuyên biệt với bộ lọc thông minh |
| P14 | Đi xem nhiều phòng không phù hợp | Tốn xăng xe, thời gian | Đặt lịch hẹn xem phòng + Chat trực tiếp trước |

---

## 4. PHẠM VI SẢN PHẨM (SCOPE)

### 4.1 Trong phạm vi (In Scope)

| Module | Mô tả |
|--------|--------|
| **Marketplace (Sàn giao dịch)** | Đăng tin cho thuê, tìm kiếm/lọc phòng, chat in-app, đặt lịch xem phòng, danh sách yêu thích, hệ thống đánh giá |
| **Kế toán & Thanh toán** | Chốt số điện/nước (OCR), tính tiền tự động, tạo hóa đơn điện tử, nhắc nợ thông minh, QR thanh toán |
| **Hợp đồng & Pháp lý** | Lưu trữ hợp đồng số, quản lý CCCD, biên bản bàn giao tài sản, xuất danh sách tạm trú, cảnh báo hết hạn HĐ |
| **Vận hành & Hỗ trợ** | Hệ thống ticket sự cố, bảng tin chung, thăm dò ý kiến/bình chọn |
| **An ninh & Kiểm soát** | Khai báo khách ghé thăm, quản lý xe (biển số), nút báo động khẩn cấp SOS |
| **Quy trình trả phòng** | Chốt công nợ cuối, đối chiếu tài sản, hoàn cọc, đánh giá 2 chiều |

### 4.2 Ngoài phạm vi (Out of Scope) — Phiên bản 1.0

| Hạng mục | Lý do |
|----------|-------|
| Cổng thanh toán trực tuyến (VNPay, Momo) | Cần giấy phép tài chính, triển khai ở giai đoạn sau |
| Tích hợp phần cứng IoT (khóa vân tay, cảm biến) | Chi phí cao, phụ thuộc thiết bị bên thứ 3 |
| Tích hợp camera CCTV thực tế | Phức tạp về bảo mật và quyền riêng tư |
| Ứng dụng Web cho chủ nhà | Ưu tiên mobile-first, web quản trị sẽ ở giai đoạn 2 |

---

## 5. CÁC GIẢ ĐỊNH VÀ RÀNG BUỘC (ASSUMPTIONS & CONSTRAINTS)

### 5.1 Giả định

| # | Giả định |
|---|----------|
| A1 | Chủ nhà trọ tại Việt Nam đều sử dụng smartphone và có kết nối Internet |
| A2 | Người thuê sẵn sàng cung cấp ảnh CCCD qua ứng dụng nếu có cam kết bảo mật |
| A3 | Đa số giao dịch thanh toán hiện tại đã chuyển sang chuyển khoản ngân hàng |
| A4 | Công nghệ OCR đủ chính xác (≥ 95%) để đọc chỉ số đồng hồ điện/nước |

### 5.2 Ràng buộc

| # | Ràng buộc |
|---|-----------|
| C1 | Tuân thủ Nghị định 13/2023/NĐ-CP về bảo vệ dữ liệu cá nhân |
| C2 | Lưu trữ CCCD phải được mã hóa (encryption at rest & in transit) |
| C3 | Ứng dụng phải hoạt động trên cả Android ≥ 8.0 và iOS ≥ 14.0 |
| C4 | Ngôn ngữ giao diện chính: Tiếng Việt |

---

## 6. RỦI RO KINH DOANH (BUSINESS RISKS)

| # | Rủi ro | Mức độ | Biện pháp giảm thiểu |
|---|--------|--------|---------------------|
| R1 | Chủ nhà trọ lớn tuổi khó tiếp cận công nghệ | Trung bình | Giao diện tối giản, onboarding từng bước, hotline hỗ trợ |
| R2 | Lo ngại về bảo mật dữ liệu cá nhân (CCCD) | Cao | Mã hóa AES-256, chính sách bảo mật rõ ràng, xin phép rõ ràng |
| R3 | Cạnh tranh từ các ứng dụng quản lý nhà trọ khác | Trung bình | Tập trung vào trải nghiệm tích hợp Marketplace + Quản lý |
| R4 | Tỷ lệ chấp nhận (adoption rate) thấp ban đầu | Cao | Chiến lược GTM: miễn phí cho chủ nhà ≤ 10 phòng, referral program |
| R5 | OCR nhận diện sai số dẫn đến hóa đơn sai | Trung bình | Luôn cho phép chỉnh sửa thủ công, hiển thị ảnh gốc để đối chiếu |

---

## 7. LỘ TRÌNH SẢN PHẨM (PRODUCT ROADMAP)

### Giai đoạn 1 — MVP (3-4 tháng)
- Đăng ký / Đăng nhập (Xác thực OTP qua số điện thoại).
- Quản lý phòng (CRUD), trạng thái phòng.
- Hợp đồng & Bàn giao tài sản cơ bản.
- Billing Engine: Nhập chỉ số điện/nước → Tạo hóa đơn → Gửi thông báo.
- Hệ thống ticket sự cố.
- Bảng tin chung.

### Giai đoạn 2 — Marketplace & Nâng cao (2-3 tháng)
- Sàn giao dịch phòng trọ (Listing, Tìm kiếm, Bộ lọc).
- Chat in-app & Đặt lịch xem phòng.
- Hệ thống đánh giá (Reviews) 2 chiều.
- OCR Camera nhận dạng đồng hồ điện/nước.
- Nhắc nợ thông minh tự động.

### Giai đoạn 3 — Mở rộng (2-3 tháng)
- An ninh & Kiểm soát (Quản lý xe, Khai báo khách, SOS).
- Thăm dò ý kiến / Bình chọn cư dân.
- Quy trình trả phòng chi tiết (Check-out workflow).
- Tích hợp cổng thanh toán VNPay/Momo (nếu đủ điều kiện pháp lý).
- Xuất báo cáo tài chính cho chủ nhà (PDF/Excel).

---

## 8. TIÊU CHÍ CHẤP NHẬN KINH DOANH (BUSINESS ACCEPTANCE CRITERIA)

| # | Tiêu chí | Điều kiện đạt |
|---|----------|---------------|
| BAC-1 | Chủ nhà có thể chốt hóa đơn toàn bộ khu trọ (20 phòng) trong < 15 phút | Billing Engine hoạt động ổn định |
| BAC-2 | Người thuê nhận được hóa đơn push notification trong < 5 giây sau khi chốt | Real-time SignalR hoạt động |
| BAC-3 | Người tìm phòng có thể tìm thấy phòng trống theo khu vực trong < 3 thao tác | UX Marketplace tối ưu |
| BAC-4 | Xuất danh sách tạm trú chuẩn form Công An trong 1 click | Export PDF/Excel đúng format |
| BAC-5 | Hệ thống nhắc nợ gửi thông báo đúng lịch (4 lần/tháng) | Background Worker ổn định |

---

## 9. BẢNG THUẬT NGỮ (GLOSSARY)

| Thuật ngữ | Giải thích |
|-----------|------------|
| **Landlord / Chủ nhà** | Người sở hữu hoặc quản lý khu nhà trọ / chung cư mini |
| **Tenant / Người thuê** | Người đang thuê phòng và có hợp đồng hiệu lực |
| **Guest / Seeker / Người tìm phòng** | Người dùng chưa thuê phòng, đang tìm kiếm phòng trọ phù hợp |
| **Property / Khu trọ** | Một tòa nhà hoặc cụm phòng trọ thuộc về 1 chủ nhà |
| **Billing Engine** | Hệ thống tính toán hóa đơn tự động dựa trên chỉ số điện/nước và cấu hình phí |
| **OCR** | Optical Character Recognition – Nhận dạng ký tự quang học từ ảnh chụp |
| **Smart Dunning** | Cơ chế nhắc nợ thông minh, tự động gửi thông báo định kỳ |
| **SOS** | Nút báo động khẩn cấp trong trường hợp cháy nổ, trộm cắp |
| **Ticket** | Phiếu yêu cầu sửa chữa/báo sự cố từ người thuê |
| **Check-out** | Quy trình trả phòng bao gồm chốt nợ, kiểm tra tài sản, hoàn cọc |

---

*Phiên bản: 1.0 — Tài liệu này sẽ được cập nhật khi có thay đổi về phạm vi hoặc yêu cầu kinh doanh.*
