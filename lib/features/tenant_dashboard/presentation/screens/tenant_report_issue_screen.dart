import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../ticket/domain/entities/ticket.dart';
import '../../../ticket/presentation/bloc/ticket_cubit.dart';
import '../../../ticket/presentation/bloc/ticket_state.dart';

class TenantReportIssueArgs {
  final String? propertyId;
  final String? roomId;
  final String? locationLabel;
  final TicketCategory? initialCategory;

  const TenantReportIssueArgs({
    this.propertyId,
    this.roomId,
    this.locationLabel,
    this.initialCategory,
  });
}

class TenantReportIssueScreen extends StatefulWidget {
  final TenantReportIssueArgs? args;

  const TenantReportIssueScreen({super.key, this.args});

  @override
  State<TenantReportIssueScreen> createState() => _TenantReportIssueScreenState();
}

class _TenantReportIssueScreenState extends State<TenantReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final Color _green = const Color(0xFF1A8A5A);

  late TicketCategory _selectedCategory;
  late TicketPriority _selectedPriority;
  late String _location;
  bool _isSubmittingVisible = false;

  static const _fallbackLocation = 'Phong hien tai';

  static const _categories = [
    (TicketCategory.electricity, Icons.electrical_services_rounded, 'Dien'),
    (TicketCategory.water, Icons.water_drop_rounded, 'Nuoc'),
    (TicketCategory.furniture, Icons.chair_rounded, 'Noi that'),
    (TicketCategory.other, Icons.build_circle_outlined, 'Khac'),
  ];

  static const _locations = [
    'Phong hien tai',
    'Phong tam',
    'Bep',
    'Khu vuc chung',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.args?.initialCategory ?? TicketCategory.other;
    _selectedPriority = TicketPriority.urgent;
    _location = widget.args?.locationLabel ?? _fallbackLocation;
    if (!_locations.contains(_location)) {
      _location = _fallbackLocation;
    }
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roomContext = _resolveTicketContext(context.read<TicketCubit>().state);

    return BlocListener<TicketCubit, TicketState>(
      listener: (context, state) {
        if (state is TicketSubmitting) {
          _isSubmittingVisible = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is TicketSubmitSuccess) {
          _closeSubmittingDialog(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Da gui bao cao su co thanh cong.'),
              backgroundColor: _green,
            ),
          );
          context.pop(true);
        } else if (state is TicketSubmitError) {
          _closeSubmittingDialog(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
            onPressed: () => context.pop(),
            color: _green,
          ),
          title: const Text(
            'Bao cao su co',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: roomContext == null
                        ? Colors.orange.withValues(alpha: 0.1)
                        : _green.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: roomContext == null
                          ? Colors.orange.withValues(alpha: 0.4)
                          : _green.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    roomContext == null
                        ? 'Chua xac dinh duoc phong thue hien tai. Vui long mo ticket cu hoac truyen room context truoc khi gui.'
                        : 'Dang gui cho ${roomContext.locationLabel}.',
                    style: TextStyle(
                      fontSize: 12,
                      color: roomContext == null ? Colors.orange.shade800 : _green,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Danh muc *',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.3,
                  children: _categories.map((entry) {
                    final isSelected = _selectedCategory == entry.$1;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = entry.$1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? _green : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? _green : Colors.grey.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              entry.$2,
                              color: isSelected ? Colors.white : _green,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                entry.$3,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  'Vi tri *',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _location,
                      isExpanded: true,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _location = value);
                        }
                      },
                      items: _locations
                          .map(
                            (location) => DropdownMenuItem(
                              value: location,
                              child: Text(location),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Mo ta van de *',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descCtrl,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui long mo ta su co';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Mo ta chi tiet su co...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _green),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Muc do uu tien',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                _PriorityOption(
                  label: 'Khan cap',
                  subtitle: 'Anh huong sinh hoat, can xu ly ngay',
                  color: Colors.red.shade600,
                  selected: _selectedPriority == TicketPriority.urgent,
                  onTap: () => setState(() => _selectedPriority = TicketPriority.urgent),
                ),
                const SizedBox(height: 8),
                _PriorityOption(
                  label: 'Binh thuong',
                  subtitle: 'Co the cho, xu ly trong 2-3 ngay',
                  color: Colors.orange.shade700,
                  selected: _selectedPriority == TicketPriority.medium,
                  onTap: () => setState(() => _selectedPriority = TicketPriority.medium),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => _submit(context),
                    icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                    label: const Text(
                      'Gui bao cao su co',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final roomContext = _resolveTicketContext(context.read<TicketCubit>().state);
    if (roomContext == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Khong xac dinh duoc phong thue hien tai de tao ticket.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<TicketCubit>().createTicket(
          propertyId: roomContext.propertyId,
          roomId: roomContext.roomId,
          title: '${_selectedCategory.displayName} - $_location',
          description: _descCtrl.text.trim(),
          category: _selectedCategory,
          priority: _selectedPriority,
        );
  }

  _TicketRoomContext? _resolveTicketContext(TicketState state) {
    final propertyId = widget.args?.propertyId;
    final roomId = widget.args?.roomId;
    if (propertyId != null && propertyId.isNotEmpty && roomId != null && roomId.isNotEmpty) {
      return _TicketRoomContext(
        propertyId: propertyId,
        roomId: roomId,
        locationLabel: widget.args?.locationLabel ?? _fallbackLocation,
      );
    }

    if (state is TicketLoaded) {
      for (final ticket in state.tickets) {
        final seededPropertyId = ticket.propertyId;
        if (seededPropertyId != null &&
            seededPropertyId.isNotEmpty &&
            ticket.roomId.isNotEmpty) {
          return _TicketRoomContext(
            propertyId: seededPropertyId,
            roomId: ticket.roomId,
            locationLabel: ticket.roomName ?? _fallbackLocation,
          );
        }
      }
    }

    return null;
  }

  void _closeSubmittingDialog(BuildContext context) {
    if (_isSubmittingVisible) {
      Navigator.of(context, rootNavigator: true).pop();
      _isSubmittingVisible = false;
    }
  }
}

class _PriorityOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _PriorityOption({
    required this.label,
    required this.subtitle,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : Colors.grey.shade200,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.priority_high_rounded, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_circle_rounded, color: color),
          ],
        ),
      ),
    );
  }
}

class _TicketRoomContext {
  final String propertyId;
  final String roomId;
  final String locationLabel;

  const _TicketRoomContext({
    required this.propertyId,
    required this.roomId,
    required this.locationLabel,
  });
}
