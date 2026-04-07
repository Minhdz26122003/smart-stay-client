import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/announcement/presentation/cubit/announcement_cubit.dart';
import '../../../../features/announcement/presentation/cubit/announcement_state.dart';
import '../../../../core/di/injection_container.dart';

class LandlordAddBoardPostScreen extends StatefulWidget {
  /// propertyId passed via GoRouter extra
  final String propertyId;
  const LandlordAddBoardPostScreen({super.key, required this.propertyId});

  @override
  State<LandlordAddBoardPostScreen> createState() =>
      _LandlordAddBoardPostScreenState();
}

class _LandlordAddBoardPostScreenState
    extends State<LandlordAddBoardPostScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

    return BlocProvider(
      create: (_) => sl<AnnouncementCubit>(),
      child: BlocConsumer<AnnouncementCubit, AnnouncementState>(
        listener: (context, state) {
          if (state is AnnouncementSubmitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Đã đăng thông báo thành công! 📣'),
              backgroundColor: cs.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ));
            context.pop();
          }
          if (state is AnnouncementSubmitError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Lỗi: ${state.message}'),
              backgroundColor: cs.error,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        builder: (context, state) {
          final isSending = state is AnnouncementSubmitting;

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
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Info banner
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(children: [
                        Icon(Icons.info_outline_rounded,
                            color: cs.primary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Thông báo sẽ được gửi đến tất cả các khách thuê trong khu trọ.',
                            style: TextStyle(
                                fontSize: 13,
                                color: cs.onSurface.withValues(alpha: 0.7),
                                height: 1.4),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 20),

                    // Title field
                    _Label(label: 'Tiêu đề *'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Vui lòng nhập tiêu đề' : null,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                      decoration: _fieldDecoration(
                          cs, 'Ví dụ: Thông báo cắt nước ngày 10/4...'),
                    ),
                    const SizedBox(height: 16),

                    // Body field
                    _Label(label: 'Nội dung *'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _bodyController,
                      maxLines: 8,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Vui lòng nhập nội dung' : null,
                      decoration: _fieldDecoration(
                          cs, 'Nhập nội dung chi tiết thông báo...'),
                    ),
                    const SizedBox(height: 32),

                    // Submit
                    ElevatedButton.icon(
                      onPressed: isSending
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AnnouncementCubit>().postAnnouncement(
                                      propertyId: widget.propertyId,
                                      title: _titleController.text.trim(),
                                      body: _bodyController.text.trim(),
                                    );
                              }
                            },
                      icon: isSending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.send_rounded,
                              color: Colors.white),
                      label: Text(
                        isSending ? 'Đang gửi...' : 'ĐĂNG BẢNG TIN',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        backgroundColor: cs.primary,
                        disabledBackgroundColor:
                            cs.primary.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _fieldDecoration(ColorScheme cs, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          color: cs.onSurface.withValues(alpha: 0.35), fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cs.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cs.error, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

class _Label extends StatelessWidget {
  final String label;
  const _Label({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      label,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: cs.onSurface.withValues(alpha: 0.75)),
    );
  }
}
