import 'package:admin_panel/src/admin_repository.dart';
import 'package:admin_panel/src/domain_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AdminState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {
  @override
  List<Object?> get props => [];
}

class AdminLoading extends AdminState {
  @override
  List<Object?> get props => [];
}

class AdminLoaded extends AdminState {
  final AdminStats stats;
  AdminLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminCubit extends Cubit<AdminState> {
  final AdminRepository repository;
  AdminCubit(this.repository) : super(AdminInitial());

  Future<void> loadDashboard(String token) async {
    _enhance_emit(AdminLoading());
    try {
      final stats = await repository.fetchDashboardStats(token);
      _enhance_emit(AdminLoaded(stats));
    } catch (e) {
      _enhance_emit(AdminError("Failed to fetch admin data"));
    }
  }

  void _enhance_emit(AdminState state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
