import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';

final appRouter = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomePage(),
    ),
  ],
);
