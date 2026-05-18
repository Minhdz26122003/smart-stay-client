# Fix Listings UI & Image Handling Implementation Plan

> **For Antigravity:** REQUIRED WORKFLOW: Use `.agent/workflows/execute-plan.md` to execute this plan in single-flow mode.

**Goal:** Khắc phục lỗi hiển thị ảnh (SocketException: Failed host lookup) bằng cách tự động biến đổi hostname cục bộ thành IP truy cập được và bổ sung placeholder lỗi; giải quyết lỗi nút Đăng tin mới đè lên thẻ tin bằng cách thêm khoảng đệm phía dưới cho danh sách.

**Architecture:** Sử dụng Clean Architecture. Đóng gói logic hiển thị hình ảnh từ mạng thành một widget dùng chung `AppNetworkImage` đặt tại `lib/core/widgets/` để đảm bảo tính tái sử dụng, thẩm mỹ và khả năng xử lý lỗi an toàn. Cập nhật layout padding trực tiếp trên UI.

**Tech Stack:** Flutter, ColorScheme, Material Design.

---

### Task 1: Tạo Widget AppNetworkImage dùng chung [COMPLETED]

**Files:**
- Create: `lib/core/widgets/app_network_image.dart`

**Step 1: Tạo file widget AppNetworkImage mới**

```dart
// lib/core/widgets/app_network_image.dart
import 'package:flutter/material.dart';
import '../config/app_config.dart';

class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
  });

  String _formatImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    try {
      final baseUri = Uri.parse(AppConfig.baseUrl);
      final host = baseUri.host;
      if (host.isNotEmpty) {
        if (url.contains('storage.smartstay.local')) {
          return url.replaceAll('storage.smartstay.local', host);
        } else if (url.contains('localhost')) {
          return url.replaceAll('localhost', host);
        } else if (url.contains('127.0.0.1')) {
          return url.replaceAll('127.0.0.1', host);
        }
      }
    } catch (e) {
      debugPrint('Error formatting image URL: $e');
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final formattedUrl = _formatImageUrl(imageUrl);

    if (formattedUrl.isEmpty) {
      return _buildPlaceholder(cs);
    }

    return Image.network(
      formattedUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Image load error ($formattedUrl): $error');
        return errorWidget ?? _buildPlaceholder(cs);
      },
    );
  }

  Widget _buildPlaceholder(ColorScheme cs) {
    return Container(
      width: width,
      height: height,
      color: cs.primaryContainer.withValues(alpha: 0.2),
      child: Center(
        child: Icon(
          Icons.image_not_supported_rounded,
          size: 32,
          color: cs.primary.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
```

**Step 2: Commit**

```bash
git add lib/core/widgets/app_network_image.dart
git commit -m "feat: add AppNetworkImage widget with URL formatting and error handling"
```

---

### Task 2: Cập nhật LandlordListingsScreen để tích hợp AppNetworkImage và sửa Layout đè nút [COMPLETED]

**Files:**
- Modify: `lib/features/landlord_dashboard/presentation/screens/landlord_listings_screen.dart`

**Step 1: Import widget AppNetworkImage mới**

Thêm dòng import sau vào đầu file:
```dart
import '../../../core/widgets/app_network_image.dart';
```

**Step 2: Thay thế Image.network bằng AppNetworkImage**

Tại dòng ~139-142, thay đổi:
```dart
// Cũ:
if (l.photoUrls.isNotEmpty)
  Positioned.fill(
    child: Image.network(
      l.photoUrls.first,
      fit: BoxFit.cover,
    ),
  )

// Mới:
if (l.photoUrls.isNotEmpty)
  Positioned.fill(
    child: AppNetworkImage(
      imageUrl: l.photoUrls.first,
      fit: BoxFit.cover,
    ),
  )
```

**Step 3: Tăng padding bottom của ListView để tránh bị đè bởi FloatingActionButton**

Tại dòng ~105, thay đổi padding từ `EdgeInsets.all(16)` thành `EdgeInsets.fromLTRB(16, 16, 16, 88)`:
```dart
// Cũ:
padding: const EdgeInsets.all(16),

// Mới:
padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
```

**Step 4: Commit**

```bash
git add lib/features/landlord_dashboard/presentation/screens/landlord_listings_screen.dart
git commit -m "fix: resolve image SocketException and floating action button overlap in listings screen"
```

---

### Task 3: Cập nhật CHANGELOG.md và xác minh [COMPLETED]

**Files:**
- Modify: `docs/CHANGELOG.md`

**Step 1: Thêm dòng mô tả thay đổi vào CHANGELOG.md**

**Step 2: Commit**

```bash
git add docs/CHANGELOG.md
git commit -m "docs: update CHANGELOG for listing screen image and UI layout fixes"
```
