import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandlordMeterScanScreen extends StatefulWidget {
  final String roomName;
  final String meterType; // 'electric' | 'water'
  const LandlordMeterScanScreen({
    super.key,
    this.roomName = 'Phòng 101',
    this.meterType = 'electric',
  });
  @override
  State<LandlordMeterScanScreen> createState() =>
      _LandlordMeterScanScreenState();
}

class _LandlordMeterScanScreenState extends State<LandlordMeterScanScreen>
    with SingleTickerProviderStateMixin {
  bool _scanned = false;
  bool _isManualEdit = false;
  String _reading = '03452';
  final _editCtrl = TextEditingController();
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  bool get _isElectric => widget.meterType == 'electric';

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    // Simulate AI scan after 2s
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _scanned = true);
    });
    _editCtrl.text = _reading;
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _editCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Simulated camera background ──────────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade900,
                    Colors.grey.shade800,
                    Colors.grey.shade700,
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  _isElectric ? Icons.electric_meter_rounded : Icons.water_drop_rounded,
                  size: 120,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
          ),

          // ── Top bar ──────────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _CamButton(
                    icon: Icons.close_rounded,
                    onTap: () => context.pop(),
                  ),
                  const Spacer(),
                  Text(
                    'MeterScan AI',
                    style: TextStyle(
                      color: _isElectric
                          ? const Color(0xFF4ECDC4)
                          : const Color(0xFF74B9FF),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  _CamButton(
                    icon: Icons.flashlight_on_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          // ── Scan viewfinder ───────────────────────────────────────────────
          Positioned(
            top: 110,
            left: 32,
            right: 32,
            height: 200,
            child: AnimatedBuilder(
              animation: _pulseAnim,
              builder: (_, __) => CustomPaint(
                painter: _ViewfinderPainter(
                  color: _scanned
                      ? const Color(0xFF4ECDC4)
                      : const Color(0xFFFFB347),
                  opacity: _scanned ? 1.0 : _pulseAnim.value,
                ),
              ),
            ),
          ),

          // ── Hint text ────────────────────────────────────────────────────
          Positioned(
            top: 322,
            left: 0,
            right: 0,
            child: Text(
              _scanned
                  ? '✓  Nhận diện thành công'
                  : 'Đưa mặt số đồng hồ vào giữa khung hình',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _scanned ? const Color(0xFF4ECDC4) : Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // ── Bottom sheet result ───────────────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSlide(
              offset: Offset(0, _scanned ? 0 : 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // drag handle
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.roomName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            _isElectric
                                ? 'Ghi điện tháng ${DateTime.now().month}'
                                : 'Ghi nước tháng ${DateTime.now().month}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Text(
                            'Đã nhận diện tự động bằng AI',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF4ECDC4),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Reading display
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _isElectric
                                        ? Colors.amber.shade100
                                        : Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _isElectric ? 'KWH' : 'M³',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: _isElectric
                                          ? Colors.amber.shade800
                                          : Colors.blue.shade800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _isManualEdit
                                    ? Expanded(
                                        child: TextField(
                                          controller: _editCtrl,
                                          autofocus: true,
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 3,
                                          ),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (v) =>
                                              setState(() => _reading = v),
                                        ),
                                      )
                                    : Expanded(
                                        child: Text(
                                          _reading,
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 6,
                                          ),
                                        ),
                                      ),
                                GestureDetector(
                                  onTap: () => setState(
                                    () => _isManualEdit = !_isManualEdit,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cs.primaryContainer.withValues(
                                        alpha: 0.3,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          _isManualEdit
                                              ? Icons.check_rounded
                                              : Icons.edit_rounded,
                                          size: 14,
                                          color: cs.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _isManualEdit ? 'Xong' : 'Nhập\ntay',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: cs.primary,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Action buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      setState(() => _scanned = false),
                                  icon: const Icon(
                                    Icons.camera_alt_rounded,
                                    size: 18,
                                  ),
                                  label: const Text('Chụp lại'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Đã lưu chỉ số $_reading ${_isElectric ? "kWh" : "m³"}',
                                        ),
                                        backgroundColor: cs.primary,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                    context.pop();
                                  },
                                  icon: const Icon(
                                    Icons.save_alt_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Xác nhận & Lưu',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: cs.primary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CamButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CamButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _ViewfinderPainter extends CustomPainter {
  final Color color;
  final double opacity;
  const _ViewfinderPainter({required this.color, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final dashPaint = Paint()
      ..color = color.withValues(alpha: opacity * 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const cornerLen = 28.0;

    // Corner brackets
    final corners = [
      // top-left
      [Offset(0, cornerLen), Offset(0, 0), Offset(cornerLen, 0)],
      // top-right
      [
        Offset(size.width - cornerLen, 0),
        Offset(size.width, 0),
        Offset(size.width, cornerLen),
      ],
      // bottom-right
      [
        Offset(size.width, size.height - cornerLen),
        Offset(size.width, size.height),
        Offset(size.width - cornerLen, size.height),
      ],
      // bottom-left
      [
        Offset(cornerLen, size.height),
        Offset(0, size.height),
        Offset(0, size.height - cornerLen),
      ],
    ];

    for (final pts in corners) {
      final path = Path()
        ..moveTo(pts[0].dx, pts[0].dy)
        ..lineTo(pts[1].dx, pts[1].dy)
        ..lineTo(pts[2].dx, pts[2].dy);
      canvas.drawPath(path, paint);
    }

    // Dashed border
    _drawDashed(
      canvas,
      Offset(cornerLen, 0),
      Offset(size.width - cornerLen, 0),
      dashPaint,
    );
    _drawDashed(
      canvas,
      Offset(cornerLen, size.height),
      Offset(size.width - cornerLen, size.height),
      dashPaint,
    );
    _drawDashed(
      canvas,
      Offset(0, cornerLen),
      Offset(0, size.height - cornerLen),
      dashPaint,
    );
    _drawDashed(
      canvas,
      Offset(size.width, cornerLen),
      Offset(size.width, size.height - cornerLen),
      dashPaint,
    );

    // Scan line
    final scanY = size.height * 0.45;
    final scanPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          color.withValues(alpha: opacity * 0.8),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, scanY - 1, size.width, 3))
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(8, scanY),
      Offset(size.width - 8, scanY),
      scanPaint,
    );
  }

  void _drawDashed(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashLen = 8.0;
    const gapLen = 6.0;
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final total = (dx * dx + dy * dy).abs().toDouble();
    if (total == 0) return;
    final length = total < 1 ? 1.0 : total;
    final nx = dx / length;
    final ny = dy / length;
    double d = 0;
    while (d < length) {
      final p1 = Offset(start.dx + nx * d, start.dy + ny * d);
      d += dashLen;
      if (d > length) d = length;
      final p2 = Offset(start.dx + nx * d, start.dy + ny * d);
      canvas.drawLine(p1, p2, paint);
      d += gapLen;
    }
  }

  @override
  bool shouldRepaint(_ViewfinderPainter old) =>
      old.color != color || old.opacity != opacity;
}
