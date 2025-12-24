import 'package:admin_panel/src/domain_model.dart';
import 'package:dio/dio.dart';

class AdminRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://tandorost-a.ir/api/v1"));

  Future<String> login(String username, String password) async {
    // Matches your FastAPI OAuth2PasswordRequestForm
    final response = await _dio.post(
      '/auth/token/',
      data: FormData.fromMap({'username': username, 'password': password}),
    );
    return response.data['access_token'];
  }

  Future<AdminStats> fetchDashboardStats(String token) async {
    // Set global header for this request batch
    final options = Options(
      headers: {
        'Authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
    );
    final results = await Future.wait([
      _dio.get(
        '/administer/read_user_count/',
        queryParameters: {
          'roles': ['admin'],
        },
        options: options,
      ),
      _dio.get(
        '/administer/read_user_count/',
        queryParameters: {
          'roles': ['trainer'],
        },
        options: options,
      ),
      _dio.get(
        '/administer/read_user_count/',
        queryParameters: {
          'roles': ['bodybuilding_coach'],
        },
        options: options,
      ),
      _dio.get('/administer/coaches_programs_count/', options: options),
      _dio.get('/administer/completed_exercise_count/', options: options),

      _dio.get(
        '/administer/coaches_purchased_programs_count/',
        queryParameters: {
          'status': ['pending_settle'],
        },
        options: options,
      ),
      _dio.get(
        '/administer/coaches_purchased_programs_count/',
        queryParameters: {
          'status': ['pending_transfer'],
        },
        options: options,
      ),
      _dio.get(
        '/administer/coaches_purchased_programs_count/',
        queryParameters: {
          'status': ['failed'],
        },
        options: options,
      ),
      _dio.get(
        '/administer/coaches_purchased_programs_count/',
        queryParameters: {
          'status': ['completed'],
        },
        options: options,
      ),
      _dio.get(
        '/administer/coaches_purchased_programs_count/',
        queryParameters: {
          'status': ['refund'],
        },
        options: options,
      ),
    ]);

    return AdminStats(
      adminUserCount: results[0].data['user_count'],
      traineeUserCount: results[1].data['user_count'],
      coachUserCount: results[2].data['user_count'],
      coachProgramCount: results[3].data['coach_program_count'],
      completedExerciseCount: results[4].data['completed_exercise_count'],
      pendingSettlePurchasedProgramsCount:
          results[5].data['coaches_purchased_programs_count'],
      pendingTransferPurchasedProgramsCount:
          results[6].data['coaches_purchased_programs_count'],
      failedPurchasedProgramsCount:
          results[7].data['coaches_purchased_programs_count'],
      completedPurchasedProgramsCount:
          results[8].data['coaches_purchased_programs_count'],
      refundPurchasedProgramsCount:
          results[9].data['coaches_purchased_programs_count'],
    );
  }
}
