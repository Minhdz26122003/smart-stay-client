import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─── Data Models ─────────────────────────────────────────────────────────────
class _RoomEntry {
  final String room;
  final String tenant;
  final int base;
  final int prevElectric;
  int curElectric;
  final int prevWater;
  int curWater;
  final int electricRate;
  final int waterRate;
  bool done;

  _RoomEntry({
    required this.room,
    required this.tenant,
    required this.base,
    required this.prevElectric,
    required this.curElectric,
    required this.prevWater,
    required this.curWater,
    required this.electricRate,
    required this.waterRate,
    this.done = false,
  });

  int get electricUsed => curElectric - prevElectric;
  int get waterUsed => curWater - prevWater;
  int get electricCost => electricUsed * electricRate;
  int get waterCost => waterUsed * waterRate;
  int get total => base + electricCost + waterCost;
}

// ─── Main Screen ──────────────────────────────────────────────────────────────
class LandlordInvoiceSettleScreen extends StatefulWidget {
  const LandlordInvoiceSettleScreen({super.key});
  @override
  State<LandlordInvoiceSettleScreen> createState() =>
      _LandlordInvoiceSettleScreenState();
}

class _LandlordInvoiceSettleScreenState
    extends State<LandlordInvoiceSettleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  int _selectedAreaIndex = 0;

  final _areas = ['Khu A · Bình Thạnh', 'Khu B · Gò Vấp'];

  final _aRooms = [
    _RoomEntry(
      room: 'P.205',
      tenant: 'Nguyễn Thị Linh',
      base: 3500000,
      prevElectric: 432,
      curElectric: 0,
      prevWater: 18,
      curWater: 0,
      electricRate: 3500,
      waterRate: 15000,
    ),
    _RoomEntry(
      room: 'P.101',
      tenant: 'Nguyễn Văn A',
      base: 3500000,
      prevElectric: 541,
      curElectric: 598,
      prevWater: 23,
      curWater: 27,
      electricRate: 3500,
      waterRate: 15000,
      done: true,
    ),
    _RoomEntry(
      room: 'P.201',
      tenant: 'Trần Thanh Tâm',
      base: 4200000,
      prevElectric: 312,
      curElectric: 385,
      prevWater: 12,
      curWater: 15,
      electricRate: 3500,
      waterRate: 15000,
      done: true,
    ),
  ];

  final _bRooms = [
    _RoomEntry(
      room: 'P.01',
      tenant: 'Lê Thị Thu',
      base: 2800000,
      prevElectric: 210,
      curElectric: 0,
      prevWater: 8,
      curWater: 0,
      electricRate: 3500,
      waterRate: 15000,
    ),
    _RoomEntry(
      room: 'P.02',
      tenant: 'Phạm Văn Nam',
      base: 3200000,
      prevElectric: 180,
      curElectric: 0,
      prevWater: 11,
      curWater: 0,
      electricRate: 3500,
      waterRate: 15000,
    ),
  ];

  List<_RoomEntry> get _currentRooms =>
      _selectedAreaIndex == 0 ? _aRooms : _bRooms;

  int get _total => [..._aRooms, ..._bRooms].fold(0, (s, r) => s + r.total);
  int get _doneCount =>
      _aRooms.where((r) => r.done).length + _bRooms.where((r) => r.done).length;
  int get _pendingCount =>
      _aRooms.where((r) => !r.done).length +
      _bRooms.where((r) => !r.done).length;
  int get _totalRooms => _aRooms.length + _bRooms.length;
  int get _enteredCount =>
      [..._aRooms, ..._bRooms].where((r) => r.done || r.curElectric > 0).length;

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final pending = _currentRooms.where((r) => !r.done).toList();
    final done = _currentRooms.where((r) => r.done).toList();

    // Tab 0 = Chờ nhập, 1 = Đã nhập
    final tabItems = [pending, done];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FF),
      appBar: AppBar(
        backgroundColor: cs.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Chốt Hóa Đơn T${DateTime.now().month}/${DateTime.now().year}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Hướng dẫn',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Area Selector + Progress ────────────────────────────────────
          Container(
            color: cs.primary,
            child: Column(
              children: [
                // Area chips
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  child: Row(
                    children: List.generate(_areas.length, (i) {
                      final sel = i == _selectedAreaIndex;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedAreaIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: sel
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _areas[i],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: sel ? cs.primary : Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                // Progress card
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Đã nhập: $_enteredCount/$_totalRooms phòng',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          Text(
                            '${(_enteredCount / _totalRooms * 100).round()}%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: _enteredCount / _totalRooms,
                          minHeight: 8,
                          backgroundColor: cs.primary.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Stats row
                      Row(
                        children: [
                          _StatBadge(
                            label: 'HOÀN THÀNH',
                            value: _doneCount,
                            color: const Color(0xFF00B894),
                            icon: Icons.check_circle_rounded,
                          ),
                          const SizedBox(width: 8),
                          _StatBadge(
                            label: 'CHỜ NHẬP',
                            value: _pendingCount,
                            color: const Color(0xFFE17055),
                            icon: Icons.pending_rounded,
                          ),
                          const SizedBox(width: 8),
                          _StatBadge(
                            label: 'TỔNG',
                            value: null,
                            rawText:
                                '${_fmt(_total / 1000000 > 1 ? (_total ~/ 100000) : _total)}${_total >= 1000000 ? "M" : "đ"}',
                            color: cs.primary,
                            icon: Icons.account_balance_wallet_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Tab Bar ─────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: TabBar(
              controller: _tabCtrl,
              labelColor: cs.primary,
              unselectedLabelColor: cs.onSurface.withValues(alpha: 0.45),
              indicatorColor: cs.primary,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              tabs: [
                Tab(text: 'Chờ nhập (${pending.length})'),
                Tab(text: 'Đã nhập (${done.length})'),
              ],
            ),
          ),

          // ── Room Cards ───────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: tabItems.map((list) {
                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 56,
                          color: const Color(0xFF00B894).withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Không có phòng nào',
                          style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.4),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _RoomInputCard(
                    room: list[i],
                    fmt: _fmt,
                    cs: cs,
                    theme: theme,
                    onSave: () => setState(() {
                      list[i].done = true;
                    }),
                    onScan: (type) => context.push(
                      '/landlord/meter-scan',
                      extra: {'room': list[i].room, 'type': type},
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),

      // ── Bottom CTA ─────────────────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: ElevatedButton.icon(
            onPressed: _doneCount > 0
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Đã gửi $_doneCount hóa đơn thành công! 🎉',
                        ),
                        backgroundColor: cs.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                    context.pop();
                  }
                : null,
            icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            label: Text(
              _doneCount > 0
                  ? '▶  Xác nhận & Gửi $_doneCount Hóa Đơn'
                  : 'Chưa có hóa đơn nào',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              minimumSize: const Size(double.infinity, 54),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Room Input Card ──────────────────────────────────────────────────────────
class _RoomInputCard extends StatefulWidget {
  final _RoomEntry room;
  final String Function(int) fmt;
  final ColorScheme cs;
  final ThemeData theme;
  final VoidCallback onSave;
  final void Function(String type) onScan;

  const _RoomInputCard({
    required this.room,
    required this.fmt,
    required this.cs,
    required this.theme,
    required this.onSave,
    required this.onScan,
  });

  @override
  State<_RoomInputCard> createState() => _RoomInputCardState();
}

class _RoomInputCardState extends State<_RoomInputCard> {
  late TextEditingController _elCtrl;
  late TextEditingController _waCtrl;

  @override
  void initState() {
    super.initState();
    _elCtrl = TextEditingController(
      text: widget.room.curElectric > 0
          ? widget.room.curElectric.toString()
          : '',
    );
    _waCtrl = TextEditingController(
      text: widget.room.curWater > 0 ? widget.room.curWater.toString() : '',
    );
  }

  @override
  void dispose() {
    _elCtrl.dispose();
    _waCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.room;
    final fmt = widget.fmt;
    final cs = widget.cs;
    final theme = widget.theme;

    final elUsed = r.curElectric > 0 ? r.curElectric - r.prevElectric : 0;
    final waUsed = r.curWater > 0 ? r.curWater - r.prevWater : 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: r.done
            ? Border.all(
                color: const Color(0xFF00B894).withValues(alpha: 0.3),
                width: 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card Header ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${r.room} · ${r.tenant}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (r.done)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B894).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 13,
                          color: Color(0xFF00B894),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Hoàn thành',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF00B894),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Chờ nhập',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          if (!r.done) ...[
            const Divider(height: 1),
            // ── Meter Input ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _MeterInput(
                    icon: Icons.bolt_rounded,
                    iconColor: Colors.amber.shade700,
                    label: 'Điện',
                    prev: r.prevElectric,
                    unit: 'kWh',
                    controller: _elCtrl,
                    onChanged: (v) {
                      final n = int.tryParse(v) ?? 0;
                      setState(() => r.curElectric = n);
                    },
                    onScan: () => widget.onScan('electric'),
                  ),
                  const SizedBox(height: 10),
                  _MeterInput(
                    icon: Icons.water_drop_rounded,
                    iconColor: Colors.blue.shade600,
                    label: 'Nước',
                    prev: r.prevWater,
                    unit: 'm³',
                    controller: _waCtrl,
                    onChanged: (v) {
                      final n = int.tryParse(v) ?? 0;
                      setState(() => r.curWater = n);
                    },
                    onScan: () => widget.onScan('water'),
                  ),
                ],
              ),
            ),
            // ── Preview & Save ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Row(
                children: [
                  Text(
                    'Tiền phòng: ${fmt(r.base)} đ',
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed:
                        r.curElectric > r.prevElectric ||
                            r.curWater > r.prevWater
                        ? widget.onSave
                        : null,
                    icon: const Icon(
                      Icons.save_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Lưu',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      elevation: 0,
                      minimumSize: const Size(80, 38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // ── Summary view (done) ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Column(
                children: [
                  _SummaryRow(
                    icon: Icons.bolt_rounded,
                    iconColor: Colors.amber.shade700,
                    text:
                        '${r.prevElectric} → ${r.curElectric} = ${elUsed} kWh × ${fmt(r.electricRate)}đ = ${fmt(r.electricCost)}đ',
                  ),
                  const SizedBox(height: 4),
                  _SummaryRow(
                    icon: Icons.water_drop_rounded,
                    iconColor: Colors.blue.shade600,
                    text:
                        '${r.prevWater} → ${r.curWater} = ${waUsed} m³ × ${fmt(r.waterRate)}đ = ${fmt(r.waterCost)}đ',
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '+ ${fmt(r.base)}đ tiền phòng',
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      Text(
                        'TỔNG CỘNG',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${fmt(r.total)} đ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Meter Input Row ──────────────────────────────────────────────────────────
class _MeterInput extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final int prev;
  final String unit;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onScan;

  const _MeterInput({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.prev,
    required this.unit,
    required this.controller,
    required this.onChanged,
    required this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: iconColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'Tháng trước: $prev $unit',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Nhập số mới...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade400,
                    ),
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onScan,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 20,
                    color: cs.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Summary Row ─────────────────────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  const _SummaryRow({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13, color: iconColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Stat Badge ───────────────────────────────────────────────────────────────
class _StatBadge extends StatelessWidget {
  final String label;
  final int? value;
  final String? rawText;
  final Color color;
  final IconData icon;
  const _StatBadge({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    this.rawText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
            Text(
              rawText ?? '${value ?? 0}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: color.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
