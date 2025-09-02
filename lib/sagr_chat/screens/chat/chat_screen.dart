import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../models/conversation.dart';
import '../../models/message.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/chat_input.dart';
import '../../widgets/voice_recorder.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SagrAuthController authController = Get.find<SagrAuthController>();
  final ChatController chatController = Get.find<ChatController>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  
  late Conversation conversation;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    conversation = Get.arguments as Conversation;
    chatController.loadMessages(conversation.id);
    
    // Scroll to bottom when new messages arrive
    scrollController.addListener(() {
      if (scrollController.position.pixels == 
          scrollController.position.maxScrollExtent) {
        // Load more messages when scrolled to top
        _loadMoreMessages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = authController.currentUser.value!.id;
    final otherParticipant = conversation.getOtherParticipant(currentUserId);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: conversation.getDisplayAvatar(currentUserId) != null
                  ? CachedNetworkImageProvider(
                      conversation.getDisplayAvatar(currentUserId)!)
                  : null,
              child: conversation.getDisplayAvatar(currentUserId) == null
                  ? Text(conversation.getDisplayName(currentUserId)[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.getDisplayName(currentUserId),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  if (otherParticipant != null)
                    Text(
                      otherParticipant.statusDisplay,
                      style: TextStyle(
                        fontSize: 12,
                        color: otherParticipant.isOnline 
                            ? Colors.green 
                            : Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // Implement video call
              Get.snackbar('Coming Soon', 'Video call feature will be available soon');
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // Implement voice call
              Get.snackbar('Coming Soon', 'Voice call feature will be available soon');
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('View Contact'),
                onTap: () {/* Show contact info */},
              ),
              PopupMenuItem(
                child: const Text('Media, Links, and Docs'),
                onTap: () {/* Show media gallery */},
              ),
              if (conversation.isGroupChat)
                PopupMenuItem(
                  child: const Text('Group Info'),
                  onTap: () {/* Show group info */},
                ),
              PopupMenuItem(
                child: const Text('Clear Chat'),
                onTap: () {/* Clear chat */},
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (chatController.isLoadingMessages.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final messages = chatController.getMessagesForConversation(conversation.id);
              
              if (messages.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                controller: scrollController,
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isMe = message.senderId == currentUserId;
                  final showAvatar = _shouldShowAvatar(messages, index, isMe);
                  
                  return MessageBubble(
                    message: message,
                    isMe: isMe,
                    showAvatar: showAvatar,
                    onLongPress: () => _showMessageOptions(message),
                  );
                },
              );
            }),
          ),
          if (isRecording)
            VoiceRecorderWaveforms(
              onRecordingComplete: (audioPath, duration) {
                setState(() => isRecording = false);
                chatController.sendVoiceMessage(
                  conversationId: conversation.id,
                  audioPath: audioPath,
                  duration: duration,
                );
              },
              onCancel: () => setState(() => isRecording = false),
            ),
          ChatInput(
            controller: messageController,
            onTextSubmitted: _sendTextMessage,
            onImageTap: () => chatController.sendImageMessage(
              conversationId: conversation.id,
            ),
            onVideoTap: () => chatController.sendVideoMessage(
              conversationId: conversation.id,
            ),
            onDocumentTap: () => chatController.sendDocumentMessage(
              conversationId: conversation.id,
            ),
            onMicPressed: () => setState(() => isRecording = true),
            isSending: chatController.isSendingMessage.value,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send a message to start the conversation',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
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

  void _sendTextMessage(String text) {
    if (text.trim().isEmpty) return;
    
    chatController.sendTextMessage(
      conversationId: conversation.id,
      content: text.trim(),
    );
    
    messageController.clear();
    
    // Scroll to bottom
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

  void _loadMoreMessages() {
    // Implement pagination
    // chatController.loadMessages(conversation.id, page: nextPage);
  }

  void _showMessageOptions(Message message) {
    final currentUserId = authController.currentUser.value!.id;
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message.isTextMessage)
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy'),
              onTap: () {
                // Copy message content
                Get.back();
              },
            ),
          ListTile(
            leading: const Icon(Icons.reply),
            title: const Text('Reply'),
            onTap: () {
              // Set reply message
              Get.back();
            },
          ),
          if (message.senderId == currentUserId)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                _deleteMessage(message);
              },
            ),
        ],
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
      },
    );
  }
}