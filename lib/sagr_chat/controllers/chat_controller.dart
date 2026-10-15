import 'package:sagr/core/utils/app_log.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sagr/helper/base_url.dart';
import '../../core/services/unified-notification-service.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../models/message_status.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/reverb_service.dart';
import 'auth_controller.dart';
import 'package:sagr/widgets/messages.dart' show AppNotice;

class ChatController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final ReverbService _reverb = Get.find<ReverbService>();
  final UnifiedNotificationService _notificationService =
      UnifiedNotificationService.instance;

  final RxList<Conversation> conversations = <Conversation>[].obs;
  final RxMap<int, List<Message>> conversationMessages = <int, List<Message>>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMessages = false.obs;
  final RxBool isSendingMessage = false.obs;

  // ✅ Track current conversation
  final RxnInt currentConversationId = RxnInt(null);

  // userId -> userName currently typing in the active conversation.
  final RxMap<int, String> typingUsers = <int, String>{}.obs;

  // ✅ Track processing message IDs to prevent duplicates
  final RxSet<int> processingMessageIds = <int>{}.obs;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadConversations();

    // FCM delivers chat pushes when the socket is down / app backgrounded.
    _notificationService.onMessageReceived = _handleNewMessage;

    // Reverb delivers realtime events while the app is open and connected.
    _reverb.onMessageSent = _onRealtimeMessage;
    _reverb.onMessageRead = _onRealtimeRead;
    _reverb.onUserTyping = _onRealtimeTyping;

    appLog('✅ ChatController initialized');
  }

  // ✅ Set current conversation when entering chat screen
  void setCurrentConversation(int? conversationId) {
    final previous = currentConversationId.value;
    if (previous != null && previous != conversationId) {
      _reverb.unsubscribeConversation(previous);
    }

    currentConversationId.value = conversationId;
    typingUsers.clear();
    _notificationService.setActiveConversation(conversationId);

    if (conversationId != null) {
      _reverb.subscribeConversation(conversationId);
    }
    appLog('💬 Current conversation set to: $conversationId');
  }

  // ── Realtime (Reverb) handlers ───────────────────────────────────────────

  /// `message.sent` — a new message from another participant. The backend
  /// broadcasts with toOthers(), so our own messages never arrive here.
  void _onRealtimeMessage(Map<String, dynamic> data) {
    try {
      final conversationId = data['conversation_id'] as int?;
      if (conversationId == null) return;

      final message = Message.fromJson(data);

      final existing = conversationMessages[conversationId] ?? [];
      if (existing.any((m) => m.id == message.id)) return;

      _addMessageToConversation(conversationId, message);
      _updateConversationLastMessage(conversationId, message);

      if (conversationId == currentConversationId.value) {
        _markMessageAsReadAsync(message.id);
      }
    } catch (e) {
      appLog('❌ Reverb message.sent handler error: $e');
    }
  }

  /// `message.read` — another participant read messages; refresh their status.
  void _onRealtimeRead(Map<String, dynamic> data) {
    final conversationId = data['conversation_id'] as int?;
    final readerId = data['reader_id'] as int?;
    final ids = (data['message_ids'] as List?)?.map((e) => e as int).toSet();
    if (conversationId == null || readerId == null || ids == null) return;

    final list = conversationMessages[conversationId];
    if (list == null) return;

    for (var i = 0; i < list.length; i++) {
      final m = list[i];
      if (ids.contains(m.id) && !m.hasBeenReadBy(readerId)) {
        list[i] = Message(
          id: m.id,
          conversationId: m.conversationId,
          senderId: m.senderId,
          replyToId: m.replyToId,
          type: m.type,
          content: m.content,
          media: m.media,
          media_url: m.media_url,
          isEdited: m.isEdited,
          editedAt: m.editedAt,
          createdAt: m.createdAt,
          sender: m.sender,
          replyTo: m.replyTo,
          statuses: [
            ...m.statuses,
            MessageStatus(
              id: 0,
              messageId: m.id,
              userId: readerId,
              status: 'read',
              statusUpdatedAt: DateTime.now(),
            ),
          ],
        );
      }
    }
    conversationMessages.refresh();
  }

  /// `user.typing` — show/hide a typing indicator for the active conversation.
  void _onRealtimeTyping(Map<String, dynamic> data) {
    final conversationId = data['conversation_id'] as int?;
    final userId = data['user_id'] as int?;
    final userName = data['user_name']?.toString() ?? '';
    final isTyping = data['is_typing'] == true;
    if (conversationId == null || userId == null) return;
    if (conversationId != currentConversationId.value) return;

    final myId = Get.find<SagrAuthController>().currentUser.value?.id;
    if (userId == myId) return;

    if (isTyping) {
      typingUsers[userId] = userName;
    } else {
      typingUsers.remove(userId);
    }
  }

  /// Tell the backend the current user is typing in [conversationId].
  void sendTyping(int conversationId, bool isTyping) {
    _apiService.sendTyping(conversationId, isTyping);
  }

  Future<void> loadConversations() async {
    try {
      isLoading.value = true;
      final convs = await _apiService.getConversations();
      conversations.value = convs;
      appLog('✅ Loaded ${convs.length} conversations');
    } catch (e) {
      appLog('❌ Error loading conversations: $e');
      AppNotice.error('Error'.tr, 'Failed to load conversations'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMessages(int conversationId, {int page = 1}) async {
    try {
      if (page == 1) isLoadingMessages.value = true;
      
      appLog('📥 Loading messages for conversation $conversationId, page $page');
      
      final messages = await _apiService.getMessages(conversationId, page: page);
      
      if (page == 1) {
        conversationMessages[conversationId] = messages;
      } else {
        conversationMessages[conversationId]?.addAll(messages);
      }
      
      appLog('✅ Loaded ${messages.length} messages');
      
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
      appLog('❌ Error loading messages: $e');
      AppNotice.error('Error'.tr, 'Failed to load messages'.tr);
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
      appLog('⚠️ Already sending a message, ignoring duplicate request');
      return;
    }
    
    appLog('📤 Sending text message to conversation $conversationId');
    appLog('📝 Content: $content');
    
    try {
      isSendingMessage.value = true;
      
      final message = await _apiService.sendTextMessage(
        conversationId: conversationId,
        content: content,
        replyToId: replyToId,
      );
      
      appLog('✅ Message sent successfully: ${message.id}');
      
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
        
        appLog('❌ Backend error: ${e.response!.statusCode} - $errorMessage');
      } else {
        errorMessage = e.message ?? 'Network error occurred';
        appLog('❌ Network error: $errorMessage');
      }
      
      AppNotice.error('Error'.tr, errorMessage);
      
    } catch (e) {
      appLog('❌ Unexpected error: $e');
      AppNotice.error('Error'.tr, 'An unexpected error occurred'.tr);
    } finally {
      // ✅ CRITICAL: Always reset the flag
      isSendingMessage.value = false;
      appLog('✅ Send complete, flag reset');
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
        appLog('⚠️ No image selected');
        return;
      }

      if (isSendingMessage.value) {
        appLog('⚠️ Already sending a message');
        return;
      }

      isSendingMessage.value = true;
      appLog('📤 Sending image message');
      
      final message = await _apiService.sendMediaMessage(
        conversationId: conversationId,
        type: 'image',
        filePath: image.path,
        replyToId: replyToId,
      );

      appLog('✅ Image sent successfully: ${message.id}');
      
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
      
      appLog('❌ Error sending image: $errorMessage');
      
      AppNotice.error('Error'.tr, errorMessage);
      
    } catch (e) {
      appLog('❌ Error sending image: $e');
      AppNotice.error('Error'.tr, 'Failed to send image'.tr);
    } finally {
      isSendingMessage.value = false;
      appLog('✅ Image send complete, flag reset');
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
        appLog('⚠️ No video selected');
        return;
      }

      if (isSendingMessage.value) {
        appLog('⚠️ Already sending a message');
        return;
      }

      isSendingMessage.value = true;
      appLog('📤 Sending video message');
      
      final message = await _apiService.sendMediaMessage(
        conversationId: conversationId,
        type: 'video',
        filePath: video.path,
        replyToId: replyToId,
      );

      appLog('✅ Video sent successfully: ${message.id}');
      
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
      
      appLog('❌ Error sending video: $errorMessage');
      
      AppNotice.error('Error'.tr, errorMessage);
      
    } catch (e) {
      appLog('❌ Error sending video: $e');
      AppNotice.error('Error'.tr, 'Failed to send video'.tr);
    } finally {
      isSendingMessage.value = false;
      appLog('✅ Video send complete, flag reset');
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
        appLog('⚠️ No document selected');
        return;
      }

      final file = result.files.first;
      if (file.path == null) {
        appLog('⚠️ Invalid file path');
        return;
      }

      if (isSendingMessage.value) {
        appLog('⚠️ Already sending a message');
        return;
      }

      isSendingMessage.value = true;
      appLog('📤 Sending document message');
      
      final message = await _apiService.sendMediaMessage(
        conversationId: conversationId,
        type: 'document',
        filePath: file.path!,
        replyToId: replyToId,
      );

      appLog('✅ Document sent successfully: ${message.id}');
      
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
      
      appLog('❌ Error sending document: $errorMessage');
      
      AppNotice.error('Error'.tr, errorMessage);
      
    } catch (e) {
      appLog('❌ Error sending document: $e');
      AppNotice.error('Error'.tr, 'Failed to send document'.tr);
    } finally {
      isSendingMessage.value = false;
      appLog('✅ Document send complete, flag reset');
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
        appLog('⚠️ Already sending a message');
        return;
      }

      isSendingMessage.value = true;
      appLog('📤 Sending voice message');
      
      final message = await _apiService.sendMediaMessage(
        conversationId: conversationId,
        type: 'voice_note',
        filePath: audioPath,
        replyToId: replyToId,
        duration: duration,
      );

      appLog('✅ Voice message sent successfully: ${message.id}');
      
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
      
      appLog('❌ Error sending voice message: $errorMessage');
      
      AppNotice.error('Error'.tr, errorMessage);
      
    } catch (e) {
      appLog('❌ Error sending voice message: $e');
      AppNotice.error('Error'.tr, 'Failed to send voice message'.tr);
    } finally {
      isSendingMessage.value = false;
      appLog('✅ Voice send complete, flag reset');
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
      appLog('❌ Error creating conversation: $e');
      AppNotice.error('Error'.tr, 'Failed to create conversation'.tr);
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
      appLog('❌ Error creating group: $e');
      AppNotice.error('Error'.tr, 'Failed to create group'.tr);
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
      
      appLog('✅ Message deleted: $messageId');
      
    } catch (e) {
      appLog('❌ Error deleting message: $e');
      AppNotice.error('Error'.tr, 'Failed to delete message'.tr);
    }
  }

  void _addMessageToConversation(int conversationId, Message message) {
    appLog('➕ Adding message ${message.id} to conversation $conversationId');
    
    if (conversationMessages[conversationId] == null) {
      conversationMessages[conversationId] = [];
    }
    
    // ✅ Check if message already exists
    final existingIndex = conversationMessages[conversationId]!
        .indexWhere((m) => m.id == message.id);
    
    if (existingIndex != -1) {
      appLog('⚠️ Message ${message.id} already exists, updating');
      conversationMessages[conversationId]![existingIndex] = message;
    } else {
      appLog('✅ Adding new message ${message.id}');
      conversationMessages[conversationId]!.insert(0, message);
    }
    
    conversationMessages.refresh();
  }

  void _updateConversationLastMessage(int conversationId, Message message) {
    appLog('🔄 Updating last message for conversation $conversationId');
    
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
      
      appLog('✅ Conversation updated and moved to top');
    }
  }

  // ✅ FIXED: Handle incoming Firebase messages
  void _handleNewMessage(Map<String, dynamic> data) {
    try {
      appLog('🔔 ========================================');
      appLog('🔔 Received notification data: $data');
      
      final messageType = data['type']?.toString();
      appLog('🔔 Notification type: $messageType');

      if (messageType != 'chat') {
        appLog('ℹ️ Non-chat notification type, ignoring');
        return;
      }

      final conversationId = int.tryParse(
        data['conversation_id']?.toString() ?? ''
      );
      
      appLog('💬 Chat notification for conversation: $conversationId');
      
      if (conversationId == null) {
        appLog('❌ Invalid conversation ID');
        return;
      }

      // Create message from Firebase data
      final message = _createMessageFromFirebaseData(data);

      if (message == null) {
        appLog('❌ Failed to create message from data');
        return;
      }

      appLog('✅ Message created successfully: ${message.id}');
      appLog('👤 Sender ID: ${message.senderId}');
      appLog('👤 Current User ID: ${Get.find<SagrAuthController>().currentUser.value?.id}');

      // ✅ CRITICAL: Only add messages from OTHER users
      final currentUserId = Get.find<SagrAuthController>().currentUser.value?.id;
      
      if (currentUserId != null && message.senderId == currentUserId) {
        appLog('⚠️ This is my own message, ignoring (already added when sent)');
        return;
      }

      // ✅ Check if message already exists to prevent duplicates
      final existingMessages = conversationMessages[conversationId] ?? [];
      final messageExists = existingMessages.any((msg) => msg.id == message.id);

      if (messageExists) {
        appLog('⚠️ Message ${message.id} already exists, skipping');
        return;
      }

      // ✅ Check if we're already processing this message
      if (processingMessageIds.contains(message.id)) {
        appLog('⚠️ Already processing message ${message.id}, skipping');
        return;
      }

      // Mark as processing
      processingMessageIds.add(message.id);

      appLog('➕ Adding new message ${message.id} to conversation $conversationId');
      
      _addMessageToConversation(conversationId, message);
      _updateConversationLastMessage(conversationId, message);
      
      appLog('✅ Message added and conversation updated');
      
      // Mark as read if it's the active conversation
      if (conversationId == currentConversationId.value) {
        appLog('📖 Marking message as read (active conversation)');
        _markMessageAsReadAsync(message.id);
      } else {
        appLog('🔕 Not marking as read (inactive conversation)');
      }

      // Remove from processing after a short delay
      Future.delayed(Duration(seconds: 2), () {
        processingMessageIds.remove(message.id);
      });

      appLog('🔔 ========================================');
      
    } catch (e, stackTrace) {
      appLog('❌ Error handling new message: $e');
      appLog('❌ Stack trace: $stackTrace');
      appLog('❌ Data: $data');
    }
  }

  Message? _createMessageFromFirebaseData(Map<String, dynamic> data) {
    try {
      appLog('📨 Creating message from Firebase data');
      appLog('📨 Raw data: $data');
      
      String messageType = data['msg_type']?.toString() ?? 
                          data['type']?.toString() ?? 
                          'text';
      
      if (messageType == 'chat') {
        messageType = data['msg_type']?.toString() ?? 'text';
      }
      
      messageType = messageType.toLowerCase().trim();
      
      if (messageType == 'photo') messageType = 'image';
      if (messageType == 'voice') messageType = 'voice_note';
      
      appLog('📝 Normalized message type: $messageType');
      
      String? messageContent = data['content']?.toString();
      
      if (messageType == 'text' && (messageContent == null || messageContent.isEmpty)) {
        messageContent = data['message']?.toString() ?? data['text']?.toString();
      }
      
      appLog('💬 Message content: $messageContent');
      
      String? mediaUrl;
      final rawMediaUrl = data['media_url']?.toString();
      
      if (rawMediaUrl != null && rawMediaUrl.isNotEmpty && rawMediaUrl != 'null') {
        if (rawMediaUrl.startsWith('http://') || rawMediaUrl.startsWith('https://')) {
          mediaUrl = rawMediaUrl;
        } else {
          String cleanPath = rawMediaUrl
              .replaceAll(RegExp(r'^/+'), '')
              .replaceAll('uploads/images/', '');

          mediaUrl = '$APIHOST/uploads/images/$cleanPath';
        }
      }
      
      appLog('🖼️ Media URL: $mediaUrl');
      
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
      
      appLog('⏰ Created at: $createdAt');
      
      final messageId = int.tryParse(data['message_id']?.toString() ?? '');
      if (messageId == null || messageId == 0) {
        appLog('❌ Invalid message ID');
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
      
      appLog('✅ Successfully created message: ${message.id} - Type: ${message.type}');
      return message;
      
    } catch (e, stackTrace) {
      appLog('❌ Error creating message from Firebase data: $e');
      appLog('❌ Stack trace: $stackTrace');
      appLog('❌ Failed data: $data');
      return null;
    }
  }

  void _markMessageAsReadAsync(int messageId) {
    Future.microtask(() async {
      try {
        await _apiService.markMessageAsRead(messageId);
        appLog('✅ Message $messageId marked as read');
      } catch (e) {
        appLog('❌ Error marking message as read: $e');
      }
    });
  }

  List<Message> getMessagesForConversation(int conversationId) {
    return conversationMessages[conversationId] ?? [];
  }

  @override
  void onClose() {
    setCurrentConversation(null);
    appLog('🔴 ChatController disposed');
    super.onClose();
  }
}