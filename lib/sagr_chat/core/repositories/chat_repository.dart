import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../network/api_client.dart';
import '../constants/api_constants.dart';
import '../error/failures.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Chat>>> getChats();
  Future<Either<Failure, List<Message>>> getMessages(String chatId, {int page = 1});
  Future<Either<Failure, Message>> sendMessage(Message message);
  Future<Either<Failure, Chat>> createGroup(String name, List<String> memberIds, {String? description});
  Future<Either<Failure, Chat>> getOrCreateIndividualChat(String userId);
  Future<Either<Failure, String>> uploadMedia(String filePath);
  Future<Either<Failure, Chat>> getChatDetails(String chatId);
  Future<Either<Failure, void>> markAllAsRead(String chatId);
  Future<Either<Failure, void>> addGroupMember(String chatId, String userId);
  Future<Either<Failure, void>> removeGroupMember(String chatId, String userId);
  Future<Either<Failure, void>> leaveGroup(String chatId);
  Future<Either<Failure, void>> updateGroup(String chatId, {String? name, String? description, String? avatar});
  Future<Either<Failure, void>> transferGroupOwnership(String chatId, String newAdminId);
}

class ChatRepositoryImpl implements ChatRepository {
  final ApiClient _apiClient;

  ChatRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, List<Chat>>> getChats() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.chats);
      
      if (response.data['status'] != 'success') {
        return Left(ServerFailure(response.data['message'] ?? 'Failed to get chats'));
      }
      
      final List<dynamic> data = response.data['data'] ?? [];
      final chats = data.map((json) {
        try {
          return Chat.fromJson(json as Map<String, dynamic>);
        } catch (e) {
          print('Error parsing chat: $e');
          return null;
        }
      }).where((chat) => chat != null).cast<Chat>().toList();
      
      return Right(chats);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
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
      
      if (response.data['status'] != 'success') {
        return Left(ServerFailure(response.data['message'] ?? 'Failed to upload media'));
      }
      
      return Right(response.data['url']);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Chat>> getChatDetails(String chatId) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.chats}/$chatId');
      
      if (response.data['status'] != 'success') {
        return Left(ServerFailure(response.data['message'] ?? 'Failed to get chat details'));
      }
      
      final chat = Chat.fromJson(response.data['data']);
      return Right(chat);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead(String chatId) async {
    try {
      final response = await _apiClient.dio.post('${ApiConstants.chats}/$chatId/mark-read');
      
      if (response.data['status'] != 'success') {
        return Left(ServerFailure(response.data['message'] ?? 'Failed to mark messages as read'));
      }
      
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addGroupMember(String chatId, String userId) async {
    try {
      final response = await _apiClient.dio.post(
        '${ApiConstants.groups}/$chatId/add-member',
        data: {'user_id': userId},
      );
      
      if (response.data['status'] != 'success') {
        return Left(ServerFailure(response.data['message'] ?? 'Failed to add member'));
      }
      
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeGroupMember(String chatId, String userId) async {
    try {
      final response = await _apiClient.dio.delete(
        '${ApiConstants.groups}/$chatId/remove-member',
        data: {'user_id': userId},
      );
      
      if (response.data['status'] != 'success') {
        return Left(ServerFailure(response.data['message'] ?? 'Failed to remove member'));
      }
      
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> leaveGroup(String chatId) async {
    try {
      final response = await _apiClient.dio.post('${ApiConstants.groups}/$chatId/leave');
      
      if (response.data['status'] != 'success') {
        return Left(ServerFailure(response.data['message'] ?? 'Failed to leave group'));
      }
      
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateGroup(String chatId, {String? name, String? description, String? avatar}) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (avatar != null) data['avatar'] = avatar;

      final response = await _apiClient.dio.put(
        '${ApiConstants.groups}/$chatId',
        data: data,
      );
      
      if (response.data['status'] != 'success') {
        return Left(ServerFailure(response.data['message'] ?? 'Failed to update group'));
      }
      
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> transferGroupOwnership(String chatId, String newAdminId) async {
    try {
      final response = await _apiClient.dio.post(
        '${ApiConstants.groups}/$chatId/transfer-ownership',
        data: {'new_admin_id': newAdminId},
      );
      
      if (response.data['status'] != 'success') {
        return Left(ServerFailure(response.data['message'] ?? 'Failed to transfer ownership'));
      }
      
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Chat>> createGroup(String name, List<String> memberIds, {String? description}) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.createGroup,
        data: {
          'name': name,
          'member_ids': memberIds,
          'description': description,
        },
      );
      
      if (response.data['status'] != 'success') {
        return Left(ServerFailure(response.data['message'] ?? 'Failed to create group'));
      }
      
      final group = Chat.fromJson(response.data['data']);
      return Right(group);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(String chatId, {int page = 1}) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConstants.chats}/$chatId/messages',
        queryParameters: {'page': page, 'per_page': 50},
      );
      
      if (response.data['status'] != 'success') {
        return Left(ServerFailure(response.data['message'] ?? 'Failed to get messages'));
      }
      
      final List<dynamic> data = response.data['data'] ?? [];
      final messages = data.map((json) {
        try {
          return Message.fromJson(json as Map<String, dynamic>);
        } catch (e) {
          print('Error parsing message: $e');
          return null;
        }
      }).where((message) => message != null).cast<Message>().toList();
      
      return Right(messages);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage(Message message) async {
    try {
      final requestData = {
        'chat_id': message.chatId,
        'receiver_id': message.receiverId,
        'content': message.content,
        'type': message.type.name,
        'media_url': message.mediaUrl,
        'audio_duration': message.audioDuration,
        'reply_to_id': message.replyToId,
      };

      final response = await _apiClient.dio.post(
        ApiConstants.sendMessage,
        data: requestData,
      );
      
      if (response.data['status'] != 'success') {
        return Left(ServerFailure(response.data['message'] ?? 'Failed to send message'));
      }
      
      final sentMessage = Message.fromJson(response.data['data']);
      return Right(sentMessage);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
@override
  Future<Either<Failure, Chat>> getOrCreateIndividualChat(String userId) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.getOrCreateIndividualChat,
        data: {'user_id': userId},
      );
      
      if (response.data['status'] != 'success') {
        return Left(ServerFailure(response.data['message'] ?? 'Failed to create chat'));
      }
    
      final chat = Chat.fromJson(response.data['data']);
      return Right(chat);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message']));
    }
    
  }
}