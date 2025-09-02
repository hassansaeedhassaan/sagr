import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/user.dart';


class CreateGroupDialog extends StatefulWidget {
  final List<User> availableUsers;
  final Function(String name, List<int> participants) onCreateGroup;

  const CreateGroupDialog({
    Key? key,
    required this.availableUsers,
    required this.onCreateGroup,
  }) : super(key: key);

  @override
  _CreateGroupDialogState createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final TextEditingController _nameController = TextEditingController();
  final List<int> selectedUsers = [];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Group'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Select Participants:'),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.availableUsers.length,
                itemBuilder: (context, index) {
                  final user = widget.availableUsers[index];
                  final isSelected = selectedUsers.contains(user.id);
                  
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedUsers.add(user.id);
                        } else {
                          selectedUsers.remove(user.id);
                        }
                      });
                    },
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    secondary: CircleAvatar(
                      backgroundImage: user.avatar != null
                          ? CachedNetworkImageProvider(user.avatar!)
                          : null,
                      child: user.avatar == null
                          ? Text(user.name[0].toUpperCase())
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _canCreateGroup() ? _createGroup : null,
          child: const Text('Create'),
        ),
      ],
    );
  }

  bool _canCreateGroup() {
    return _nameController.text.trim().isNotEmpty && selectedUsers.isNotEmpty;
  }

  void _createGroup() {
    widget.onCreateGroup(
      _nameController.text.trim(),
      selectedUsers,
    );
    Get.back();
  }
}
