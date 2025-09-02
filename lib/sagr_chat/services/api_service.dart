import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user.dart';
import '../models/conversation.dart';
import '../models/message.dart';

class ApiService extends GetxService {
  late dio.Dio _dio;
  final _storage = GetStorage();

  static const String baseUrl = 'https://sagr.libraryrajab.com/api/v1';

  @override
  void onInit() {
    super.onInit();
    _initDio();
  }

  _initDio() {
     _dio = dio.Dio(dio.BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add token interceptor
    _dio.interceptors.add(dio.InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _storage.read('access_token');

        print("l;askd;las 🔥");
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {

          print("as klj");
          // Handle unauthorized - redirect to login
          // _storage.remove('access_token');
          // _storage.remove('userData');
          // Get.offAllNamed('/login');
        }
        handler.next(error);
      },
    ));
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    final response = await _dio.post('/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'phone': phone,
    });

    return response.data;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    final response = await _dio.post('/login', data: {
      'email': email,
      'password': password,
      'fcm_token': fcmToken,
    });

    return response.data;
  }

  Future<void> logout() async {
    await _dio.post('/logout');
  }

  Future<User> updateProfile({
    String? name,
    String? avatarPath,
  }) async {
     dio.FormData formData = dio.FormData();

    if (name != null) formData.fields.add(MapEntry('name', name));
    if (avatarPath != null) {
      formData.files.add(MapEntry(
        'avatar',
        await dio.MultipartFile.fromFile(avatarPath),
      ));
    }

    final response = await _dio.put('/profile', data: formData);
    return User.fromJson(response.data['user']);
  }

  // User methods
  Future<List<User>> searchUsers(String query) async {
    final response = await _dio.get('/users/search', queryParameters: {
      'query': query,
    });

    return (response.data['users'] as List)
        .map((user) => User.fromJson(user))
        .toList();
  }

  Future<List<User>> getContacts() async {
    final response = await _dio.get('/users/contacts');
    return (response.data['contacts'] as List)
        .map((user) => User.fromJson(user))
        .toList();
  }

  Future<void> updateStatus(String status) async {
    await _dio.post('/users/status', data: {'status': status});
  }

  // Conversation methods
  Future<List<Conversation>> getConversations() async {
    final response = await _dio.get('/conversations');
    return (response.data['conversations'] as List)
        .map((conv) => Conversation.fromJson(conv))
        .toList();
  }

  Future<Conversation> createConversation({
    required String type,
    required List<int> participants,
    String? name,
  }) async {

    final response = await _dio.post('/conversations', data: {
      'type': type,
      'participants': participants,
      'name': name,
    });

    return Conversation.fromJson(response.data['conversation']);
  }

  Future<Conversation> getConversation(int conversationId) async {
    final response = await _dio.get('/conversations/$conversationId');
    return Conversation.fromJson(response.data['conversation']);
  }

  // Message methods
  Future<List<Message>> getMessages(int conversationId, {int page = 1}) async {
    final response = await _dio.get(
      '/conversations/$conversationId/messages',
      queryParameters: {'page': page},
    );

    return (response.data['messages']['data'] as List)
        .map((msg) => Message.fromJson(msg))
        .toList();
  }

  Future<Message> sendTextMessage({
    required int conversationId,
    required String content,
    int? replyToId,
  }) async {
    final response = await _dio.post(
      '/conversations/$conversationId/messages',
      data: {
        'type': 'text',
        'content': content,
        'reply_to_id': replyToId,
      },
    );

    return Message.fromJson(response.data['message']);
  }

  Future<Message> sendMediaMessage({
    required int conversationId,
    required String type,
    required String filePath,
    int? replyToId,
    int? duration,
  }) async {
      dio.FormData formData = dio.FormData.fromMap({
      'type': type,
      'media': await dio.MultipartFile.fromFile(filePath),
      'reply_to_id': replyToId,
      'duration': duration,
    });

    final response = await _dio.post(
      '/conversations/$conversationId/messages',
      data: formData,
    );

    return Message.fromJson(response.data['message']);
  }

  Future<void> markMessageAsRead(int messageId) async {
    await _dio.put('/messages/$messageId/read');
  }

  Future<void> deleteMessage(int messageId) async {
    await _dio.delete('/messages/$messageId');
  }

  Future<Message?> getMessage(int messageId) async {
  try {
    final response = await _dio.get('/messages/$messageId');
    if (response.statusCode == 200) {
      return Message.fromJson(response.data);
    }
    return null;
  } catch (e) {
    print('Error fetching message: $e');
    return null;
  }
}
}


