import 'package:admin_panel/src/admin_panel_ui/admin_state.dart';
import 'package:admin_panel/src/admin_panel_ui/auth_state.dart';
import 'package:admin_panel/src/admin_repository.dart';
import 'package:admin_panel/src/domain_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboardCubitProvider extends StatelessWidget {
  const AdminDashboardCubitProvider({super.key, required this.adminRepository});
  final AdminRepository adminRepository;

  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Better practice: Get token once or via a getter in the Cubit
    final authState = context.watch<AuthCubit>().state;
    final String token = (authState is AuthAuthenticated)
        ? authState.token
        : "";

    return Scaffold(
      backgroundColor: Colors.grey[50], // Professional soft background

      appBar: AppBar(
        title: const Text(
          "System Analytics",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AdminCubit>().loadDashboard(token),
          ),
        ],
      ),
      body: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          if (state is AdminInitial) {
            return _buildEmptyState(context, token);
          }
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (state is AdminLoaded) {
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<AdminCubit>().loadDashboard(token),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      "Platform Liquidity ",
                      "Interaction success & total users since the beginning",
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Liquidity is a state in which there are minimum numbers of producers and consumers and the percentage of successful interaction is high',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildLiquidityGrid(state.stats),

                    const SizedBox(height: 24),
                    _buildSectionHeader("User Distribution", "Growth & Roles"),
                    const SizedBox(height: 12),
                    _buildUserGrid(state.stats),
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      "Financial Health",
                      "Transactions & Refunds",
                    ),
                    const SizedBox(height: 12),
                    _buildFinancialTable(state.stats),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text("Error loading analytics"));
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildLiquidityGrid(AdminStats stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _StatCard(
          "Exercise Completion",
          stats.completedExerciseCount.toString(),
          Icons.bolt,
          Colors.orange,
        ),
        _StatCard(
          "Active Programs",
          stats.coachProgramCount.toString(),
          Icons.layers,
          Colors.purple,
        ),
        _StatCard(
          "Total user count",
          stats.totalUserCount.toString(),
          Icons.layers,
          Colors.deepOrange,
        ),
      ],
    );
  }

  Widget _buildUserGrid(AdminStats stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _UserMiniStat("Trainees", stats.traineeUserCount, Colors.green),
          _UserMiniStat("Coaches", stats.coachUserCount, Colors.blue),
          _UserMiniStat("Admins", stats.adminUserCount, Colors.red),
        ],
      ),
    );
  }

  Widget _buildFinancialTable(AdminStats stats) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _tableRow(
              "Completed Sales",
              stats.completedPurchasedProgramsCount.toString(),
              Colors.green,
            ),
            const Divider(),
            _tableRow(
              "Pending Settlement",
              stats.pendingSettlePurchasedProgramsCount.toString(),
              Colors.orange,
            ),
            const Divider(),
            _tableRow(
              "Refunds",
              stats.refundPurchasedProgramsCount.toString(),
              Colors.red,
            ),
            const Divider(),
            _tableRow(
              "Total Volume",
              stats.totalPurchasedProgramsCount.toString(),
              Colors.black,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableRow(
    String label,
    String value,
    Color color, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String token) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.analytics_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "No Data Loaded",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<AdminCubit>().loadDashboard(token),
            child: const Text("Fetch Latest Metrics"),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard(this.title, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }
}

class _UserMiniStat extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _UserMiniStat(this.label, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: context.read<AuthCubit>()),
                    BlocProvider.value(value: context.read<AdminCubit>()),
                  ],
                  child: AdminDashboardPage(),
                ),
              ),
            );
          }
        },
        child: Center(
          child: SizedBox(
            width: 480,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tandorost Administrator Panel',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _userController,
                    decoration: InputDecoration(labelText: "Username"),
                  ),
                  TextField(
                    controller: _passController,
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.read<AuthCubit>().login(
                      _userController.text,
                      _passController.text,
                    ),
                    child: Text("Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
