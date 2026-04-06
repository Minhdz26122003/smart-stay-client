// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/property/data/datasources/property_remote_datasource.dart';
import '../../features/property/data/repositories/property_repository_impl.dart';
import '../../features/property/domain/repositories/property_repository.dart';
import '../../features/property/presentation/cubit/property_cubit.dart';
import '../../features/room/data/datasources/room_remote_datasource.dart';
import '../../features/room/data/repositories/room_repository_impl.dart';
import '../../features/room/domain/repositories/room_repository.dart';
import '../../features/room/presentation/cubit/room_cubit.dart';
import '../../features/room/presentation/cubit/room_detail_cubit.dart';
import '../../features/ticket/data/datasources/ticket_remote_data_source.dart';
import '../../features/ticket/data/repositories/ticket_repository_impl.dart';
import '../../features/ticket/domain/repositories/ticket_repository.dart';
import '../../features/ticket/presentation/bloc/ticket_cubit.dart';
import '../../features/invoice/data/datasources/invoice_remote_datasource.dart';
import '../../features/invoice/data/repositories/invoice_repository_impl.dart';
import '../../features/invoice/domain/repositories/invoice_repository.dart';
import '../../features/meter_reading/data/datasources/meter_reading_remote_datasource.dart';
import '../../features/meter_reading/data/repositories/meter_reading_repository_impl.dart';
import '../../features/meter_reading/domain/repositories/meter_reading_repository.dart';
import '../../features/inventory/data/datasources/inventory_remote_datasource.dart';
import '../../features/inventory/data/repositories/inventory_repository_impl.dart';
import '../../features/inventory/domain/repositories/inventory_repository.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // ─── BLoCs / Cubits ──────────────────────────────────────────────────────
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => PropertyCubit(repository: sl()));
  sl.registerFactory(() => RoomCubit(repository: sl()));
  sl.registerFactory(() => TicketCubit(repository: sl()));
  sl.registerFactory(
    () => RoomDetailCubit(
      roomRepository: sl(),
      invoiceRepository: sl(),
      meterReadingRepository: sl(),
      inventoryRepository: sl(),
      ticketRepository: sl(),
    ),
  );

  // ─── Repositories ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PropertyRepository>(
    () => PropertyRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<RoomRepository>(
    () => RoomRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<TicketRepository>(
    () => TicketRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<InvoiceRepository>(
    () => InvoiceRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<MeterReadingRepository>(
    () => MeterReadingRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(dataSource: sl()),
  );

  // ─── Data Sources ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<PropertyRemoteDataSource>(
    () => PropertyRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<TicketRemoteDataSource>(
    () => TicketRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<InvoiceRemoteDataSource>(
    () => InvoiceRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<MeterReadingRemoteDataSource>(
    () => MeterReadingRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<InventoryRemoteDataSource>(
    () => InventoryRemoteDataSourceImpl(),
  );

  // Dummy reg to pass test
  sl.registerLazySingleton<String>(() => 'Ready', instanceName: 'test_ready');
}
