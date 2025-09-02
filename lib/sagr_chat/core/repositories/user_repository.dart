import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../models/user.dart';
import '../network/api_client.dart';
import '../constants/api_constants.dart';
import '../error/failures.dart';

abstract class UserRepository {
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, User>> updateProfile(String name, String? phone);
  Future<Either<Failure, String>> uploadAvatar(String imagePath);
  Future<Either<Failure, User>> getUserById(String userId);
}

class UserRepositoryImpl implements UserRepository {

  final ApiClient _apiClient;
  
  UserRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.users);
      final List<dynamic> data = response.data['data'];
      final users = data.map((json) => User.fromJson(json)).toList();
      return Right(users);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile(String name, String? phone) async {
    try {
      final response = await _apiClient.dio.put(
        ApiConstants.updateProfile,
        data: {
          'name': name,
          'phone': phone,
        },
      );
      final user = User.fromJson(response.data['data']);
      return Right(user);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAvatar(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(imagePath),
      });
      
      final response = await _apiClient.dio.post(
        ApiConstants.uploadAvatar,
        data: formData,
      );
      
      return Right(response.data['avatar_url']);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, User>> getUserById(String userId) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.users}/$userId');
      final user = User.fromJson(response.data['data']);
      return Right(user);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error'));
    }
  }
}
