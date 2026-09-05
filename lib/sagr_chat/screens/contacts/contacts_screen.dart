import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';
import '../../theme/chat_theme.dart';
import '../../widgets/chat_avatar.dart';
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
    final palette = ChatTheme.of(context);
    return Scaffold(
      backgroundColor: palette.scaffold,
      appBar: AppBar(
        title: Text(
          'Contacts'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: palette.title,
          ),
        ),
        backgroundColor: palette.appBar,
        foregroundColor: palette.title,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.group_add_outlined, color: palette.primary),
            tooltip: 'New Group'.tr,
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
    final palette = ChatTheme.of(context);
    return Container(
      color: palette.appBar,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: palette.searchField,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(Icons.search, size: 20, color: palette.hint),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: TextStyle(fontSize: 15, color: palette.body),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Search users'.tr,
                  hintStyle: TextStyle(fontSize: 15, color: palette.hint),
                ),
                onChanged: (value) {
                  setState(() {});
                  _searchUsers(value);
                },
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: Icon(Icons.close, size: 18, color: palette.hint),
                onPressed: () {
                  _searchController.clear();
                  searchResults.clear();
                  setState(() {});
                },
              )
            else
              const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (isSearching.value) {
      return AppLoader.list(items: 8, showTrailing: false);
    }

    if (searchResults.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search_off,
        title: 'No users found'.tr,
        subtitle: 'Try a different search'.tr,
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
      return AppLoader.list(items: 8, showTrailing: false);
    }

    if (contacts.isEmpty) {
      return _buildEmptyState(
        icon: Icons.contacts_outlined,
        title: 'No contacts yet'.tr,
        subtitle: 'Search for users to start chatting'.tr,
      );
    }

    return RefreshIndicator(
      color: ChatTheme.of(context).primary,
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
    final palette = ChatTheme.of(context);
    return ListTile(
      tileColor: palette.surface,
      onTap: onTap,
      leading: ChatAvatar(
        name: user.name,
        imageUrl: user.avatar,
        radius: 24,
        showOnlineDot: true,
        isOnline: user.isOnline,
      ),
      title: Text(
        user.name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: palette.title,
        ),
      ),
      subtitle: Text(
        user.email,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: palette.subtitle, fontSize: 13),
      ),
      trailing: Icon(Icons.chat_bubble_outline, color: palette.primary),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final palette = ChatTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 72, color: palette.hint),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: palette.subtitle,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: palette.hint),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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