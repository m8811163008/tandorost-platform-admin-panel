import 'package:admin_panel/src/admin_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;
  AuthAuthenticated(this.token);

  @override
  List<Object?> get props => [token];
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthCubit extends Cubit<AuthState> {
  final AdminRepository repository;
  AuthCubit(this.repository) : super(AuthInitial());

  Future<void> login(String username, String password) async {
    _enhance_emit(AuthLoading());
    try {
      final token = await repository.login(username, password);
      _enhance_emit(AuthAuthenticated(token));
    } catch (e) {
      _enhance_emit(AuthError("Invalid credentials or server error"));
    }
  }

  void _enhance_emit(AuthState state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
