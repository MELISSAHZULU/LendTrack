import 'package:lendtrack_app/core/constants/api_constants.dart';
import 'package:lendtrack_app/data/models/user.dart';
import 'package:lendtrack_app/data/services/api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get('/users/me/');
      return User.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.register,
        data: data,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
