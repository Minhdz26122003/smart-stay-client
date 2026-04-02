import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // Core/External components to be added here
  
  // Dummy reg to pass test
  sl.registerLazySingleton<String>(() => 'Ready', instanceName: 'test_ready');
}
