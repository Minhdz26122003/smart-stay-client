import 'package:flutter_test/flutter_test.dart';
import 'package:smart_stay_client/core/theme/app_theme.dart';

void main() {
  test('AppTheme returns light theme with Harmonious Host primary color', () {
    final theme = AppTheme.lightTheme;
    expect(theme.primaryColor.value, 0xFF00685F); // Deep Teal
  });
}
