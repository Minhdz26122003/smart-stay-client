# AI Agent Context & Guidelines - Smart Stay

Chào Agent! Bạn đang làm việc trong dự án **Smart Stay** - Hệ sinh thái quản lý nhà trọ thông minh. Để đảm bảo hiệu suất và chất lượng code cao nhất, bạn CẦN tuân thủ các chỉ dẫn dưới đây.

## 1. Hệ Quy Chiếu Ngữ Cảnh (Context Reference)
Trước khi bắt đầu bất kỳ tác vụ nào, bạn phải đọc và hiểu:
- **Tầm nhìn:** [docs/brief.md](file:///f:/Documents/Flutter/smart_stay_client/docs/brief.md)
- **Yêu cầu & Công nghệ:** [docs/BRD.md](file:///f:/Documents/Flutter/smart_stay_client/docs/BRD.md)
- **Lộ trình:** [docs/plans/master-plan.md](file:///f:/Documents/Flutter/smart_stay_client/docs/plans/master-plan.md)

## 2. Quy Tắc Kiến Trúc (Core Rules)
- **Kiến trúc:** Clean Architecture (Feature-first). Mọi feature mới phải nằm trong `lib/features/{feature_name}/`.
- **State Management:** BẮT BUỘC dùng `flutter_bloc`.
- **Dữ liệu:** Luôn dùng `freezed` cho Model/Entity. Không viết tay `fromJson/toJson`.
- **Giao diện:** Đọc màu sắc/style từ `Theme.of(context).extension<AppColors>()`. Tuyệt đối không hardcode.

## 3. Quy Trình Làm Việc (Workflow)
1. **Phân tích:** Đọc yêu cầu -> Tra cứu tài liệu trong `docs/` -> Đưa ra giải pháp.
2. **Triển khai:** Viết code tuân thủ quy tắc tại mục 2.
3. **Xác minh:** Chạy tests (nếu có) và kiểm tra lỗi logic.
4. **Bàn giao:** Cập nhật `CHANGELOG.md` (Xem mục 4).

## 4. [CRITICAL] Trigger Update CHANGELOG
Mỗi khi hoàn thành một đơn vị công việc (Feature, Bugfix, Refactor), Agent **BẮT BUỘC** phải thực hiện bước sau:
- Mở file [docs/CHANGELOG.md](file:///f:/Documents/Flutter/smart_stay_client/docs/CHANGELOG.md).
- Thêm một entry mới dưới ngày hiện tại theo định dạng:
  ```markdown
  ## [YYYY-MM-DD] - {Loại công việc}
  ### {Added/Fixed/Changed/Refactored}
  - Mô tả ngắn gọn việc đã làm.
  ```
- **Lưu ý:** Nếu ngày đó đã có entry, hãy thêm nội dung vào dưới entry đó thay vì tạo mới.

## 5. Chỉ Dẫn Giao Tiếp
- Giữ phản hồi ngắn gọn, tập trung vào giải pháp kỹ thuật.
- Luôn báo cáo trạng thái dựa trên các Phase trong `master-plan.md`.
