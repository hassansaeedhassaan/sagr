import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../controllers/auth_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../models/conversation.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/conversation_tile.dart';

class HomeScreenChat extends StatelessWidget {
  final SagrAuthController authController = Get.find<SagrAuthController>();
  final ChatController chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Chats',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed('/contacts'),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Profile'),
                onTap: () => _showProfileBottomSheet(context),
              ),
              PopupMenuItem(
                child: const Text('New Group'),
                onTap: () => _showNewGroupDialog(context),
              ),
              PopupMenuItem(
                child: const Text('Settings'),
                onTap: () {/* Navigate to settings */},
              ),
              PopupMenuItem(
                child: const Text('Logout'),
                onTap: () => authController.logout(),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (chatController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (chatController.conversations.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: chatController.loadConversations,
          child: ListView.builder(
            itemCount: chatController.conversations.length,
            itemBuilder: (context, index) {
              final conversation = chatController.conversations[index];
              return ConversationTile(
                conversation: conversation,
                currentUserId: authController.currentUser.value!.id,
                onTap: () => _openChat(conversation),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/contacts'),
        child: const Icon(Icons.chat),
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
            'No conversations yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a new conversation by tapping the + button',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _openChat(Conversation conversation) {
    Get.toNamed('/chat', arguments: conversation);
  }

  void _showProfileBottomSheet(BuildContext context) {
    final user = authController.currentUser.value!;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user.avatar != null
                  ? CachedNetworkImageProvider(user.avatar!)
                  : null,
              child: user.avatar == null
                  ? Text(
                      user.name[0].toUpperCase(),
                      style: const TextStyle(fontSize: 32),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      // Navigate to edit profile
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showNewGroupDialog(BuildContext context) {
    // Implement new group creation dialog
    Get.snackbar('Coming Soon', 'Group creation will be available soon');
  }
}