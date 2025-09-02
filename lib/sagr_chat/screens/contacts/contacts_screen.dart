import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import '../../widgets/create_group_dialog.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final SagrAuthController authController = Get.find<SagrAuthController>();
  final ChatController chatController = Get.find<ChatController>();
  final ApiService apiService = Get.find<ApiService>();

  final TextEditingController _searchController = TextEditingController();
  final RxList<User> searchResults = <User>[].obs;
  final RxList<User> contacts = <User>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool isLoadingContacts = false.obs;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    try {
      isLoadingContacts.value = true;
      final contactsList = await apiService.getContacts();
      contacts.value = contactsList;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load contacts');
    } finally {
      isLoadingContacts.value = false;
    }
  }

  Future<void> _searchUsers(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    try {
      isSearching.value = true;
      final results = await apiService.searchUsers(query.trim());
      searchResults.value = results;
    } catch (e) {
      Get.snackbar('Error', 'Failed to search users');
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: () => _showCreateGroupDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Obx(() {
              if (_searchController.text.trim().isNotEmpty) {
                return _buildSearchResults();
              } else {
                return _buildContactsList();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search users by name, email, or phone',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    searchResults.clear();
                    setState(() {});
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          setState(() {});
          _searchUsers(value);
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    if (isSearching.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchResults.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search_off,
        title: 'No users found',
        subtitle: 'Try searching with a different term',
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final user = searchResults[index];
        return _buildUserTile(
          user: user,
          onTap: () => _startConversation(user),
        );
      },
    );
  }

  Widget _buildContactsList() {
    if (isLoadingContacts.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (contacts.isEmpty) {
      return _buildEmptyState(
        icon: Icons.contacts_outlined,
        title: 'No contacts yet',
        subtitle: 'Search for users to start chatting',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadContacts,
      child: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final user = contacts[index];
          return _buildUserTile(
            user: user,
            onTap: () => _startConversation(user),
          );
        },
      ),
    );
  }

  Widget _buildUserTile({
    required User user,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: user.avatar != null
                ? CachedNetworkImageProvider(user.avatar!)
                : null,
            child: user.avatar == null
                ? Text(
                    user.name[0].toUpperCase(),
                    style: const TextStyle(fontSize: 18),
                  )
                : null,
          ),
          if (user.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.email,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            user.statusDisplay,
            style: TextStyle(
              color: user.isOnline ? Colors.green : Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
      trailing: const Icon(Icons.chat_bubble_outline),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
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

  void _startConversation(User user) {
    chatController.createPrivateConversation(user.id);
  }

  void _showCreateGroupDialog() {
    Get.dialog(
      CreateGroupDialog(
        availableUsers: contacts,
        onCreateGroup: (name, participants) {
          chatController.createGroupConversation(
            name: name,
            participants: participants,
          );
        },
      ),
    );
  }
}