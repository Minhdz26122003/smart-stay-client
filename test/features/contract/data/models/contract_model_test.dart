import 'package:flutter_test/flutter_test.dart';
import 'package:smart_stay_client/features/contract/data/models/contract_model.dart';
import 'package:smart_stay_client/features/contract/domain/entities/contract.dart';

void main() {
  group('ContractModel.fromJson', () {
    test('parses property contract payload with room and tenant metadata', () {
      final json = <String, dynamic>{
        'id': 'c0000001-0000-0000-0000-000000000001',
        'roomId': 'a0000001-0000-0000-0000-000000000001',
        'tenantId': '22222222-2222-2222-2222-222222222222',
        'roomName': 'P.101',
        'tenantName': 'Tran Thi Binh',
        'tenantPhone': '0922222222',
        'depositAmount': 5000000,
        'startDate': '2025-05-31T17:00:00Z',
        'endDate': '2026-12-30T17:00:00Z',
        'status': 'Expired',
        'scannedContractUrl':
            'https://storage.smartstay.vn/contracts/hd001.jpg',
        'createdAt': '2025-05-25T03:00:00Z',
      };

      final model = ContractModel.fromJson(json);

      expect(model.roomName, 'P.101');
      expect(model.tenantName, 'Tran Thi Binh');
      expect(model.tenantPhone, '0922222222');
      expect(model.status, ContractStatus.expired);
      expect(model.createdAt, isNotNull);
      expect(
        model.scannedContractUrl,
        'https://storage.smartstay.vn/contracts/hd001.jpg',
      );
    });
  });
}
