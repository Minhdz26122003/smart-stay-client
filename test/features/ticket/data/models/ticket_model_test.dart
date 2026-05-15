import 'package:flutter_test/flutter_test.dart';
import 'package:smart_stay_client/features/ticket/data/models/ticket_model.dart';
import 'package:smart_stay_client/features/ticket/domain/entities/ticket.dart';

void main() {
  group('TicketModel.fromJson', () {
    test('parses backend string payload for category priority and status', () {
      final json = <String, dynamic>{
        'id': '5fb4e510-fca0-4130-a069-17effc409608',
        'roomId': 'a0000001-0000-0000-0000-000000000001',
        'tenantId': '22222222-2222-2222-2222-222222222222',
        'category': 'Water',
        'title': 'Voi nuoc bon rua mat bi ri',
        'description': 'Backend returns business labels instead of ints.',
        'photoUrls': <String>[
          'https://storage.smartstay.vn/tickets/water_leak.jpg',
        ],
        'status': 'Pending',
        'priority': 'Medium',
        'createdAt': '2026-04-04T04:02:42.344849Z',
      };

      final model = TicketModel.fromJson(json);

      expect(model.category, TicketCategory.water);
      expect(model.priority, TicketPriority.medium);
      expect(model.status, TicketStatus.open);
    });
  });
}
