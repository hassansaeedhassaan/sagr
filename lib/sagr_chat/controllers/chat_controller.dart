import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/firebase_messaging_service.dart';
import 'auth_controller.dart';

class ChatController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final FirebaseMessagingService _messagingService = Get.find<FirebaseMessagingService>();

  final RxList<Conversation> conversations = <Conversation>[].obs;
  final RxMap<int, List<Message>> conversationMessages = <int, List<Message>>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMessages = false.obs;
  final RxBool isSendingMessage = false.obs;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadConversations();
    _messagingService.onMessageReceived = _handleNewMessage;
  }

  Future<void> loadConversations() async {
    try {
      isLoading.value = true;
      final convs = await _apiService.getConversations();
      conversations.value = convs;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load conversations');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMessages(int conversationId, {int page = 1}) async {
    try {
      if (page == 1) isLoadingMessages.value = true;
      
      final messages = await _apiService.getMessages(conversationId, page: page);
      
      if (page == 1) {
        conversationMessages[conversationId] = messages;
      } else {
        conversationMessages[conversationId]?.addAll(messages);
      }
      
      // Mark messages as read
      for (final message in messages) {
        if (message.senderId != Get.find<SagrAuthController>().currentUser.value!.id) {
          await _apiService.markMessageAsRead(message.id);
        }
      }
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages');
    } finally {
      if (page == 1) isLoadingMessages.value = false;
    }
  }

  Future<void> sendTextMessage({
    required int conversationId,
    required String content,
    int? replyToId,
  }) async {
    try {
      isSendingMessage.value = true;
      
      final message = await _apiService.sendTextMessage(
        conversationId: conversationId,
        content: content,
        replyToId: replyToId,
      );

      _addMessageToConversation(conversationId, message);

      _updateConversationLastMessage(conversationId, message);
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message');
    } finally {
      isSendingMessage.value = false;
    }
  }

  Future<void> sendImageMessage({
    required int conversationId,
    int? replyToId,
  }) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image == null) return;

      isSendingMessage.value = true;
      
      final message = await _apiService.sendMediaMessage(
        conversationId: conversationId,
        type: 'image',
        filePath: image.path,
        replyToId: replyToId,
      );

      _addMessageToConversation(conversationId, message);
      _updateConversationLastMessage(conversationId, message);
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to send image');
    } finally {
      isSendingMessage.value = false;
    }
  }

  Future<void> sendVideoMessage({
    required int conversationId,
    int? replyToId,
  }) async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
      );
      
      if (video == null) return;

      isSendingMessage.value = true;
      
      final message = await _apiService.sendMediaMessage(
        conversationId: conversationId,
        type: 'video',
        filePath: video.path,
        replyToId: replyToId,
      );

      _addMessageToConversation(conversationId, message);
      _updateConversationLastMessage(conversationId, message);
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to send video');
    } finally {
      isSendingMessage.value = false;
    }
  }

  Future<void> sendDocumentMessage({
    required int conversationId,
    int? replyToId,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      if (file.path == null) return;

      isSendingMessage.value = true;
      
      final message = await _apiService.sendMediaMessage(
        conversationId: conversationId,
        type: 'document',
        filePath: file.path!,
        replyToId: replyToId,
      );

      _addMessageToConversation(conversationId, message);
      _updateConversationLastMessage(conversationId, message);
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to send document');
    } finally {
      isSendingMessage.value = false;
    }
  }

  Future<void> sendVoiceMessage({
    required int conversationId,
    required String audioPath,
    required int duration,
    int? replyToId,
  }) async {
    try {
      isSendingMessage.value = true;
      
      final message = await _apiService.sendMediaMessage(
        conversationId: conversationId,
        type: 'voice_note',
        filePath: audioPath,
        replyToId: replyToId,
        duration: duration,
      );

      _addMessageToConversation(conversationId, message);
      _updateConversationLastMessage(conversationId, message);
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to send voice message');
    } finally {
      isSendingMessage.value = false;
    }
  }

  Future<void> createPrivateConversation(int userId) async {
    try {
      isLoading.value = true;
      
      final conversation = await _apiService.createConversation(
        type: 'private',
        participants: [userId],
        name: "UY"
      );

      conversations.insert(0, conversation);
      Get.toNamed('/chat', arguments: conversation);
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to create conversation');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createGroupConversation({
    required String name,
    required List<int> participants,
  }) async {
    try {
      isLoading.value = true;
      
      final conversation = await _apiService.createConversation(
        type: 'group',
        participants: participants,
        name: name
      );
    
      conversations.insert(0, conversation);

      Get.toNamed('/chat', arguments: conversation);
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to create group');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMessage(int messageId, int conversationId) async {
    try {
      await _apiService.deleteMessage(messageId);
      
      // Remove message from local list
      final messages = conversationMessages[conversationId];
      if (messages != null) {
        messages.removeWhere((msg) => msg.id == messageId);
        conversationMessages[conversationId] = List.from(messages);
      }
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete message');
    }
  }

  void _addMessageToConversation(int conversationId, Message message) {
    if (conversationMessages[conversationId] == null) {
      conversationMessages[conversationId] = [];
    }
    conversationMessages[conversationId]!.insert(0, message);
    conversationMessages.refresh();
  }

  void _updateConversationLastMessage(int conversationId, Message message) {
    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final updatedConversation = Conversation(
        id: conversations[index].id,
        name: conversations[index].name,
        avatar: conversations[index].avatar,
        type: conversations[index].type,
        createdBy: conversations[index].createdBy,
        participants: conversations[index].participants,
        lastMessage: message,
        participantsCount: conversations[index].participantsCount,
        updatedAt: message.createdAt,
        settings: conversations[index].settings,
      );
      
      conversations[index] = updatedConversation;
      
      // Move conversation to top
      conversations.removeAt(index);
      conversations.insert(0, updatedConversation);
    }
  }

  // Updated method to handle new messages efficiently
  void _handleNewMessage(Map<String, dynamic> data) {
    try {
      if (data['type'] == 'message') {
        final conversationId = int.tryParse(data['conversation_id'].toString());
        if (conversationId == null) return;

        // Create Message object from Firebase data
        final message = _createMessageFromFirebaseData(data);
        if (message == null) return;

        // Check if message already exists to avoid duplicates
        final existingMessages = conversationMessages[conversationId] ?? [];
        final messageExists = existingMessages.any((msg) => msg.id == message.id);
        
        if (!messageExists) {
          // Add message to conversation
          _addMessageToConversation(conversationId, message);
          
          // Update conversation's last message
          _updateConversationLastMessage(conversationId, message);
          
          // Mark message as read if it's not from current user
          final currentUserId = Get.find<SagrAuthController>().currentUser.value?.id;
          if (currentUserId != null && message.senderId != currentUserId) {
            _markMessageAsReadAsync(message.id);
          }
        }
      }
    } catch (e) {
      print('Error handling new message: $e');
      // Fallback to reload if parsing fails
      final conversationId = int.tryParse(data['conversation_id'].toString());
      if (conversationId != null) {
        loadMessages(conversationId);
      }
    }
  }

  // Helper method to create Message object from Firebase data
  Message? _createMessageFromFirebaseData(Map<String, dynamic> data) {

    
    try {
      // Adjust these field names based on your Firebase message structure
      return Message(
        id: int.tryParse(data['message_id'].toString()) ?? 0,
        conversationId: int.tryParse(data['conversation_id'].toString()) ?? 0,
        senderId: int.tryParse(data['sender_id'].toString()) ?? 0,
        content: data['content']?.toString() ?? '',
        type: data['message_type']?.toString() ?? 'text',
        // mediaUrl: data['media_url']?.toString(),
        replyToId: int.tryParse(data['reply_to_id'].toString()),
        createdAt: DateTime.tryParse(data['created_at'].toString()) ?? DateTime.now(), isEdited: false, statuses: [],
        // isRead: data['is_read'] == true,
        // duration: int.tryParse(data['duration'].toString()),
        // Add other Message fields as needed based on your Message model
      );
    } catch (e) {
      print('Error creating message from Firebase data: $e');
      return null;
    }
  }

  // Async method to mark message as read without blocking UI
  void _markMessageAsReadAsync(int messageId) {
    Future.microtask(() async {
      try {
        await _apiService.markMessageAsRead(messageId);
      } catch (e) {
        print('Error marking message as read: $e');
      }
    });
  }

  List<Message> getMessagesForConversation(int conversationId) {
    return conversationMessages[conversationId] ?? [];
  }
}



/// Original And Old V01

// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import '../models/conversation.dart';
// import '../models/message.dart';
// import '../models/user.dart';
// import '../services/api_service.dart';
// import '../services/firebase_messaging_service.dart';
// import 'auth_controller.dart';

// class ChatController extends GetxController {
//   final ApiService _apiService = Get.find<ApiService>();
//   final FirebaseMessagingService _messagingService = Get.find<FirebaseMessagingService>();

//   final RxList<Conversation> conversations = <Conversation>[].obs;
//   final RxMap<int, List<Message>> conversationMessages = <int, List<Message>>{}.obs;
//   final RxBool isLoading = false.obs;
//   final RxBool isLoadingMessages = false.obs;
//   final RxBool isSendingMessage = false.obs;

//   final ImagePicker _imagePicker = ImagePicker();

//   @override
//   void onInit() {
//     super.onInit();
//     loadConversations();
//     _messagingService.onMessageReceived = _handleNewMessage;
//   }

//   Future<void> loadConversations() async {

//     // print("asldkas;ld");
//     try {
//       isLoading.value = true;
//       final convs = await _apiService.getConversations();
//       conversations.value = convs;
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to load conversations');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> loadMessages(int conversationId, {int page = 1}) async {
//     try {
//       if (page == 1) isLoadingMessages.value = true;
      
//       final messages = await _apiService.getMessages(conversationId, page: page);
      
//       if (page == 1) {
//         conversationMessages[conversationId] = messages;
//       } else {
//         conversationMessages[conversationId]?.addAll(messages);
//       }
      
//       // Mark messages as read
//       for (final message in messages) {
//         if (message.senderId != Get.find<AuthController>().currentUser.value!.id) {
//           await _apiService.markMessageAsRead(message.id);
//         }
//       }
      
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to load messages');
//     } finally {
//       if (page == 1) isLoadingMessages.value = false;
//     }
//   }

//   Future<void> sendTextMessage({
//     required int conversationId,
//     required String content,
//     int? replyToId,
//   }) async {
//     try {
//       isSendingMessage.value = true;
      
//       final message = await _apiService.sendTextMessage(
//         conversationId: conversationId,
//         content: content,
//         replyToId: replyToId,
//       );

//       _addMessageToConversation(conversationId, message);
//       _updateConversationLastMessage(conversationId, message);
      
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to send message');
//     } finally {
//       isSendingMessage.value = false;
//     }
//   }

//   Future<void> sendImageMessage({
//     required int conversationId,
//     int? replyToId,
//   }) async {
//     try {
//       final XFile? image = await _imagePicker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//       );
      
//       if (image == null) return;

//       isSendingMessage.value = true;
      
//       final message = await _apiService.sendMediaMessage(
//         conversationId: conversationId,
//         type: 'image',
//         filePath: image.path,
//         replyToId: replyToId,
//       );

//       _addMessageToConversation(conversationId, message);
//       _updateConversationLastMessage(conversationId, message);
      
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to send image');
//     } finally {
//       isSendingMessage.value = false;
//     }
//   }

//   Future<void> sendVideoMessage({
//     required int conversationId,
//     int? replyToId,
//   }) async {
//     try {
//       final XFile? video = await _imagePicker.pickVideo(
//         source: ImageSource.gallery,
//       );
      
//       if (video == null) return;

//       isSendingMessage.value = true;
      
//       final message = await _apiService.sendMediaMessage(
//         conversationId: conversationId,
//         type: 'video',
//         filePath: video.path,
//         replyToId: replyToId,
//       );

//       _addMessageToConversation(conversationId, message);
//       _updateConversationLastMessage(conversationId, message);
      
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to send video');
//     } finally {
//       isSendingMessage.value = false;
//     }
//   }

//   Future<void> sendDocumentMessage({
//     required int conversationId,
//     int? replyToId,
//   }) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.any,
//         allowMultiple: false,
//       );

//       if (result == null || result.files.isEmpty) return;

//       final file = result.files.first;
//       if (file.path == null) return;

//       isSendingMessage.value = true;
      
//       final message = await _apiService.sendMediaMessage(
//         conversationId: conversationId,
//         type: 'document',
//         filePath: file.path!,
//         replyToId: replyToId,
//       );

//       _addMessageToConversation(conversationId, message);
//       _updateConversationLastMessage(conversationId, message);
      
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to send document');
//     } finally {
//       isSendingMessage.value = false;
//     }
//   }

//   Future<void> sendVoiceMessage({
//     required int conversationId,
//     required String audioPath,
//     required int duration,
//     int? replyToId,
//   }) async {
//     try {
//       isSendingMessage.value = true;
      
//       final message = await _apiService.sendMediaMessage(
//         conversationId: conversationId,
//         type: 'voice_note',
//         filePath: audioPath,
//         replyToId: replyToId,
//         duration: duration,
//       );

//       _addMessageToConversation(conversationId, message);
//       _updateConversationLastMessage(conversationId, message);
      
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to send voice message');
//     } finally {
//       isSendingMessage.value = false;
//     }
//   }

//   Future<void> createPrivateConversation(int userId) async {
//     try {
//       isLoading.value = true;
      
//       final conversation = await _apiService.createConversation(
//         type: 'private',
//         participants: [userId],
//         name: "UY"
//       );

//       conversations.insert(0, conversation);
//       Get.toNamed('/chat', arguments: conversation);
      
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to create conversation');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> createGroupConversation({
//     required String name,
//     required List<int> participants,
//   }) async {
//     try {
//       isLoading.value = true;
      
//       final conversation = await _apiService.createConversation(
//         type: 'group',
//         participants: participants,
//         name: name
//       );
    
//       conversations.insert(0, conversation);

//       Get.toNamed('/chat', arguments: conversation);
      
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to create group');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> deleteMessage(int messageId, int conversationId) async {
//     try {
//       await _apiService.deleteMessage(messageId);
      
//       // Remove message from local list
//       final messages = conversationMessages[conversationId];
//       if (messages != null) {
//         messages.removeWhere((msg) => msg.id == messageId);
//         conversationMessages[conversationId] = List.from(messages);
//       }
      
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to delete message');
//     }
//   }

//   void _addMessageToConversation(int conversationId, Message message) {
//     if (conversationMessages[conversationId] == null) {
//       conversationMessages[conversationId] = [];
//     }
//     conversationMessages[conversationId]!.insert(0, message);
//     conversationMessages.refresh();
//   }

//   void _updateConversationLastMessage(int conversationId, Message message) {
//     final index = conversations.indexWhere((c) => c.id == conversationId);
//     if (index != -1) {
//       final updatedConversation = Conversation(
//         id: conversations[index].id,
//         name: conversations[index].name,
//         avatar: conversations[index].avatar,
//         type: conversations[index].type,
//         createdBy: conversations[index].createdBy,
//         participants: conversations[index].participants,
//         lastMessage: message,
//         participantsCount: conversations[index].participantsCount,
//         updatedAt: message.createdAt,
//         settings: conversations[index].settings,
//       );
      
//       conversations[index] = updatedConversation;
      
//       // Move conversation to top
//       conversations.removeAt(index);
//       conversations.insert(0, updatedConversation);
//     }
//   }

//   void _handleNewMessage(Map<String, dynamic> data) {
//     // Handle incoming Firebase messages
//     if (data['type'] == 'message') {
//       final conversationId = int.tryParse(data['conversation_id'].toString());
//       if (conversationId != null) {
//         // Reload messages for this conversation
//         loadMessages(conversationId);
//       }
//     }
//   }

//   List<Message> getMessagesForConversation(int conversationId) {
//     return conversationMessages[conversationId] ?? [];
//   }
// }
