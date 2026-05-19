import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../contract/domain/entities/contract.dart';
import '../../../contract/presentation/cubit/contract_cubit.dart';
import '../../../contract/presentation/cubit/contract_state.dart';
import '../../../property/presentation/cubit/property_cubit.dart';
import '../../../property/presentation/cubit/property_state.dart';

class LandlordContractsScreen extends StatelessWidget {
  const LandlordContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ContractCubit>(),
      child: const _LandlordContractsView(),
    );
  }
}

class _LandlordContractsView extends StatefulWidget {
  const _LandlordContractsView();

  @override
  State<_LandlordContractsView> createState() => _LandlordContractsViewState();
}

class _LandlordContractsViewState extends State<_LandlordContractsView> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedTab = 'Tat ca';
  String _searchQuery = '';
  String? _lastLoadedPropertyId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadContractsForSelectedProperty();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String? _selectedPropertyId() {
    return context.read<PropertyCubit>().state.maybeWhen(
      loaded: (properties, selectedProperty) =>
          selectedProperty?.id ??
          (properties.isNotEmpty ? properties.first.id : null),
      orElse: () => null,
    );
  }

  void _loadContractsForSelectedProperty({bool force = false}) {
    final propertyId = _selectedPropertyId();
    if (propertyId == null) {
      return;
    }
    if (!force && propertyId == _lastLoadedPropertyId) {
      return;
    }
    _lastLoadedPropertyId = propertyId;
    context.read<ContractCubit>().loadContractsByProperty(propertyId);
  }

  bool _isExpiringSoon(Contract contract) {
    if (contract.status != ContractStatus.active) {
      return false;
    }

    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final normalizedEndDate = DateTime(
      contract.endDate.year,
      contract.endDate.month,
      contract.endDate.day,
    );
    final daysLeft = normalizedEndDate.difference(normalizedToday).inDays;
    return daysLeft >= 0 && daysLeft <= 30;
  }

  bool _isEnded(Contract contract) {
    return contract.status == ContractStatus.expired ||
        contract.status == ContractStatus.terminated;
  }

  List<Contract> _sortContracts(List<Contract> contracts) {
    final sorted = List<Contract>.from(contracts);
    sorted.sort((a, b) {
      final left = a.createdAt ?? a.startDate;
      final right = b.createdAt ?? b.startDate;
      return right.compareTo(left);
    });
    return sorted;
  }

  List<Contract> _filterContracts(List<Contract> contracts) {
    final query = _searchQuery.trim().toLowerCase();

    return contracts.where((contract) {
      final matchesQuery =
          query.isEmpty ||
          (contract.roomName ?? '').toLowerCase().contains(query) ||
          (contract.tenantName ?? '').toLowerCase().contains(query);

      if (!matchesQuery) {
        return false;
      }

      switch (_selectedTab) {
        case 'Dang hoat dong':
          return contract.status == ContractStatus.active &&
              !_isExpiringSoon(contract);
        case 'Sap het han':
          return _isExpiringSoon(contract);
        case 'Da het han':
          return _isEnded(contract);
        case 'Tat ca':
        default:
          return true;
      }
    }).toList();
  }

  String _formatPrice(double price) {
    final value = price.toStringAsFixed(0);
    return '${value.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')} d';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _statusLabel(Contract contract) {
    if (_isExpiringSoon(contract)) {
      return 'Sap het han';
    }

    switch (contract.status) {
      case ContractStatus.active:
        return 'Dang hoat dong';
      case ContractStatus.expired:
        return 'Da het han';
      case ContractStatus.terminated:
        return 'Da ket thuc';
      case ContractStatus.draft:
        return 'Ban nhap';
    }
  }

  Color _statusColor(ColorScheme cs, Contract contract) {
    if (_isExpiringSoon(contract)) {
      return Colors.orange;
    }

    switch (contract.status) {
      case ContractStatus.active:
        return Colors.green;
      case ContractStatus.expired:
      case ContractStatus.terminated:
        return cs.error;
      case ContractStatus.draft:
        return cs.primary;
    }
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
        title: Text(
          'Quan ly hop dong',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocListener<PropertyCubit, PropertyState>(
        listener: (context, state) {
          state.maybeWhen(
            loaded: (properties, selectedProperty) {
              final nextPropertyId =
                  selectedProperty?.id ??
                  (properties.isNotEmpty ? properties.first.id : null);
              if (nextPropertyId != null &&
                  nextPropertyId != _lastLoadedPropertyId) {
                _loadContractsForSelectedProperty(force: true);
              }
            },
            orElse: () {},
          );
        },
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Tim kiem phong, ten khach thue...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        prefixIcon: Icon(Icons.search_rounded, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<ContractCubit, ContractState>(
                    builder: (context, state) {
                      final contracts = state is ContractLoaded
                          ? _sortContracts(state.contracts)
                          : <Contract>[];
                      final totalActive = contracts
                          .where(
                            (contract) =>
                                contract.status == ContractStatus.active &&
                                !_isExpiringSoon(contract),
                          )
                          .length;
                      final totalExpiring = contracts
                          .where(_isExpiringSoon)
                          .length;
                      final totalEnded = contracts.where(_isEnded).length;

                      return Row(
                        children: [
                          _MetricCard(
                            label: 'Dang chay',
                            value: totalActive.toString(),
                            color: Colors.green,
                            bgColor: Colors.green.shade50,
                          ),
                          const SizedBox(width: 8),
                          _MetricCard(
                            label: 'Sap het han',
                            value: totalExpiring.toString(),
                            color: Colors.orange,
                            bgColor: Colors.orange.shade50,
                          ),
                          const SizedBox(width: 8),
                          _MetricCard(
                            label: 'Da het han',
                            value: totalEnded.toString(),
                            color: cs.error,
                            bgColor: cs.error.withValues(alpha: 0.08),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 52,
              color: Colors.white,
              child: BlocBuilder<ContractCubit, ContractState>(
                builder: (context, state) {
                  final contracts = state is ContractLoaded
                      ? _sortContracts(state.contracts)
                      : <Contract>[];
                  final totalActive = contracts
                      .where(
                        (contract) =>
                            contract.status == ContractStatus.active &&
                            !_isExpiringSoon(contract),
                      )
                      .length;
                  final totalExpiring = contracts.where(_isExpiringSoon).length;
                  final totalEnded = contracts.where(_isEnded).length;

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    children: [
                      _FilterChip(
                        label: 'Tat ca',
                        count: contracts.length,
                        isSelected: _selectedTab == 'Tat ca',
                        onTap: () => setState(() => _selectedTab = 'Tat ca'),
                        cs: cs,
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Dang hoat dong',
                        count: totalActive,
                        isSelected: _selectedTab == 'Dang hoat dong',
                        onTap: () => setState(
                          () => _selectedTab = 'Dang hoat dong',
                        ),
                        cs: cs,
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Sap het han',
                        count: totalExpiring,
                        isSelected: _selectedTab == 'Sap het han',
                        onTap: () => setState(
                          () => _selectedTab = 'Sap het han',
                        ),
                        cs: cs,
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Da het han',
                        count: totalEnded,
                        isSelected: _selectedTab == 'Da het han',
                        onTap: () => setState(() => _selectedTab = 'Da het han'),
                        cs: cs,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<ContractCubit, ContractState>(
                builder: (context, state) {
                  final propertyId = _selectedPropertyId();
                  if (propertyId == null) {
                    return _ContractsMessage(
                      icon: Icons.home_work_outlined,
                      message: 'Chua co khu tro duoc chon',
                      color: cs.onSurface.withValues(alpha: 0.5),
                    );
                  }

                  if (state is ContractLoading || state is ContractInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ContractError) {
                    return _ContractsMessage(
                      icon: Icons.error_outline_rounded,
                      message: 'Loi: ${state.message}',
                      color: cs.error,
                    );
                  }

                  if (state is! ContractLoaded) {
                    return const SizedBox.shrink();
                  }

                  final filteredContracts = _filterContracts(
                    _sortContracts(state.contracts),
                  );

                  if (filteredContracts.isEmpty) {
                    return _ContractsMessage(
                      icon: Icons.description_outlined,
                      message: 'Khong tim thay hop dong nao',
                      color: cs.onSurface.withValues(alpha: 0.5),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                    itemCount: filteredContracts.length,
                    itemBuilder: (context, index) {
                      final contract = filteredContracts[index];
                      return _ContractRowCard(
                        roomName: contract.roomName ?? 'Phong',
                        tenantName: contract.tenantName ?? 'Khach thue',
                        tenantPhone: contract.tenantPhone ?? '--',
                        depositFormatted: _formatPrice(contract.depositAmount),
                        dateRange:
                            '${_formatDate(contract.startDate)} - ${_formatDate(contract.endDate)}',
                        statusLabel: _statusLabel(contract),
                        statusColor: _statusColor(cs, contract),
                        onTap: () => context.push(
                          '/landlord/operations/room-detail',
                          extra: contract.roomId,
                        ),
                        theme: theme,
                        cs: cs,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: cs.primary,
        onPressed: () => context.push('/landlord/operations/create-contract'),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tao hop dong',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _ContractsMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;

  const _ContractsMessage({
    required this.icon,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: color),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme cs;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContractRowCard extends StatelessWidget {
  final String roomName;
  final String tenantName;
  final String tenantPhone;
  final String depositFormatted;
  final String dateRange;
  final String statusLabel;
  final Color statusColor;
  final VoidCallback onTap;
  final ThemeData theme;
  final ColorScheme cs;

  const _ContractRowCard({
    required this.roomName,
    required this.tenantName,
    required this.tenantPhone,
    required this.depositFormatted,
    required this.dateRange,
    required this.statusLabel,
    required this.statusColor,
    required this.onTap,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.description_rounded,
                              color: cs.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  roomName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  tenantName,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'So dien thoai',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tenantPhone,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dat coc',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            depositFormatted,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          dateRange,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
