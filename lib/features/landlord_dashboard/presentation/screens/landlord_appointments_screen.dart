import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandlordAppointmentsScreen extends StatefulWidget {
  const LandlordAppointmentsScreen({super.key});
  @override
  State<LandlordAppointmentsScreen> createState() =>
      _LandlordAppointmentsScreenState();
}

class _LandlordAppointmentsScreenState
    extends State<LandlordAppointmentsScreen> {
  int _selectedDay = 9;

  static const _appointments = [
    _Appt('Nguyễn Văn Hùng', '0901 234 001', 'Phòng 102', '09/04', '10:00',
        'Chờ xác nhận', Colors.orange),
    _Appt('Trần Thị Lan', '0912 345 002', 'Phòng 302', '10/04', '14:00',
        'Đã xác nhận', Colors.green),
    _Appt('Phạm Minh Tuấn', '0923 456 003', 'Phòng 102', '12/04', '09:00',
        'Đã xác nhận', Colors.green),
    _Appt('Lê Thị Hoa', '0934 567 004', 'Phòng 302', '07/04', '15:30',
        'Đã hủy', Colors.red),
  ];

  static const _daysWithAppt = [9, 10, 12];

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
        title: Text('Lịch hẹn xem phòng',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          // Mini calendar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                // Month header
                Row(children: [
                  Text('Tháng 4/2026',
                      style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.chevron_left_rounded, color: cs.primary),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.chevron_right_rounded, color: cs.primary),
                  ),
                ]),
                const SizedBox(height: 12),
                // Days of week header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
                      .map((d) => SizedBox(
                            width: 36,
                            child: Text(d,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: cs.onSurface.withValues(alpha: 0.4))),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                // Week days
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (i) {
                    final day = 7 + i;
                    final hasAppt = _daysWithAppt.contains(day);
                    final isSelected = day == _selectedDay;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDay = day),
                      child: SizedBox(
                        width: 36,
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isSelected ? cs.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$day',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : cs.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            if (hasAppt)
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.8)
                                      : cs.primary,
                                  shape: BoxShape.circle,
                                ),
                              )
                            else
                              const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          // List header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(children: [
              Text('Lịch hẹn sắp tới',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                    '${_appointments.where((a) => a.status != 'Đã hủy').length} lịch hẹn',
                    style: TextStyle(
                        fontSize: 12,
                        color: cs.primary,
                        fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
          // Appointments list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: _appointments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final appt = _appointments[i];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: appt.status == 'Chờ xác nhận'
                        ? Border.all(color: Colors.orange.withValues(alpha: 0.4))
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: cs.primaryContainer,
                            child: Text(
                              appt.name[0],
                              style: TextStyle(
                                  color: cs.primary, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(appt.name,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w700)),
                                Text(appt.phone,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: cs.onSurface.withValues(alpha: 0.5))),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: appt.statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(appt.status,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: appt.statusColor)),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        // Detail row
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(children: [
                              Icon(Icons.meeting_room_outlined,
                                  size: 14, color: cs.primary),
                              const SizedBox(width: 6),
                              Text(appt.room,
                                  style: TextStyle(
                                      fontSize: 12, color: cs.primary, fontWeight: FontWeight.w600)),
                            ]),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(children: [
                              Icon(Icons.schedule_rounded,
                                  size: 14, color: cs.primary),
                              const SizedBox(width: 6),
                              Text('${appt.date} · ${appt.time}',
                                  style: TextStyle(
                                      fontSize: 12, color: cs.primary, fontWeight: FontWeight.w600)),
                            ]),
                          ),
                        ]),
                        // Confirm/Reject actions
                        if (appt.status == 'Chờ xác nhận') ...[
                          const SizedBox(height: 12),
                          Row(children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: cs.error.withValues(alpha: 0.5)),
                                  foregroundColor: cs.error,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Từ chối',
                                    style: TextStyle(fontSize: 13)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: cs.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Xác nhận',
                                    style: TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ]),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Appt {
  final String name, phone, room, date, time, status;
  final Color statusColor;
  const _Appt(this.name, this.phone, this.room, this.date, this.time,
      this.status, this.statusColor);
}
