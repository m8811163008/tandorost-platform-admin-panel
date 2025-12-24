import 'package:admin_panel/src/admin_panel_ui/admin_state.dart';
import 'package:admin_panel/src/admin_panel_ui/admin_view.dart';
import 'package:admin_panel/src/admin_panel_ui/auth_state.dart';
import 'package:admin_panel/src/admin_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final adminRepository = AdminRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AdminCubit(adminRepository)),
        BlocProvider(create: (context) => AuthCubit(adminRepository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AdminDashboardCubitProvider(adminRepository: adminRepository),
      ),
    ),
  );
}
