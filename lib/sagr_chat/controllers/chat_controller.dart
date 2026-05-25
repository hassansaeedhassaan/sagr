import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sagr/helper/base_url.dart';
import '../../core/services/unified-notification-service.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'auth_controller.dart';

class ChatController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final UnifiedNotificationService _notificationService = 
      UnifiedNotificationService.instance;

  final RxList<Conversation> conversations = <Conversation>[].obs;
  final RxMap<int, List<Message>> conversationMessages = <int, List<Message>>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMessages = false.obs;
  final RxBool isSendingMessage = false.obs;

  // ✅ Track current conversation
  final RxnInt currentConversationId = RxnInt(null);
  
  // ✅ Track processing message IDs to prevent duplicates
  final RxSet<int> processingMessageIds = <int>{}.obs;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadConversations();
    _notificationService.onMessageReceived = _handleNewMessage;
    
    print('✅ ChatController initialized');
  }

  // ✅ Set current conversation when entering chat screen
  void setCurrentConversation(int? conversationId) {
    currentConversationId.value = conversationId;
    _notificationService.setActiveConversation(conversationId);
    print('💬 Current conversation set to: $conversationId');
  }

  Future<void> loadConversations() async {
    try {
      isLoading.value = true;
      final convs = await _apiService.getConversations();
      conversations.value = convs;
      print('✅ Loaded ${convs.length} conversations');
    } catch (e) {
      print('❌ Error loading conversations: $e');
      Get.snackbar('Error', 'Failed to load conversations');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMessages(int conversationId, {int page = 1}) async {
    try {
      if (page == 1) isLoadingMessages.value = true;
      
      print('📥 Loading messages for conversation $conversationId, page $page');
      
      final messages = await _apiService.getMessages(conversationId, page: page);
      
      if (page == 1) {
        conversationMessages[conversationId] = messages;
      } else {
        conversationMessages[conversationId]?.addAll(messages);
      }
      
      print('✅ Loaded ${messages.length} messages');
      
      // Mark messages as read
      final currentUserId = Get.find<SagrAuthController>().currentUser.value?.id;
      if (currentUserId != null) {
        for (final message in messages) {
          if (message.senderId != currentUserId) {
            _markMessageAsReadAsync(message.id);
          }
        }
      }
      
    } catch (e) {
      print('❌ Error loading messages: $e');
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
    // ✅ Prevent duplicate sends
    if (isSendingMessage.value) {
      print('⚠️ Already sending a message, ignoring duplicate request');
      return;
    }
    
    print('📤 Sending text message to conversation $conversationId');
    print('📝 Content: $content');
    
    try {
      isSendingMessage.value = true;
      
      final message = await _apiService.sendTextMessage(
        conversationId: conversationId,
        content: content,
        replyToId: replyToId,
      );
      
      print('✅ Message sent successfully: ${message.id}');
      
      // ✅ Add message to conversation (this is the ONLY place we add sent messages)
      _addMessageToConversation(conversationId, message);
      _updateConversationLastMessage(conversationId, message);
      
    } on DioException catch (e) {
      String errorMessage = 'Failed to send message';
      
      if (e.response != null) {
        final responseData = e.response!.data;
        
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? 
                        responseData['error'] ?? 
                        'Server error occurred';
        } else if (responseData is String) {
          errorMessage = responseData;
        }
        
        print('❌ Backend error: ${e.response!.statusCode} - $errorMessage');
      } else {
        errorMessage = e.message ?? 'Network error occurred';
        print('❌ Network error: $errorMessage');
      }
      
      Get.snackbar(
        'Error', 
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      
    } catch (e) {
      print('❌ Unexpected error: $e');
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      // ✅ CRITICAL: Always reset the flag
      isSendingMessage.value = false;
      print('✅ Send complete, flag reset');
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
      
      if (image == null) {
        print('⚠️ No image selected');
        return;
      }

      if (isSendingMessage.value) {
        print('⚠️ Already sending a message');
        return;
      }

      isSendingMessage.value = true;
      print('📤 Sending image message');
      
      final message = await _apiService.sendMediaMessage(
        conversationId: conversationId,
        type: 'image',
        filePath: image.path,
        replyToId: replyToId,
      );

      print('✅ Image sent successfully: ${message.id}');
      
      _addMessageToConversation(conversationId, message);
      _updateConversationLastMessage(conversationId, message);
      
    } on DioException catch (e) {
      String errorMessage = 'Failed to send image';
      
      if (e.response != null) {
        final responseData = e.response!.data;
        
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? 
                        responseData['error'] ?? 
                        'Server error occurred';
        } else if (responseData is String) {
          errorMessage = responseData;
        }
      } else {
        errorMessage = e.message ?? 'Network error occurred';
      }
      
      print('❌ Error sending image: $errorMessage');
      
      Get.snackbar(
        'Error', 
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      
    } catch (e) {
      print('❌ Error sending image: $e');
      Get.snackbar('Error', 'Failed to send image');
    } finally {
      isSendingMessage.value = false;
      print('✅ Image send complete, flag reset');
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
      
      if (video == null) {
        print('⚠️ No video selected');
        return;
      }

      if (isSendingMessage.value) {
        print('⚠️ Already sending a message');
        return;
      }

      isSendingMessage.value = true;
      print('📤 Sending video message');
      
      final message = await _apiService.sendMediaMessage(
        conversationId: conversationId,
        type: 'video',
        filePath: video.path,
        replyToId: replyToId,
      );

      print('✅ Video sent successfully: ${message.id}');
      
      _addMessageToConversation(conversationId, message);
      _updateConversationLastMessage(conversationId, message);
      
    } on DioException catch (e) {
      String errorMessage = 'Failed to send video';
      
      if (e.response != null) {
        final responseData = e.response!.data;
        
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? 
                        responseData['error'] ?? 
                        'Server error occurred';
        } else if (responseData is String) {
          errorMessage = responseData;
        }
      } else {
        errorMessage = e.message ?? 'Network error occurred';
      }
      
      print('❌ Error sending video: $errorMessage');
      
      Get.snackbar(
        'Error', 
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      
    } catch (e) {
      print('❌ Error sending video: $e');
      Get.snackbar('Error', 'Failed to send video');
    } finally {
      isSendingMessage.value = false;
      print('✅ Video send complete, flag reset');
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

      if (result == null || result.files.isEmpty) {
        print('⚠️ No document selected');
        return;
      }

      final file = result.files.first;
      if (file.path == null) {
        print('⚠️ Invalid file path');
        return;
      }

      if (isSendingMessage.value) {
        print('⚠️ Already sending a message');
        return;
      }

      isSendingMessage.value = true;
      print('📤 Sending document message');
      
      final message = await _apiService.sendMediaMessage(
        conversationId: conversationId,
        type: 'document',
        filePath: file.path!,
        replyToId: replyToId,
      );

      print('✅ Document sent successfully: ${message.id}');
      
      _addMessageToConversation(conversationId, message);
      _updateConversationLastMessage(conversationId, message);
      
    } on DioException catch (e) {
      String errorMessage = 'Failed to send document';
      
      if (e.response != null) {
        final responseData = e.response!.data;
        
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? 
                        responseData['error'] ?? 
                        'Server error occurred';
        } else if (responseData is String) {
          errorMessage = responseData;
        }
      } else {
        errorMessage = e.message ?? 'Network error occurred';
      }
      
      print('❌ Error sending document: $errorMessage');
      
      Get.snackbar(
        'Error', 
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      
    } catch (e) {
      print('❌ Error sending document: $e');
      Get.snackbar('Error', 'Failed to send document');
    } finally {
      isSendingMessage.value = false;
      print('✅ Document send complete, flag reset');
    }
  }

  Future<void> sendVoiceMessage({
    required int conversationId,
    required String audioPath,
    required int duration,
    int? replyToId,
  }) async {
    try {
      if (isSendingMessage.value) {
        print('⚠️ Already sending a message');
        return;
      }

      isSendingMessage.value = true;
      print('📤 Sending voice message');
      
      final message = await _apiService.sendMediaMessage(
        conversationId: conversationId,
        type: 'voice_note',
        filePath: audioPath,
        replyToId: replyToId,
        duration: duration,
      );

      print('✅ Voice message sent successfully: ${message.id}');
      
      _addMessageToConversation(conversationId, message);
      _updateConversationLastMessage(conversationId, message);
      
    } on DioException catch (e) {
      String errorMessage = 'Failed to send voice message';
      
      if (e.response != null) {
        final responseData = e.response!.data;
        
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? 
                        responseData['error'] ?? 
                        'Server error occurred';
        } else if (responseData is String) {
          errorMessage = responseData;
        }
      } else {
        errorMessage = e.message ?? 'Network error occurred';
      }
      
      print('❌ Error sending voice message: $errorMessage');
      
      Get.snackbar(
        'Error', 
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      
    } catch (e) {
      print('❌ Error sending voice message: $e');
      Get.snackbar('Error', 'Failed to send voice message');
    } finally {
      isSendingMessage.value = false;
      print('✅ Voice send complete, flag reset');
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
      print('❌ Error creating conversation: $e');
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
      print('❌ Error creating group: $e');
      Get.snackbar('Error', 'Failed to create group');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMessage(int messageId, int conversationId) async {
    try {
      await _apiService.deleteMessage(messageId);
      
      final messages = conversationMessages[conversationId];
      if (messages != null) {
        messages.removeWhere((msg) => msg.id == messageId);
        conversationMessages[conversationId] = List.from(messages);
      }
      
      print('✅ Message deleted: $messageId');
      
    } catch (e) {
      print('❌ Error deleting message: $e');
      Get.snackbar('Error', 'Failed to delete message');
    }
  }

  void _addMessageToConversation(int conversationId, Message message) {
    print('➕ Adding message ${message.id} to conversation $conversationId');
    
    if (conversationMessages[conversationId] == null) {
      conversationMessages[conversationId] = [];
    }
    
    // ✅ Check if message already exists
    final existingIndex = conversationMessages[conversationId]!
        .indexWhere((m) => m.id == message.id);
    
    if (existingIndex != -1) {
      print('⚠️ Message ${message.id} already exists, updating');
      conversationMessages[conversationId]![existingIndex] = message;
    } else {
      print('✅ Adding new message ${message.id}');
      conversationMessages[conversationId]!.insert(0, message);
    }
    
    conversationMessages.refresh();
  }

  void _updateConversationLastMessage(int conversationId, Message message) {
    print('🔄 Updating last message for conversation $conversationId');
    
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
      
      print('✅ Conversation updated and moved to top');
    }
  }

  // ✅ FIXED: Handle incoming Firebase messages
  void _handleNewMessage(Map<String, dynamic> data) {
    try {
      print('🔔 ========================================');
      print('🔔 Received notification data: $data');
      
      final messageType = data['type']?.toString();
      print('🔔 Notification type: $messageType');

      if (messageType != 'chat') {
        print('ℹ️ Non-chat notification type, ignoring');
        return;
      }

      final conversationId = int.tryParse(
        data['conversation_id']?.toString() ?? ''
      );
      
      print('💬 Chat notification for conversation: $conversationId');
      
      if (conversationId == null) {
        print('❌ Invalid conversation ID');
        return;
      }

      // Create message from Firebase data
      final message = _createMessageFromFirebaseData(data);

      if (message == null) {
        print('❌ Failed to create message from data');
        return;
      }

      print('✅ Message created successfully: ${message.id}');
      print('👤 Sender ID: ${message.senderId}');
      print('👤 Current User ID: ${Get.find<SagrAuthController>().currentUser.value?.id}');

      // ✅ CRITICAL: Only add messages from OTHER users
      final currentUserId = Get.find<SagrAuthController>().currentUser.value?.id;
      
      if (currentUserId != null && message.senderId == currentUserId) {
        print('⚠️ This is my own message, ignoring (already added when sent)');
        return;
      }

      // ✅ Check if message already exists to prevent duplicates
      final existingMessages = conversationMessages[conversationId] ?? [];
      final messageExists = existingMessages.any((msg) => msg.id == message.id);

      if (messageExists) {
        print('⚠️ Message ${message.id} already exists, skipping');
        return;
      }

      // ✅ Check if we're already processing this message
      if (processingMessageIds.contains(message.id)) {
        print('⚠️ Already processing message ${message.id}, skipping');
        return;
      }

      // Mark as processing
      processingMessageIds.add(message.id);

      print('➕ Adding new message ${message.id} to conversation $conversationId');
      
      _addMessageToConversation(conversationId, message);
      _updateConversationLastMessage(conversationId, message);
      
      print('✅ Message added and conversation updated');
      
      // Mark as read if it's the active conversation
      if (conversationId == currentConversationId.value) {
        print('📖 Marking message as read (active conversation)');
        _markMessageAsReadAsync(message.id);
      } else {
        print('🔕 Not marking as read (inactive conversation)');
      }

      // Remove from processing after a short delay
      Future.delayed(Duration(seconds: 2), () {
        processingMessageIds.remove(message.id);
      });

      print('🔔 ========================================');
      
    } catch (e, stackTrace) {
      print('❌ Error handling new message: $e');
      print('❌ Stack trace: $stackTrace');
      print('❌ Data: $data');
    }
  }

  Message? _createMessageFromFirebaseData(Map<String, dynamic> data) {
    try {
      print('📨 Creating message from Firebase data');
      print('📨 Raw data: $data');
      
      String messageType = data['msg_type']?.toString() ?? 
                          data['type']?.toString() ?? 
                          'text';
      
      if (messageType == 'chat') {
        messageType = data['msg_type']?.toString() ?? 'text';
      }
      
      messageType = messageType.toLowerCase().trim();
      
      if (messageType == 'photo') messageType = 'image';
      if (messageType == 'voice') messageType = 'voice_note';
      
      print('📝 Normalized message type: $messageType');
      
      String? messageContent = data['content']?.toString();
      
      if (messageType == 'text' && (messageContent == null || messageContent.isEmpty)) {
        messageContent = data['message']?.toString() ?? data['text']?.toString();
      }
      
      print('💬 Message content: $messageContent');
      
      String? mediaUrl;
      final rawMediaUrl = data['media_url']?.toString();
      
      if (rawMediaUrl != null && rawMediaUrl.isNotEmpty && rawMediaUrl != 'null') {
        if (rawMediaUrl.startsWith('http://') || rawMediaUrl.startsWith('https://')) {
          mediaUrl = rawMediaUrl;
        } else {
          String cleanPath = rawMediaUrl
              .replaceAll(RegExp(r'^/+'), '')
              .replaceAll('uploads/images/', '');
          
          mediaUrl = '${HOSTURL}uploads/images/$cleanPath';
        }
      }
      
      print('🖼️ Media URL: $mediaUrl');
      
      int? replyToId;
      final rawReplyToId = data['reply_to_id']?.toString();
      if (rawReplyToId != null && rawReplyToId.isNotEmpty && rawReplyToId != 'null') {
        replyToId = int.tryParse(rawReplyToId);
      }
      
      DateTime createdAt = DateTime.now();
      final rawCreatedAt = data['created_at']?.toString();
      if (rawCreatedAt != null && rawCreatedAt.isNotEmpty) {
        createdAt = DateTime.tryParse(rawCreatedAt) ?? DateTime.now();
      }
      
      print('⏰ Created at: $createdAt');
      
      final messageId = int.tryParse(data['message_id']?.toString() ?? '');
      if (messageId == null || messageId == 0) {
        print('❌ Invalid message ID');
        return null;
      }
      
      final message = Message(
        id: messageId,
        conversationId: int.tryParse(data['conversation_id']?.toString() ?? '') ?? 0,
        senderId: int.tryParse(data['sender_id']?.toString() ?? '') ?? 0,
        content: messageContent,
        type: messageType,
        media_url: mediaUrl,
        replyToId: replyToId,
        createdAt: createdAt,
        isEdited: false,
        statuses: [],
      );
      
      print('✅ Successfully created message: ${message.id} - Type: ${message.type}');
      return message;
      
    } catch (e, stackTrace) {
      print('❌ Error creating message from Firebase data: $e');
      print('❌ Stack trace: $stackTrace');
      print('❌ Failed data: $data');
      return null;
    }
  }

  void _markMessageAsReadAsync(int messageId) {
    Future.microtask(() async {
      try {
        await _apiService.markMessageAsRead(messageId);
        print('✅ Message $messageId marked as read');
      } catch (e) {
        print('❌ Error marking message as read: $e');
      }
    });
  }

  List<Message> getMessagesForConversation(int conversationId) {
    return conversationMessages[conversationId] ?? [];
  }

  @override
  void onClose() {
    setCurrentConversation(null);
    print('🔴 ChatController disposed');
    super.onClose();
  }
}