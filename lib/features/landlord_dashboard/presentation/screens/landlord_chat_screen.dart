import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandlordChatScreen extends StatefulWidget {
  const LandlordChatScreen({super.key});
  @override
  State<LandlordChatScreen> createState() => _LandlordChatScreenState();
}

class _LandlordChatScreenState extends State<LandlordChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _focusNode = FocusNode();

  final List<_Msg> _messages = [
    _Msg('Chị ơi cho em hỏi về hóa đơn tháng 4 ạ?', false, '09:45'),
    _Msg('Em thấy tiền điện tháng này cao hơn bình thường.', false, '09:46'),
    _Msg(
        'Dạ em ơi, tháng này điện tăng do mùa hè bắt đầu. Chị đã ghi số điện từ 280 lên 400 số ạ.',
        true,
        '09:50'),
    _Msg('Ủa vậy hả chị, em nhớ dùng ít hơn mà.', false, '09:52'),
    _Msg(
        'Chị sẽ kiểm tra lại số ghi nhé. Nếu có sai sót chị sẽ điều chỉnh cho em.',
        true,
        '09:55'),
    _Msg('Cảm ơn chị nhiều ạ! 🙏', false, '10:01'),
  ];

  bool _showQuickReplies = false;

  static const _quickReplies = [
    'Dạ em ơi, chị sẽ kiểm tra lại ngay!',
    'Em vui lòng chuyển khoản đến số TK nhé.',
    'Chị đã nhận được thanh toán rồi ạ.',
    'Em có cần chị hỗ trợ gì thêm không?',
  ];

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage([String? text]) {
    final msg = (text ?? _msgCtrl.text).trim();
    if (msg.isEmpty) return;
    setState(() {
      _messages.add(_Msg(
        msg,
        true,
        '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      ));
      _msgCtrl.clear();
      _showQuickReplies = false;
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
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: cs.onSurface),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Row(children: [
          Stack(children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: cs.primaryContainer,
              child: Text('NB',
                  style: TextStyle(
                      color: cs.primary, fontWeight: FontWeight.w700, fontSize: 13)),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: const Border.fromBorderSide(
                      BorderSide(color: Colors.white, width: 2)),
                ),
              ),
            ),
          ]),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Nguyễn Thị B',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
            Text('Phòng 201 · Đang hoạt động',
                style: TextStyle(fontSize: 11, color: Colors.green.shade600)),
          ]),
        ]),
        actions: [
          IconButton(
            icon: Icon(Icons.phone_rounded, color: cs.primary),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: cs.onSurface.withValues(alpha: 0.5)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Context banner
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Icon(Icons.receipt_long_rounded, color: cs.primary, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Hóa đơn T4/2026 · Hạn 25/04 · 4,250,000 đ',
                      style: TextStyle(
                          fontSize: 12,
                          color: cs.primary,
                          fontWeight: FontWeight.w500)),
                ),
                TextButton(
                  onPressed: () => context.push('/landlord/finance/invoice-detail'),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Text('Xem →',
                      style: TextStyle(fontSize: 11, color: cs.primary)),
                ),
              ]),
            ),
          ),
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              itemCount: _messages.length,
              itemBuilder: (ctx, i) {
                final msg = _messages[i];
                final prevMsg = i > 0 ? _messages[i - 1] : null;
                final showTime =
                    prevMsg == null || prevMsg.time != msg.time || prevMsg.isMe != msg.isMe;
                return _BubbleItem(
                    msg: msg, showName: !msg.isMe && showTime, cs: cs, theme: theme);
              },
            ),
          ),
          // Quick replies
          if (_showQuickReplies)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickReplies
                      .map((r) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => _sendMessage(r),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: cs.primaryContainer.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: cs.primary.withValues(alpha: 0.3)),
                                ),
                                child: Text(r,
                                    style: TextStyle(
                                        fontSize: 12, color: cs.primary)),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          // Compose bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
            child: Row(children: [
              IconButton(
                onPressed: () => setState(() => _showQuickReplies = !_showQuickReplies),
                icon: Icon(
                  _showQuickReplies ? Icons.keyboard_arrow_down_rounded : Icons.bolt_rounded,
                  color: cs.primary,
                ),
                tooltip: 'Trả lời nhanh',
              ),
              Expanded(
                child: TextField(
                  controller: _msgCtrl,
                  focusNode: _focusNode,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Nhắn tin...',
                    hintStyle: TextStyle(
                        fontSize: 14, color: cs.onSurface.withValues(alpha: 0.4)),
                    filled: true,
                    fillColor: const Color(0xFFF8F9FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _BubbleItem extends StatelessWidget {
  final _Msg msg;
  final bool showName;
  final ColorScheme cs;
  final ThemeData theme;
  const _BubbleItem(
      {required this.msg,
      required this.showName,
      required this.cs,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72),
          child: Column(
            crossAxisAlignment:
                msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: msg.isMe ? cs.primary : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(msg.isMe ? 18 : 4),
                    bottomRight: Radius.circular(msg.isMe ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  msg.text,
                  style: TextStyle(
                    fontSize: 14,
                    color: msg.isMe ? Colors.white : cs.onSurface,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(msg.time,
                      style: TextStyle(
                          fontSize: 10,
                          color: cs.onSurface.withValues(alpha: 0.4))),
                  if (msg.isMe) ...[
                    const SizedBox(width: 4),
                    Icon(Icons.done_all_rounded,
                        size: 12, color: cs.primary.withValues(alpha: 0.6)),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Msg {
  final String text, time;
  final bool isMe;
  const _Msg(this.text, this.isMe, this.time);
}
