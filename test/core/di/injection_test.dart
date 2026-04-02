import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_stay_client/core/di/injection_container.dart';

void main() {
  test('Di is initialized completely', () async {
    await initDI();
    expect(GetIt.I.isRegistered<String>(instanceName: 'test_ready'), true);
  });
}
