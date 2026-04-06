import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      await event.map(
        checkAuthSession: (e) async {
          emit(const AuthState.loading());
          try {
            final user = await _authRepository.getCurrentUser();
            if (user != null) {
              emit(AuthState.authenticated(user: user));
            } else {
              emit(const AuthState.unauthenticated());
            }
          } catch (_) {
            emit(const AuthState.unauthenticated());
          }
        },
        loginRequested: (e) async {
          emit(const AuthState.loading());
          try {
            final user = await _authRepository.login(
              email: e.email,
              password: e.password,
              rememberMe: e.rememberMe,
            );
            emit(AuthState.authenticated(user: user));
          } catch (err) {
            emit(AuthState.failure(
                message: err.toString().replaceAll('Exception: ', '')));
          }
        },
        registerRequested: (e) async {
          emit(const AuthState.loading());
          try {
            final user = await _authRepository.register(
              fullName: e.fullName,
              email: e.email,
              password: e.password,
              role: e.role,
            );
            emit(AuthState.authenticated(user: user));
          } catch (err) {
            emit(AuthState.failure(
                message: err.toString().replaceAll('Exception: ', '')));
          }
        },
        logoutRequested: (e) async {
          await _authRepository.logout();
          emit(const AuthState.unauthenticated());
        },
      );
    });
  }
}
