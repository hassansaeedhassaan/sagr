import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/chat_theme.dart';

/// Bottom composer: attachment button, rounded pill text field, and a
/// send/mic button that morphs based on whether there is text.
class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onTextSubmitted;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onImageTap;
  final VoidCallback? onVideoTap;
  final VoidCallback? onDocumentTap;
  final VoidCallback? onMicPressed;
  final bool isSending;

  const ChatInput({
    Key? key,
    required this.controller,
    required this.onTextSubmitted,
    this.onChanged,
    this.onImageTap,
    this.onVideoTap,
    this.onDocumentTap,
    this.onMicPressed,
    this.isSending = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = ChatTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: palette.appBar,
        boxShadow: ChatTheme.softShadow(palette.navy),
      ),
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: palette.primary),
              onPressed: isSending ? null : () => _showAttachments(palette),
            ),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: palette.searchField,
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: controller,
                  enabled: !isSending,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(fontSize: 15.5, color: palette.body),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 11),
                    hintText: 'Message'.tr,
                    hintStyle: TextStyle(color: palette.hint, fontSize: 15.5),
                  ),
                  textInputAction: TextInputAction.send,
                  onChanged: onChanged,
                  onSubmitted: isSending ? null : onTextSubmitted,
                ),
              ),
            ),
            const SizedBox(width: 6),
            _sendButton(palette),
          ],
        ),
      ),
    );
  }

  Widget _sendButton(ChatPalette palette) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: isSending ? palette.tickSent : palette.primary,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: isSending ? null : _handleSendTap,
          child: Center(
            child: isSending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller,
                    builder: (context, value, _) {
                      final hasText = value.text.trim().isNotEmpty;
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        child: Icon(
                          hasText ? Icons.send_rounded : Icons.mic,
                          key: ValueKey(hasText),
                          color: Colors.white,
                          size: 22,
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  void _handleSendTap() {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      onTextSubmitted(text);
    } else {
      onMicPressed?.call();
    }
  }

  void _showAttachments(ChatPalette palette) {
    if (isSending) return;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: palette.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _option(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery'.tr,
                    color: const Color(0xff8b5cf6),
                    onTap: onImageTap,
                  ),
                  _option(
                    icon: Icons.videocam_rounded,
                    label: 'Video'.tr,
                    color: const Color(0xffef4444),
                    onTap: onVideoTap,
                  ),
                  _option(
                    icon: Icons.insert_drive_file_rounded,
                    label: 'Document'.tr,
                    color: const Color(0xff0ea5e9),
                    onTap: onDocumentTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }

  Widget _option({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.back();
        if (onTap != null) {
          Future.delayed(const Duration(milliseconds: 120), onTap);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
