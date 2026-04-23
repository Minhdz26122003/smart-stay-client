// lib/features/room/data/models/room_detail_model.dart
import '../../domain/entities/room_detail.dart';
import '../../../../features/invoice/data/models/invoice_model.dart';
import 'room_model.dart';

class TenantInfoModel {
  final String id;
  final String fullName;
  final String phone;
  final String? email;

  const TenantInfoModel({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
  });

  factory TenantInfoModel.fromJson(Map<String, dynamic> json) {
    return TenantInfoModel(
      id: (json['id'] ?? json['tenantId'])?.toString() ?? '',
      fullName: (json['fullName'] ?? json['tenantName'])?.toString() ?? 'Không rõ',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString(),
    );
  }

  TenantInfo toEntity() => TenantInfo(
        id: id,
        fullName: fullName,
        phone: phone,
        email: email,
      );
}

class ContractInfoModel {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final double depositAmount;
  final int status;
  final String? scannedContractUrl;

  const ContractInfoModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.depositAmount,
    required this.status,
    this.scannedContractUrl,
  });

  factory ContractInfoModel.fromJson(Map<String, dynamic> json) {
    return ContractInfoModel(
      id: json['id']?.toString() ?? '',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : DateTime.now(),
      depositAmount: (json['depositAmount'] as num?)?.toDouble() ?? 0,
      status: _parseStatus(json['status']),
      scannedContractUrl: json['scannedContractUrl'] as String?,
    );
  }

  static int _parseStatus(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toInt();
    if (v is String) {
      if (v.toLowerCase() == 'active' || v == '1') return 1;
      if (v == '0') return 0;
    }
    return 0;
  }

  ContractInfo toEntity() => ContractInfo(
        id: id,
        startDate: startDate,
        endDate: endDate,
        depositAmount: depositAmount,
        status: status,
        scannedContractUrl: scannedContractUrl,
      );
}

class RoomDetailModel {
  final RoomModel room;
  final TenantInfoModel? tenant;
  final ContractInfoModel? contract;
  final List<InvoiceModel> invoices;

  const RoomDetailModel({
    required this.room,
    this.tenant,
    this.contract,
    this.invoices = const [],
  });

  factory RoomDetailModel.fromJson(Map<String, dynamic> json) {
    // The API may return nested tenant/contract, or flat fields
    TenantInfoModel? tenant;
    ContractInfoModel? contract;

    final tenantJson = json['tenant'] as Map<String, dynamic>?;
    final contractJson = json['contract'] as Map<String, dynamic>?
        ?? json['activeContract'] as Map<String, dynamic>?;

    // If API returns tenantName inline (flat structure)
    if (tenantJson != null) {
      tenant = TenantInfoModel.fromJson(tenantJson);
    } else if (json['tenantId'] != null) {
      tenant = TenantInfoModel.fromJson({
        'id': json['tenantId'],
        'fullName': json['tenantName'] ?? 'Không rõ',
        'phone': json['tenantPhone'] ?? '',
        'email': json['tenantEmail'],
      });
    }

    if (contractJson != null) {
      contract = ContractInfoModel.fromJson(contractJson);
    }

    // Parse invoices
    final invoicesJson = json['invoices'] as List<dynamic>? ?? [];
    final invoices = invoicesJson
        .map((j) => InvoiceModel.fromJson(j as Map<String, dynamic>))
        .toList();

    return RoomDetailModel(
      room: RoomModel.fromJson(json),
      tenant: tenant,
      contract: contract,
      invoices: invoices,
    );
  }

  RoomDetail toEntity() => RoomDetail(
        room: room.toEntity(),
        tenant: tenant?.toEntity(),
        contract: contract?.toEntity(),
        invoices: invoices.map((m) => m.toEntity()).toList(),
      );
}
