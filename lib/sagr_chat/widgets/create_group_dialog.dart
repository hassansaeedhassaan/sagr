import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user.dart';
import '../theme/chat_theme.dart';
import 'chat_avatar.dart';

/// Compact, professional "new group" dialog: name field, live selected-member
/// chips, searchable member list, and a create action that enables only when
/// the form is valid.
class CreateGroupDialog extends StatefulWidget {
  final List<User> availableUsers;
  final Function(String name, List<int> participants) onCreateGroup;

  const CreateGroupDialog({
    Key? key,
    required this.availableUsers,
    required this.onCreateGroup,
  }) : super(key: key);

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final List<int> _selected = [];
  String _query = '';

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<User> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.availableUsers;
    return widget.availableUsers
        .where((u) =>
            u.name.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q))
        .toList();
  }

  bool get _canCreate =>
      _nameController.text.trim().isNotEmpty && _selected.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final palette = ChatTheme.of(context);
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: palette.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: size.height * 0.78),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(palette),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: _nameField(palette),
            ),
            if (_selected.isNotEmpty) _selectedStrip(palette),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: _searchField(palette),
            ),
            Flexible(child: _memberList(palette)),
            _actions(palette),
          ],
        ),
      ),
    );
  }

  Widget _header(ChatPalette palette) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: palette.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.groups_rounded, color: palette.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Create Group'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: palette.title,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: palette.subtitle),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Widget _nameField(ChatPalette palette) {
    return TextField(
      controller: _nameController,
      textCapitalization: TextCapitalization.words,
      onChanged: (_) => setState(() {}),
      style: TextStyle(color: palette.body),
      decoration: InputDecoration(
        hintText: 'Group Name'.tr,
        hintStyle: TextStyle(color: palette.hint),
        prefixIcon: Icon(Icons.edit_outlined, color: palette.subtitle),
        filled: true,
        fillColor: palette.searchField,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.primary, width: 1.4),
        ),
      ),
    );
  }

  Widget _selectedStrip(ChatPalette palette) {
    final selectedUsers =
        widget.availableUsers.where((u) => _selected.contains(u.id)).toList();
    return Container(
      height: 84,
      margin: const EdgeInsets.only(top: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: selectedUsers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final u = selectedUsers[i];
          return SizedBox(
            width: 52,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ChatAvatar(name: u.name, imageUrl: u.avatar, radius: 22),
                    PositionedDirectional(
                      end: -2,
                      top: -2,
                      child: GestureDetector(
                        onTap: () => setState(() => _selected.remove(u.id)),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: palette.subtitle,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: palette.surface, width: 1.5),
                          ),
                          child: const Icon(Icons.close,
                              size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  u.name.split(' ').first,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: palette.subtitle),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _searchField(ChatPalette palette) {
    return Container(
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
              onChanged: (v) => setState(() => _query = v),
              style: TextStyle(fontSize: 15, color: palette.body),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Search users'.tr,
                hintStyle: TextStyle(fontSize: 15, color: palette.hint),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _memberList(ChatPalette palette) {
    final users = _filtered;
    if (users.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'No users found'.tr,
          style: TextStyle(color: palette.hint),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final isSelected = _selected.contains(user.id);
        return InkWell(
          onTap: () => setState(() {
            isSelected ? _selected.remove(user.id) : _selected.add(user.id);
          }),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            child: Row(
              children: [
                ChatAvatar(name: user.name, imageUrl: user.avatar, radius: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: palette.title,
                        ),
                      ),
                      Text(
                        user.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: palette.subtitle),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _checkmark(palette, isSelected),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _checkmark(ChatPalette palette, bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: selected ? palette.primary : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? palette.primary : palette.hint,
          width: 1.6,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 15, color: Colors.white)
          : null,
    );
  }

  Widget _actions(ChatPalette palette) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: palette.divider)),
      ),
      child: Row(
        children: [
          Text(
            '${_selected.length} ${'selected'.tr}',
            style: TextStyle(fontSize: 13, color: palette.subtitle),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel'.tr,
              style: TextStyle(color: palette.subtitle),
            ),
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            onPressed: _canCreate ? _createGroup : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: palette.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: palette.hint.withOpacity(0.4),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text('Create'.tr,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _createGroup() {
    widget.onCreateGroup(_nameController.text.trim(), _selected);
    Get.back();
  }
}
