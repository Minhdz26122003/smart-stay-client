import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TenantChatScreen extends StatefulWidget {
  const TenantChatScreen({super.key});
  @override
  State<TenantChatScreen> createState() => _TenantChatScreenState();
}

class _TenantChatScreenState extends State<TenantChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _isTyping = false;

  final _messages = <_Msg>[
    _Msg(
      'Chị ơi, hóa đơn tháng 4 em thấy cao hơn mọi tháng ạ.',
      false,
      '09:45',
    ),
    _Msg(
      'Mục tiền điện em thấy 199.500đ, cao hơn tháng trước nhiều ạ.',
      false,
      '09:46',
    ),
    _Msg(
      'Dạ em ơi, tháng này mùa hè bắt đầu nên điện tăng do dùng điều hòa nhiều đó. Chị ghi số từ 1043 → 1100 kWh nhé.',
      true,
      '09:50',
    ),
    _Msg(
      'Ủa vậy hả chị. Thế vụ vòi nước em báo lần trước giờ chị có sắp xếp được chưa ạ?',
      false,
      '09:52',
    ),
    _Msg(
      'Chiều 03/04 chị cho thợ đến sửa lúc 14:00 nhé em. Em ở nhà không?',
      true,
      '09:55',
    ),
    _Msg('Dạ em ở nhà ạ. Cảm ơn chị ạ! 🙏', false, '10:01'),
    _Msg('Okay em nhé. Thợ sẽ gọi điện báo trước khi đến.', true, '10:03'),
  ];

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send() {
    if (_msgCtrl.text.trim().isEmpty) return;
    setState(() {
      _messages.add(
        _Msg(
          _msgCtrl.text.trim(),
          false,
          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        ),
      );
      _msgCtrl.clear();
      _isTyping = false;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: cs.onSurface,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: cs.primaryContainer.withValues(alpha: 0.4),
                  child: Text(
                    'NH',
                    style: TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.shade400,
                      shape: BoxShape.circle,
                      border: const Border.fromBorderSide(
                        BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nguyễn Văn Hùng',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const Text(
                  'Đang hoạt động',
                  style: TextStyle(fontSize: 10, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert_rounded,
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Context banner
          Material(
            color: cs.primaryContainer.withValues(alpha: 0.15),
            child: InkWell(
              onTap: () => context.push('/tenant/issue-detail'),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                child: Row(
                  children: [
                    Icon(Icons.push_pin_rounded, size: 13, color: cs.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'ISS-001 · Hỏng vòi nước phòng tắm — Đang xử lý',
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurface.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      'Xem',
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              itemCount: _messages.length,
              itemBuilder: (ctx, i) {
                final msg = _messages[i];
                final prevSameDir =
                    i > 0 && _messages[i - 1].isLandlord == msg.isLandlord;
                return Column(
                  children: [
                    if (i == 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: cs.outlineVariant.withValues(alpha: 0.4),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                'Hôm nay',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: cs.onSurface.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: cs.outlineVariant.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(bottom: prevSameDir ? 4 : 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: msg.isLandlord
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: [
                          if (msg.isLandlord && !prevSameDir) ...[
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: cs.primaryContainer.withValues(
                                alpha: 0.4,
                              ),
                              child: Text(
                                'NH',
                                style: TextStyle(
                                  color: cs.primary,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ] else if (msg.isLandlord) ...[
                            const SizedBox(width: 38),
                          ],
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.72,
                            ),
                            child: Column(
                              crossAxisAlignment: msg.isLandlord
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: msg.isLandlord
                                        ? Colors.white
                                        : cs.primary,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(18),
                                      topRight: const Radius.circular(18),
                                      bottomLeft: Radius.circular(
                                        msg.isLandlord ? 4 : 18,
                                      ),
                                      bottomRight: Radius.circular(
                                        msg.isLandlord ? 18 : 4,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.06,
                                        ),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    msg.text,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: msg.isLandlord
                                          ? cs.onSurface
                                          : Colors.white,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      msg.time,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: cs.onSurface.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                    ),
                                    if (!msg.isLandlord) ...[
                                      const SizedBox(width: 3),
                                      Icon(
                                        Icons.done_all_rounded,
                                        size: 12,
                                        color: cs.primary,
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Quick replies
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              children: [
                for (final q in [
                  'Cảm ơn chị!',
                  'Dạ em ở nhà',
                  'Tháng sau gia hạn HĐ ạ',
                  'Điện tháng này cao quá ạ',
                ])
                  GestureDetector(
                    onTap: () {
                      _msgCtrl.text = q;
                      _send();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: cs.primary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        q,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.push('/tenant/services/report'),
                    child: Container(
                      width: 42,
                      height: 42,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        size: 22,
                        color: cs.primary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      onChanged: (v) =>
                          setState(() => _isTyping = v.trim().isNotEmpty),
                      decoration: InputDecoration(
                        hintText: 'Nhắn tin cho chủ nhà...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: cs.onSurface.withValues(alpha: 0.4),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8F9FF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedScale(
                    scale: _isTyping ? 1.0 : 0.9,
                    duration: const Duration(milliseconds: 150),
                    child: GestureDetector(
                      onTap: _send,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _isTyping
                              ? cs.primary
                              : cs.primary.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Msg {
  final String text, time;
  final bool isLandlord;
  const _Msg(this.text, this.isLandlord, this.time);
}
