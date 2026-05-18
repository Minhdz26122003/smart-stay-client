import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../ticket/domain/entities/ticket.dart';
import '../../../ticket/presentation/bloc/ticket_cubit.dart';
import '../../../ticket/presentation/bloc/ticket_state.dart';
import 'tenant_report_issue_screen.dart';

class TenantServicesScreen extends StatefulWidget {
  const TenantServicesScreen({super.key});

  @override
  State<TenantServicesScreen> createState() => _TenantServicesScreenState();
}

class _TenantServicesScreenState extends State<TenantServicesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TicketCubit>().loadTenantTickets();
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
        title: Text(
          'Dich vu & Ho tro',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocBuilder<TicketCubit, TicketState>(
        builder: (context, state) {
          final tickets = state is TicketLoaded ? state.tickets : <Ticket>[];
          final activeTickets =
              tickets.where((ticket) => !ticket.status.isFinal).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ActiveIssueBanner(
                  activeTickets: activeTickets,
                  onTap: activeTickets.isEmpty
                      ? null
                      : () => context.push(
                            '/tenant/issue-detail',
                            extra: activeTickets.first,
                          ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Bao su co / Yeu cau dich vu',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.9,
                  children: [
                    _ServiceTile(
                      icon: Icons.electrical_services_rounded,
                      label: 'Dien',
                      color: const Color(0xFFF59E0B),
                      onTap: () => _openReport(context, tickets, TicketCategory.electricity),
                    ),
                    _ServiceTile(
                      icon: Icons.water_drop_rounded,
                      label: 'Nuoc',
                      color: const Color(0xFF3B82F6),
                      onTap: () => _openReport(context, tickets, TicketCategory.water),
                    ),
                    _ServiceTile(
                      icon: Icons.chair_rounded,
                      label: 'Noi that',
                      color: const Color(0xFF06B6D4),
                      onTap: () => _openReport(context, tickets, TicketCategory.furniture),
                    ),
                    _ServiceTile(
                      icon: Icons.build_rounded,
                      label: 'Khac',
                      color: const Color(0xFF8B5CF6),
                      onTap: () => _openReport(context, tickets, TicketCategory.other),
                    ),
                    _ServiceTile(
                      icon: Icons.cleaning_services_rounded,
                      label: 'Ve sinh',
                      color: const Color(0xFF10B981),
                      onTap: () => _openReport(context, tickets, TicketCategory.other),
                    ),
                    _ServiceTile(
                      icon: Icons.lock_rounded,
                      label: 'Khoa cua',
                      color: const Color(0xFF6366F1),
                      onTap: () => _openReport(context, tickets, TicketCategory.other),
                    ),
                    _ServiceTile(
                      icon: Icons.router_rounded,
                      label: 'Internet',
                      color: const Color(0xFFEF4444),
                      onTap: () => _openReport(context, tickets, TicketCategory.other),
                    ),
                    _ServiceTile(
                      icon: Icons.chat_bubble_rounded,
                      label: 'Chat chu',
                      color: cs.primary,
                      onTap: () => context.push('/tenant/chat'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      'Su co cua toi',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    if (state is TicketLoading)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                if (state is TicketError)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(state.message),
                  )
                else if (tickets.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      'Chua co yeu cau ho tro nao.',
                      style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6)),
                    ),
                  )
                else
                  ...tickets.map(
                    (ticket) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _IssueCard(
                        ticket: ticket,
                        cs: cs,
                        onTap: () => context.push('/tenant/issue-detail', extra: ticket),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openReport(context, _currentTickets(context), TicketCategory.other),
        backgroundColor: cs.primary,
        icon: const Icon(Icons.add_circle_rounded, color: Colors.white),
        label: const Text(
          'Bao su co moi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  List<Ticket> _currentTickets(BuildContext context) {
    final state = context.read<TicketCubit>().state;
    return state is TicketLoaded ? state.tickets : <Ticket>[];
  }

  void _openReport(
    BuildContext context,
    List<Ticket> tickets,
    TicketCategory category,
  ) {
    final seededTicket = tickets.cast<Ticket?>().firstWhere(
          (ticket) =>
              ticket != null &&
              ticket.propertyId != null &&
              ticket.propertyId!.isNotEmpty &&
              ticket.roomId.isNotEmpty,
          orElse: () => null,
        );

    context.push(
      '/tenant/services/report',
      extra: TenantReportIssueArgs(
        propertyId: seededTicket?.propertyId,
        roomId: seededTicket?.roomId,
        locationLabel: seededTicket?.roomName ?? 'Phong hien tai',
        initialCategory: category,
      ),
    );
  }
}

class _ActiveIssueBanner extends StatelessWidget {
  final List<Ticket> activeTickets;
  final VoidCallback? onTap;

  const _ActiveIssueBanner({
    required this.activeTickets,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasActiveIssue = activeTickets.isNotEmpty;
    final color = hasActiveIssue ? Colors.orange : Colors.green;
    final ticket = hasActiveIssue ? activeTickets.first : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.build_rounded, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasActiveIssue
                        ? '${activeTickets.length} yeu cau dang xu ly'
                        : 'Khong co su co dang mo',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  Text(
                    hasActiveIssue
                        ? '${ticket!.title} · ${ticket.status.displayName}'
                        : 'He thong dang hoat dong binh thuong',
                    style: TextStyle(fontSize: 12, color: color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: color.withValues(alpha: 0.7)),
          ],
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26, color: color),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}

class _IssueCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onTap;
  final ColorScheme cs;

  const _IssueCard({
    required this.ticket,
    required this.onTap,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _statusColor(ticket.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.engineering_rounded,
                  size: 20,
                  color: _statusColor(ticket.status),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.title,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      ticket.roomName ?? ticket.createdAt.toIso8601String(),
                      style: TextStyle(fontSize: 11, color: cs.onSurface.withValues(alpha: 0.45)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _statusColor(ticket.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  ticket.status.displayName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _statusColor(ticket.status),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Color _statusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.pending:
        return Colors.orange;
      case TicketStatus.inProgress:
        return Colors.blue;
      case TicketStatus.resolved:
        return Colors.green;
      case TicketStatus.cancelled:
        return Colors.grey;
    }
  }
}
