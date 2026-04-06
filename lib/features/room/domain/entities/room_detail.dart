// lib/features/room/domain/entities/room_detail.dart

import 'room.dart';

class TenantInfo {
  final String id;
  final String fullName;
  final String phone;
  final String? email;

  const TenantInfo({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
  });

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }
}

class ContractInfo {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final double depositAmount;
  final int status; // 1 = active
  final String? scannedContractUrl;

  const ContractInfo({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.depositAmount,
    required this.status,
    this.scannedContractUrl,
  });

  bool get isActive => status == 1;

  int get remainingMonths {
    final now = DateTime.now();
    if (endDate.isBefore(now)) return 0;
    final diff = endDate.difference(now);
    return (diff.inDays / 30).ceil();
  }

  String get dateRangeLabel {
    String fmt(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    return '${fmt(startDate)} → ${fmt(endDate)}';
  }
}

class RoomDetail {
  final Room room;
  final TenantInfo? tenant;
  final ContractInfo? contract;

  const RoomDetail({
    required this.room,
    this.tenant,
    this.contract,
  });

  bool get hasActiveTenant => tenant != null && contract != null && contract!.isActive;
}
