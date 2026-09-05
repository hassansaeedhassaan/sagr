import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../models/conversation.dart';
import '../../theme/chat_theme.dart';
import '../../widgets/conversation_tile.dart';

class HomeScreenChat extends StatefulWidget {
  @override
  State<HomeScreenChat> createState() => _HomeScreenChatState();
}

class _HomeScreenChatState extends State<HomeScreenChat> {
  final SagrAuthController authController = Get.find<SagrAuthController>();
  final ChatController chatController = Get.find<ChatController>();
  final TextEditingController _searchController = TextEditingController();
  final RxString _query = ''.obs;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = ChatTheme.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        Get.toNamed('/home');
      },
      child: MasterWrapper(
        body: Scaffold(
          backgroundColor: palette.scaffold,
          appBar: _buildAppBar(palette),
          floatingActionButton: FloatingActionButton(
            backgroundColor: palette.primary,
            elevation: 2,
            onPressed: () => Get.toNamed('/contacts'),
            child: const Icon(Icons.edit_outlined, color: Colors.white),
          ),
          body: Column(
            children: [
              _buildSearchField(palette),
              Expanded(
                child: Obx(() {
                  if (chatController.isLoading.value &&
                      chatController.conversations.isEmpty) {
                    return AppLoader.list(items: 9);
                  }

                  final items = _filtered();
                  if (chatController.conversations.isEmpty) {
                    return _buildEmptyState(palette, searching: false);
                  }
                  if (items.isEmpty) {
                    return _buildEmptyState(palette, searching: true);
                  }

                  return RefreshIndicator(
                    color: palette.primary,
                    onRefresh: chatController.loadConversations,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => Padding(
                        padding: const EdgeInsetsDirectional.only(start: 82),
                        child: Divider(
                          height: 1,
                          thickness: 0.6,
                          color: palette.divider,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        final conversation = items[index];
                        return ConversationTile(
                          conversation: conversation,
                          currentUserId: authController.currentUser.value!.id,
                          onTap: () => _openChat(conversation),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ChatPalette palette) {
    return AppBar(
      backgroundColor: palette.appBar,
      elevation: 0,
      scrolledUnderElevation: 1,
      titleSpacing: ChatTheme.tileHPad,
      title: Text(
        'Chats'.tr,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: palette.title,
        ),
      ),
    );
  }

  Widget _buildSearchField(ChatPalette palette) {
    return Container(
      color: palette.appBar,
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: palette.searchField,
          borderRadius: BorderRadius.circular(21),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(Icons.search, size: 20, color: palette.hint),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (v) => _query.value = v,
                style: TextStyle(fontSize: 15, color: palette.body),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Search chats'.tr,
                  hintStyle: TextStyle(fontSize: 15, color: palette.hint),
                ),
              ),
            ),
            Obx(() => _query.value.isEmpty
                ? const SizedBox(width: 12)
                : IconButton(
                    icon: Icon(Icons.close, size: 18, color: palette.hint),
                    onPressed: () {
                      _searchController.clear();
                      _query.value = '';
                    },
                  )),
          ],
        ),
      ),
    );
  }

  List<Conversation> _filtered() {
    final q = _query.value.trim().toLowerCase();
    final all = chatController.conversations;
    if (q.isEmpty) return all;
    final uid = authController.currentUser.value!.id;
    return all.where((c) {
      final name = c.getDisplayName(uid).toLowerCase();
      final last = c.lastMessage?.content?.toLowerCase() ?? '';
      return name.contains(q) || last.contains(q);
    }).toList();
  }

  Widget _buildEmptyState(ChatPalette palette, {required bool searching}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              searching ? Icons.search_off : Icons.forum_outlined,
              size: 72,
              color: palette.hint,
            ),
            const SizedBox(height: 16),
            Text(
              searching ? 'No results found'.tr : 'No conversations yet'.tr,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: palette.subtitle,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              searching
                  ? 'Try a different search'.tr
                  : 'Start a new chat with the button below'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: palette.hint),
            ),
          ],
        ),
      ),
    );
  }

  void _openChat(Conversation conversation) {
    Get.toNamed('/chat', arguments: conversation);
  }
}
