import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../models/user.dart';
import '../network/api_client.dart';
import '../constants/api_constants.dart';
import '../error/failures.dart';
import '../services/auth_service.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String name, String email, String password, String? phone);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> updateFcmToken(String token);
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final user = User.fromJson(response.data['user']);
      final token = response.data['token'];
      
      // Store token for future requests
      final authService = getx.Get.find<AuthService>();
      await authService.setToken(token);
      
      return Right(user);
    } on DioException catch (e) {
      return Left(AuthFailure(e.response?.data['message'] ?? 'Login failed'));
    } catch (e) {
      return Left(AuthFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, User>> register(String name, String email, String password, String? phone) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        },
      );

      final user = User.fromJson(response.data['user']);
      final token = response.data['token'];
      
      // Store token for future requests
      final authService = getx.Get.find<AuthService>();
      await authService.setToken(token);
      
      return Right(user);
    } on DioException catch (e) {
      return Left(AuthFailure(e.response?.data['message'] ?? 'Registration failed'));
    } catch (e) {
      return Left(AuthFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _apiClient.dio.post(ApiConstants.logout);
      return const Right(null);
    } on DioException catch (e) {
      return Left(AuthFailure(e.response?.data['message'] ?? 'Logout failed'));
    } catch (e) {
      return Left(AuthFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> updateFcmToken(String token) async {
    try {
      await _apiClient.dio.post(
        ApiConstants.updateFcmToken,
        data: {'fcm_token': token},
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Failed to update FCM token'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }
}