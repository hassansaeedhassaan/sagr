import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../models/conversation.dart';
import '../../models/message.dart';
import '../../theme/chat_theme.dart';
import '../../utils/chat_time.dart';
import '../../widgets/chat_avatar.dart';
import '../../widgets/chat_skeletons.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/chat_input.dart';
import '../../widgets/swipe_to_reply.dart';
import '../../widgets/voice_recorder.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final SagrAuthController authController = Get.find<SagrAuthController>();
  final ChatController chatController = Get.find<ChatController>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  
  late Conversation conversation;
  bool isRecording = false;
  Message? replyToMessage;
  int currentPage = 1;
  bool isLoadingMore = false;

  // Typing indicator: emit typing=true on first keystroke, typing=false after
  // a pause — debounced so we don't hit the API on every character.
  Timer? _typingTimer;
  bool _typingSent = false;

  void _onComposerChanged(String text) {
    if (!_typingSent && text.isNotEmpty) {
      _typingSent = true;
      chatController.sendTyping(conversation.id, true);
    }
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 3), _stopTyping);
  }

  void _stopTyping() {
    _typingTimer?.cancel();
    if (_typingSent) {
      _typingSent = false;
      chatController.sendTyping(conversation.id, false);
    }
  }

  @override
  void initState() {
    super.initState();
    
    // ✅ Add lifecycle observer
    WidgetsBinding.instance.addObserver(this);
    
    // Get conversation from arguments
    conversation = Get.arguments as Conversation;
    
    // ✅ Set this as the active conversation
    chatController.setCurrentConversation(conversation.id);
    
    // Load initial messages
    chatController.loadMessages(conversation.id);
    
    // Setup scroll listener for pagination
    scrollController.addListener(_onScroll);
    
    print('✅ Chat screen initialized for conversation: ${conversation.id}');
  }

  @override
  void dispose() {
    print('🔴 Chat screen disposing for conversation: ${conversation.id}');

    _typingTimer?.cancel();

    // ✅ Clear active conversation
    chatController.setCurrentConversation(null);
    
    // Remove lifecycle observer
    WidgetsBinding.instance.removeObserver(this);
    
    // Cleanup controllers
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    messageController.dispose();
    
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    print('📱 App lifecycle state changed: $state');
    
    switch (state) {
      case AppLifecycleState.resumed:
        // ✅ App came to foreground - set active conversation
        print('✅ App resumed - setting active conversation: ${conversation.id}');
        chatController.setCurrentConversation(conversation.id);
        
        // Reload messages to get any new ones
        chatController.loadMessages(conversation.id);
        break;
        
      case AppLifecycleState.paused:
        // ✅ App went to background - clear active conversation
        print('⏸️ App paused - clearing active conversation');
        chatController.setCurrentConversation(null);
        break;
        
      case AppLifecycleState.inactive:
        // App is inactive (e.g., taking a call)
        print('⏸️ App inactive');
        break;
        
      case AppLifecycleState.detached:
        // App is detached
        print('🔴 App detached');
        break;
        
      case AppLifecycleState.hidden:
        // App is hidden
        print('🔴 App hidden');
        break;
    }
  }

  void _onScroll() {
    // Load more messages when scrolled to top
    if (scrollController.position.pixels >= 
        scrollController.position.maxScrollExtent - 100 && 
        !isLoadingMore) {
      _loadMoreMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = authController.currentUser.value!.id;
    final otherParticipant = conversation.getOtherParticipant(currentUserId);

    return Scaffold(
      backgroundColor: ChatTheme.of(context).scaffold,
      appBar: _buildAppBar(currentUserId, otherParticipant),
      body: Column(
        children: [
          // Reply preview
          if (replyToMessage != null) _buildReplyPreview(),
          
          // Messages list
          Expanded(
            child: Obx(() => _buildMessagesList(currentUserId)),
          ),
          
          // Voice recorder (shows when recording)
          if (isRecording) _buildVoiceRecorder(),
          
          // Chat input
          _buildChatInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(int currentUserId, dynamic otherParticipant) {
    final palette = ChatTheme.of(context);
    return AppBar(
      titleSpacing: 0,
      backgroundColor: palette.appBar,
      foregroundColor: palette.title,
      elevation: 0,
      scrolledUnderElevation: 1,
      iconTheme: IconThemeData(color: palette.title),
      title: InkWell(
        onTap: () => _showConversationInfo(),
        child: Row(
          children: [
            Hero(
              tag: 'avatar_${conversation.id}',
              child: ChatAvatar(
                name: conversation.getDisplayName(currentUserId),
                imageUrl: conversation.getDisplayAvatar(currentUserId),
                radius: 20,
                showOnlineDot: true,
                isOnline: otherParticipant?.isOnline == true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    conversation.getDisplayName(currentUserId),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: palette.title,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (otherParticipant != null)
                    Obx(() {
                      final isTyping = chatController.typingUsers
                          .containsKey(otherParticipant.id);
                      return Text(
                        isTyping
                            ? 'typing...'.tr
                            : otherParticipant.isOnline
                                ? 'Online'.tr
                                : otherParticipant.statusDisplay,
                        style: TextStyle(
                          fontSize: 12,
                          color: isTyping || otherParticipant.isOnline
                              ? palette.online
                              : palette.subtitle,
                        ),
                      );
                    })
                  else if (conversation.isGroupChat)
                    Text(
                      '${conversation.participantsCount} ${'participants'.tr}',
                      style: TextStyle(
                        fontSize: 12,
                        color: palette.subtitle,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () {
            Get.snackbar(
              'Coming Soon',
              'Video call feature will be available soon',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.call),
          onPressed: () {
            Get.snackbar(
              'Coming Soon',
              'Voice call feature will be available soon',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            );
          },
        ),
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'contact',
              child: const Row(
                children: [
                  Icon(Icons.person_outline),
                  SizedBox(width: 12),
                  Text('View Contact'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'media',
              child: const Row(
                children: [
                  Icon(Icons.photo_library_outlined),
                  SizedBox(width: 12),
                  Text('Media, Links, and Docs'),
                ],
              ),
            ),
            if (conversation.isGroupChat)
              PopupMenuItem(
                value: 'group_info',
                child: const Row(
                  children: [
                    Icon(Icons.group_outlined),
                    SizedBox(width: 12),
                    Text('Group Info'),
                  ],
                ),
              ),
            PopupMenuItem(
              value: 'mute',
              child: const Row(
                children: [
                  Icon(Icons.notifications_off_outlined),
                  SizedBox(width: 12),
                  Text('Mute Notifications'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'clear',
              child: const Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Clear Chat', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) => _handleMenuAction(value.toString()),
        ),
      ],
    );
  }

  Widget _buildReplyPreview() {
    final palette = ChatTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(bottom: BorderSide(color: palette.divider)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: palette.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  replyToMessage!.senderId ==
                          authController.currentUser.value!.id
                      ? 'You'.tr
                      : (replyToMessage!.sender?.name ?? 'Replying to'.tr),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: palette.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  replyToMessage!.displayContent,
                  style: TextStyle(fontSize: 14, color: palette.subtitle),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 20, color: palette.subtitle),
            onPressed: () => setState(() => replyToMessage = null),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(int currentUserId) {
    if (chatController.isLoadingMessages.value && currentPage == 1) {
      return const ChatMessagesSkeleton();
    }

    final messages = chatController.getMessagesForConversation(conversation.id);
    
    if (messages.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: messages.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at the end
        if (isLoadingMore && index == messages.length) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppLoader.inline(),
          );
        }

        final message = messages[index];
        final isMe = message.senderId == currentUserId;
        final showAvatar = _shouldShowAvatar(messages, index, isMe);
        final showTimestamp = _shouldShowTimestamp(messages, index);
        
        return Column(
          children: [
            if (showTimestamp) _buildTimestampDivider(message.createdAt),
            SwipeToReply(
              onReply: () => setState(() => replyToMessage = message),
              child: MessageBubble(
                message: message,
                isMe: isMe,
                showAvatar: showAvatar,
                onLongPress: () => _showMessageOptions(message),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimestampDivider(DateTime timestamp) {
    final palette = ChatTheme.of(context);
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 14),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: palette.dateChipBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          ChatTime.dateDivider(timestamp),
          style: TextStyle(
            fontSize: 12,
            color: palette.dateChipText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceRecorder() {
    return VoiceRecorderWaveforms(
      onRecordingComplete: (audioPath, duration) {
        setState(() => isRecording = false);
        chatController.sendVoiceMessage(
          conversationId: conversation.id,
          audioPath: audioPath,
          duration: duration,
          replyToId: replyToMessage?.id,
        );
        setState(() => replyToMessage = null);
      },
      onCancel: () => setState(() => isRecording = false),
    );
  }


Widget _buildChatInput() {
  // Reactive: rebuilds the send button while a message is in flight.
  return Obx(() {
    return ChatInput(
      controller: messageController,
      onChanged: _onComposerChanged,
      onTextSubmitted: _sendTextMessage,
      onImageTap: () {
        chatController.sendImageMessage(
          conversationId: conversation.id,
          replyToId: replyToMessage?.id,
        );
        setState(() => replyToMessage = null);
      },
      onVideoTap: () {
        chatController.sendVideoMessage(
          conversationId: conversation.id,
          replyToId: replyToMessage?.id,
        );
        setState(() => replyToMessage = null);
      },
      onDocumentTap: () {
        chatController.sendDocumentMessage(
          conversationId: conversation.id,
          replyToId: replyToMessage?.id,
        );
        setState(() => replyToMessage = null);
      },
      onMicPressed: () => setState(() => isRecording = true),
      isSending: chatController.isSendingMessage.value,
    );
  });
}

  Widget _buildEmptyState() {
    final palette = ChatTheme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 72, color: palette.hint),
          const SizedBox(height: 16),
          Text(
            'No messages yet'.tr,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: palette.subtitle,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Send a message to start the conversation'.tr,
            style: TextStyle(fontSize: 14, color: palette.hint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  bool _shouldShowAvatar(List<Message> messages, int index, bool isMe) {
    if (isMe || conversation.isPrivateChat) return false;
    
    if (index == messages.length - 1) return true;
    
    final nextMessage = messages[index + 1];
    return nextMessage.senderId != messages[index].senderId;
  }

  bool _shouldShowTimestamp(List<Message> messages, int index) {
    if (index == messages.length - 1) return true;
    
    final currentMessage = messages[index];
    final nextMessage = messages[index + 1];
    
    final currentDate = DateTime(
      currentMessage.createdAt.year,
      currentMessage.createdAt.month,
      currentMessage.createdAt.day,
    );
    
    final nextDate = DateTime(
      nextMessage.createdAt.year,
      nextMessage.createdAt.month,
      nextMessage.createdAt.day,
    );
    
    return currentDate != nextDate;
  }

  void _sendTextMessage(String text) {
    if (text.trim().isEmpty) return;

    _stopTyping();

    chatController.sendTextMessage(
      conversationId: conversation.id,
      content: text.trim(),
      replyToId: replyToMessage?.id,
    );
    
    messageController.clear();
    setState(() => replyToMessage = null);
    
    // Scroll to bottom
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _scrollToMessage(int messageId) {
    final messages = chatController.getMessagesForConversation(conversation.id);
    final index = messages.indexWhere((m) => m.id == messageId);
    
    if (index != -1 && scrollController.hasClients) {
      final position = index * 100.0; // Approximate message height
      scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _loadMoreMessages() async {
    if (isLoadingMore) return;
    
    setState(() => isLoadingMore = true);
    currentPage++;
    
    print('📄 Loading page $currentPage');
    
    await chatController.loadMessages(conversation.id, page: currentPage);
    
    setState(() => isLoadingMore = false);
  }

  void _showMessageOptions(Message message) {
    final currentUserId = authController.currentUser.value!.id;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            if (message.isTextMessage)
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: message.content ?? ''));
                  Get.back();
                  Get.snackbar(
                    'Copied',
                    'Message copied to clipboard',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Reply'),
              onTap: () {
                setState(() => replyToMessage = message);
                Get.back();
                // Focus on input
                FocusScope.of(context).requestFocus();
              },
            ),
            ListTile(
              leading: const Icon(Icons.forward),
              title: const Text('Forward'),
              onTap: () {
                Get.back();
                _forwardMessage(message);
              },
            ),
            if (message.senderId == currentUserId) ...[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Get.back();
                  _editMessage(message);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Get.back();
                  _deleteMessage(message);
                },
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _deleteMessage(Message message) {
    Get.defaultDialog(
      title: 'Delete Message',
      middleText: 'Are you sure you want to delete this message?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        chatController.deleteMessage(message.id, conversation.id);
        Get.back();
        Get.snackbar(
          'Deleted',
          'Message deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      },
    );
  }

  void _editMessage(Message message) {
    // TODO: Implement edit message functionality
    Get.snackbar(
      'Coming Soon',
      'Edit message feature will be available soon',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _forwardMessage(Message message) {
    // TODO: Implement forward message functionality
    Get.snackbar(
      'Coming Soon',
      'Forward message feature will be available soon',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _showConversationInfo() {
    // TODO: Navigate to conversation info screen
    Get.snackbar(
      'Coming Soon',
      'Conversation info will be available soon',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'contact':
        _showConversationInfo();
        break;
      case 'media':
        Get.snackbar(
          'Coming Soon',
          'Media gallery will be available soon',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        break;
      case 'group_info':
        _showConversationInfo();
        break;
      case 'mute':
        Get.snackbar(
          'Coming Soon',
          'Mute notifications will be available soon',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        break;
      case 'clear':
        _clearChat();
        break;
    }
  }

  void _clearChat() {
    Get.defaultDialog(
      title: 'Clear Chat',
      middleText: 'Are you sure you want to clear all messages in this chat?',
      textConfirm: 'Clear',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        // TODO: Implement clear chat
        Get.back();
        Get.snackbar(
          'Coming Soon',
          'Clear chat feature will be available soon',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      },
    );
  }
}