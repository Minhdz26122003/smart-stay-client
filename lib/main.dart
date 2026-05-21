import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/config/app_config.dart';
import 'core/di/injection_container.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/property/presentation/cubit/property_cubit.dart';
import 'features/room/presentation/cubit/room_cubit.dart';
import 'features/ticket/presentation/bloc/ticket_cubit.dart';
import 'features/statistics/presentation/cubit/finance_summary_cubit.dart';
import 'features/meter_reading/presentation/cubit/meter_reading_cubit.dart';
import 'features/listing/presentation/cubit/listing_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: '.env');

  await initDI();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<AuthBloc>()..add(const AuthEvent.checkAuthSession()),
        ),
        BlocProvider(create: (_) => sl<PropertyCubit>()..loadProperties()),
        BlocProvider(
          create: (_) => sl<RoomCubit>(), // Will be loaded dynamically
        ),
        BlocProvider(create: (_) => sl<TicketCubit>()),
        BlocProvider(
          create: (_) => sl<FinanceSummaryCubit>()..loadFinanceSummary(),
        ),
        BlocProvider(create: (_) => sl<MeterReadingCubit>()..loadProperties()),
        BlocProvider(create: (_) => sl<ListingCubit>()),
      ],
      child: const SmartStayApp(),
    ),
  );
}

class SmartStayApp extends StatelessWidget {
  const SmartStayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Stay',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
