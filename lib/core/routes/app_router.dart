import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/invoice/domain/entities/invoice.dart';

// Auth
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/otp_verify_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';

// Landlord Shell + Tabs
import '../../features/landlord_dashboard/presentation/screens/landlord_shell_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_home_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_finance_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_operations_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_notifications_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_profile_screen.dart';

// Landlord Finance Sub-screens
import '../../features/landlord_dashboard/presentation/screens/landlord_invoice_detail_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_invoice_settle_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_payment_info_screen.dart';

// Landlord Operations Sub-screens
import '../../features/landlord_dashboard/presentation/screens/landlord_rooms_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_room_detail_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_post_room_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_add_room_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_listings_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_create_contract_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_issues_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_issue_detail_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_checkout_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_board_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_appointments_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_messages_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_chat_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_meter_scan_screen.dart';
import '../../features/ticket/domain/entities/ticket.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_create_contract_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_board_screen.dart';
import '../../features/landlord_dashboard/presentation/screens/landlord_add_board_post_screen.dart';

// Tenant Shell + Tabs
import '../../features/tenant_dashboard/presentation/screens/tenant_shell_screen.dart';
import '../../features/tenant_dashboard/presentation/screens/tenant_home_screen.dart';
import '../../features/tenant_dashboard/presentation/screens/tenant_invoices_screen.dart';
import '../../features/tenant_dashboard/presentation/screens/tenant_services_screen.dart';
import '../../features/tenant_dashboard/presentation/screens/tenant_notifications_screen.dart';
import '../../features/tenant_dashboard/presentation/screens/tenant_profile_screen.dart';

// Tenant Sub-screens
import '../../features/tenant_dashboard/presentation/screens/tenant_invoice_detail_screen.dart';
import '../../features/tenant_dashboard/presentation/screens/tenant_my_room_screen.dart';
import '../../features/tenant_dashboard/presentation/screens/tenant_contract_screen.dart';
import '../../features/tenant_dashboard/presentation/screens/tenant_report_issue_screen.dart';
import '../../features/tenant_dashboard/presentation/screens/tenant_issue_detail_screen.dart';
import '../../features/tenant_dashboard/presentation/screens/tenant_chat_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/welcome',
  routes: [
    // ─── AUTH ─────────────────────────────────────────────────────────────────
    GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(
      path: '/forgot-password',
      builder: (_, __) => const ForgotPasswordScreen(),
    ),
    GoRoute(path: '/otp-verify', builder: (_, __) => const OtpVerifyScreen()),
    GoRoute(
      path: '/reset-password',
      builder: (_, __) => const ResetPasswordScreen(),
    ),

    // ─── LANDLORD SHELL (5 TABS) ──────────────────────────────────────────────
    StatefulShellRoute.indexedStack(
      builder: (_, __, navigationShell) =>
          LandlordShellScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/landlord',
              builder: (_, __) => const LandlordHomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/landlord/finance',
              builder: (_, __) => const LandlordFinanceScreen(),
              routes: [
                GoRoute(
                  path: 'invoice-detail',
                  builder: (_, state) {
                    final invoice = state.extra as Invoice?;
                    return LandlordInvoiceDetailScreen(invoice: invoice);
                  },
                ),
                GoRoute(
                  path: 'settle',
                  builder: (_, __) => const LandlordInvoiceSettleScreen(),
                ),
                GoRoute(
                  path: 'payment-info',
                  builder: (_, __) => const LandlordPaymentInfoScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/landlord/operations',
              builder: (_, __) => const LandlordOperationsScreen(),
              routes: [
                GoRoute(
                  path: 'rooms',
                  builder: (_, __) => const LandlordRoomsScreen(),
                ),
                GoRoute(
                  path: 'room-detail',
                  builder: (_, state) {
                    final roomId = state.extra as String? ?? '';
                    return LandlordRoomDetailScreen(roomId: roomId);
                  },
                ),
                GoRoute(
                  path: 'add',
                  builder: (_, __) => const LandlordPostRoomScreen(),
                ),
                GoRoute(
                  path: 'add-room',
                  builder: (_, __) => const LandlordAddRoomScreen(),
                ),
                GoRoute(
                  path: 'listings',
                  builder: (_, __) => const LandlordListingsScreen(),
                ),
                GoRoute(
                  path: 'create-contract',
                  builder: (_, __) => const LandlordCreateContractScreen(),
                ),
                GoRoute(
                  path: 'issues',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (_, __) => const LandlordIssuesScreen(),
                ),
                GoRoute(
                  path: 'issue-detail',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final ticket = state.extra as Ticket?;
                    if (ticket == null) return const LandlordIssuesScreen();
                    return LandlordIssueDetailScreen(ticket: ticket);
                  },
                ),
                GoRoute(
                  path: 'checkout',
                  builder: (_, __) => const LandlordCheckoutScreen(),
                ),
                GoRoute(
                  path: 'board',
                  builder: (_, __) => const LandlordBoardScreen(),
                ),
                GoRoute(
                  path: 'appointments',
                  builder: (_, __) => const LandlordAppointmentsScreen(),
                ),
                GoRoute(
                  path: 'messages',
                  builder: (_, __) => const LandlordMessagesScreen(),
                ),
                GoRoute(
                  path: 'chat',
                  builder: (_, __) => const LandlordChatScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/landlord/notifications',
              builder: (_, __) => const LandlordNotificationsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/landlord/profile',
              builder: (_, __) => const LandlordProfileScreen(),
              routes: [
                GoRoute(
                  path: 'payment-info',
                  builder: (_, __) => const LandlordPaymentInfoScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // ─── LANDLORD STANDALONE ROUTES (push từ nhiều nơi) ──────────────────────
    GoRoute(
      path: '/landlord/chat',
      builder: (_, __) => const LandlordChatScreen(),
    ),
    GoRoute(
      path: '/landlord/add',
      builder: (_, __) => const LandlordPostRoomScreen(),
    ),
    GoRoute(
      path: '/landlord/meter-scan',
      builder: (_, __) => const LandlordMeterScanScreen(),
    ),
    GoRoute(
      path: '/landlord/create-contract',
      builder: (_, __) => const LandlordCreateContractScreen(),
    ),
    GoRoute(
      path: '/landlord/board',
      builder: (_, __) => const LandlordBoardScreen(),
    ),
    GoRoute(
      path: '/landlord/add-board-post',
      builder: (_, state) {
        final propertyId = state.extra as String? ?? '';
        return LandlordAddBoardPostScreen(propertyId: propertyId);
      },
    ),

    // ─── TENANT SHELL (5 TABS) ────────────────────────────────────────────────
    StatefulShellRoute.indexedStack(
      builder: (_, __, navigationShell) =>
          TenantShellScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tenant',
              builder: (_, __) => const TenantHomeScreen(),
              routes: [
                GoRoute(
                  path: 'my-room',
                  builder: (_, __) => const TenantMyRoomScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tenant/invoices',
              builder: (_, __) => const TenantInvoicesScreen(),
              routes: [
                GoRoute(
                  path: 'detail',
                  builder: (_, __) => const TenantInvoiceDetailScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tenant/services',
              builder: (_, __) => const TenantServicesScreen(),
              routes: [
                GoRoute(
                  path: 'report',
                  builder: (_, __) => const TenantReportIssueScreen(),
                ),
                GoRoute(
                  path: 'issue-detail',
                  builder: (_, __) => const TenantIssueDetailScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tenant/notifications',
              builder: (_, __) => const TenantNotificationsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tenant/profile',
              builder: (_, __) => const TenantProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // ─── TENANT STANDALONE ROUTES (push từ nhiều nơi) ────────────────────────
    GoRoute(path: '/tenant/chat', builder: (_, __) => const TenantChatScreen()),
    GoRoute(
      path: '/tenant/contract',
      builder: (_, __) => const TenantContractScreen(),
    ),

    GoRoute(
      path: '/tenant/services/report',
      builder: (_, __) => const TenantReportIssueScreen(),
    ),
    GoRoute(
      path: '/tenant/issue-detail',
      builder: (_, __) => const TenantIssueDetailScreen(),
    ),
    GoRoute(
      path: '/tenant/invoice-detail',
      builder: (_, __) => const TenantInvoiceDetailScreen(),
    ),
  ],
);
