import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandlordAddBoardPostScreen extends StatefulWidget {
  const LandlordAddBoardPostScreen({super.key});
  @override
  State<LandlordAddBoardPostScreen> createState() =>
      _LandlordAddBoardPostScreenState();
}

class _LandlordAddBoardPostScreenState
    extends State<LandlordAddBoardPostScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isSurvey = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: cs.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Đăng thông báo mới',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isSurvey = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isSurvey ? cs.primary : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: !_isSurvey ? cs.primary : cs.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.campaign_rounded,
                            size: 18,
                            color: !_isSurvey ? Colors.white : cs.onSurface,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Thông báo',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: !_isSurvey ? Colors.white : cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isSurvey = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isSurvey ? Colors.blue.shade600 : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isSurvey
                              ? Colors.blue.shade600
                              : cs.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assessment_rounded,
                            size: 18,
                            color: _isSurvey ? Colors.white : cs.onSurface,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Khảo sát',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _isSurvey ? Colors.white : cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Tiêu đề bài viết...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.1)),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Nhập nội dung chi tiết...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.1)),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            if (_isSurvey) ...[
              const SizedBox(height: 24),
              const Text(
                'Tùy chọn khảo sát',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              const SizedBox(height: 12),
              for (int i = 0; i < 2; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tùy chọn ${i + 1}',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: cs.outline.withValues(alpha: 0.1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: cs.outline.withValues(alpha: 0.1)),
                      ),
                      prefixIcon: Icon(Icons.circle_outlined,
                          size: 16, color: cs.onSurface.withValues(alpha: 0.3)),
                    ),
                  ),
                ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text('Thêm tùy chọn khác'),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                ),
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(_isSurvey ? 'Đã tạo khảo sát!' : 'Đã đăng bài!'),
                  backgroundColor: cs.primary,
                  behavior: SnackBarBehavior.floating,
                ));
                context.pop();
              },
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              label: const Text(
                'ĐĂNG BẢNG TIN',
                style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                backgroundColor: cs.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
