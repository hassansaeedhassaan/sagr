import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../network/api_client.dart';
import '../constants/api_constants.dart';
import '../error/failures.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Chat>>> getChats();
  Future<Either<Failure, List<Message>>> getMessages(String chatId);
  Future<Either<Failure, Message>> sendMessage(Message message);
  Future<Either<Failure, Chat>> createGroup(String name, List<String> memberIds);
  Future<Either<Failure, String>> uploadMedia(String filePath);
  Future<Either<Failure, Chat>> getOrCreateIndividualChat(String userId); // إضافة هذا
}


class ChatRepositoryImpl implements ChatRepository {
  final ApiClient _apiClient;

  ChatRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, List<Chat>>> getChats() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.chats);

      final List<dynamic> data = response.data['data'];

      final chats = data.map((json) => Chat.fromJson(json)).toList();
      
      return Right(chats);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString() ?? 'Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(String chatId) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConstants}/$chatId',
      );
      final List<dynamic> data = response.data['data'];
      final messages = data.map((json) => Message.fromJson(json)).toList();
      return Right(messages);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage(Message message) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.sendMessage,
        data: message.toJson(),
      );
      final sentMessage = Message.fromJson(response.data['data']);
      return Right(sentMessage);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, Chat>> createGroup(String name, List<String> memberIds) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.createGroup,
        data: {
          'name': name,
          'member_ids': memberIds,
        },
      );
      final group = Chat.fromJson(response.data['data']);
      return Right(group);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadMedia(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      
      final response = await _apiClient.dio.post(
        ApiConstants.uploadMedia,
        data: formData,
      );
      
      return Right(response.data['url']);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error'));
    }
  }
  @override
  Future<Either<Failure, Chat>> getOrCreateIndividualChat(String userId) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.getOrCreateIndividualChat,
        data: {'user_id': userId},
      );
      final chat = Chat.fromJson(response.data['data']);
      return Right(chat);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error'));
    }
  }
}