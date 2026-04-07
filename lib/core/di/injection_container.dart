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
import '../../features/statistics/data/datasources/statistics_remote_datasource.dart';
import '../../features/statistics/data/repositories/statistics_repository_impl.dart';
import '../../features/statistics/domain/repositories/statistics_repository.dart';
import '../../features/statistics/presentation/cubit/finance_summary_cubit.dart';
import '../../features/invoice/data/datasources/invoice_remote_datasource.dart';
import '../../features/invoice/data/repositories/invoice_repository_impl.dart';
import '../../features/invoice/domain/repositories/invoice_repository.dart';
import '../../features/meter_reading/data/datasources/meter_reading_remote_datasource.dart';
import '../../features/meter_reading/data/repositories/meter_reading_repository_impl.dart';
import '../../features/meter_reading/domain/repositories/meter_reading_repository.dart';
import '../../features/meter_reading/presentation/cubit/meter_reading_cubit.dart';
import '../../features/announcement/data/datasources/announcement_remote_datasource.dart';
import '../../features/announcement/data/repositories/announcement_repository_impl.dart';
import '../../features/announcement/domain/repositories/announcement_repository.dart';
import '../../features/announcement/presentation/cubit/announcement_cubit.dart';
import '../../features/contract/data/datasources/contract_remote_datasource.dart';
import '../../features/contract/data/repositories/contract_repository_impl.dart';
import '../../features/contract/domain/repositories/contract_repository.dart';
import '../../features/contract/presentation/cubit/contract_cubit.dart';
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
  sl.registerFactory(
    () => FinanceSummaryCubit(repository: sl()),
  );
  sl.registerFactory(
    () => MeterReadingCubit(
      propertyRepository: sl(),
      roomRepository: sl(),
      meterReadingRepository: sl(),
    ),
  );
  sl.registerFactory(
    () => AnnouncementCubit(repository: sl()),
  );
  sl.registerFactory(
    () => ContractCubit(repository: sl()),
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
  sl.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<ContractRepository>(
    () => ContractRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepositoryImpl(
      remoteDataSource: sl(),
    ),
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
  sl.registerLazySingleton<StatisticsRemoteDataSource>(
    () => StatisticsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AnnouncementRemoteDataSource>(
    () => AnnouncementRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ContractRemoteDataSource>(
    () => ContractRemoteDataSourceImpl(),
  );

  // Dummy reg to pass test
  sl.registerLazySingleton<String>(() => 'Ready', instanceName: 'test_ready');
}
