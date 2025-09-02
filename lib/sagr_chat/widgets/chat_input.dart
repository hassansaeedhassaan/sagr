import 'package:flutter/material.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onTextSubmitted;
  final VoidCallback? onImageTap;
  final VoidCallback? onVideoTap;
  final VoidCallback? onDocumentTap;
  final VoidCallback? onMicPressed;
  final bool isSending;

  const ChatInput({
    Key? key,
    required this.controller,
    required this.onTextSubmitted,
    this.onImageTap,
    this.onVideoTap,
    this.onDocumentTap,
    this.onMicPressed,
    this.isSending = false,
  }) : super(key: key);

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  bool showEmojiPicker = false;
  bool showAttachmentOptions = false;
  bool hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        hasText = widget.controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showAttachmentOptions) _buildAttachmentOptions(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  showAttachmentOptions ? Icons.close : Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    showAttachmentOptions = !showAttachmentOptions;
                    if (showEmojiPicker) showEmojiPicker = false;
                  });
                },
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showEmojiPicker 
                                    ? Icons.keyboard 
                                    : Icons.emoji_emotions_outlined,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {
                                setState(() {
                                  showEmojiPicker = !showEmojiPicker;
                                  if (showAttachmentOptions) {
                                    showAttachmentOptions = false;
                                  }
                                });
                              },
                            ),
                          ),
                          maxLines: 4,
                          minLines: 1,
                          textInputAction: TextInputAction.send,
                          onSubmitted: widget.onTextSubmitted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildSendButton(),
            ],
          ),
        ),
        // if (showEmojiPicker) _buildEmojiPicker(),
      ],
    );
  }

  Widget _buildSendButton() {
    if (widget.isSending) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: hasText 
          ? () => widget.onTextSubmitted(widget.controller.text)
          : widget.onMicPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          hasText ? Icons.send : Icons.mic,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildAttachmentOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAttachmentOption(
            icon: Icons.photo_camera,
            label: 'Camera',
            color: Colors.pink,
            onTap: widget.onImageTap,
          ),
          _buildAttachmentOption(
            icon: Icons.photo_library,
            label: 'Gallery',
            color: Colors.purple,
            onTap: widget.onImageTap,
          ),
          _buildAttachmentOption(
            icon: Icons.videocam,
            label: 'Video',
            color: Colors.red,
            onTap: widget.onVideoTap,
          ),
          _buildAttachmentOption(
            icon: Icons.description,
            label: 'Document',
            color: Colors.blue,
            onTap: widget.onDocumentTap,
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showAttachmentOptions = false;
        });
        onTap?.call();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Widget _buildEmojiPicker() {
  //   return SizedBox(
  //     height: 250,
  //     child: EmojiPicker(
  //       onEmojiSelected: (category, emoji) {
  //         widget.controller.text += emoji.emoji;
  //       },
  //       config: Config(
  //         columns: 7,
  //         emojiSizeMax: 32,
  //         verticalSpacing: 0,
  //         horizontalSpacing: 0,
  //         gridPadding: EdgeInsets.zero,
  //         initCategory: Category.RECENT,
  //         bgColor: Theme.of(context).scaffoldBackgroundColor,
  //         indicatorColor: Theme.of(context).colorScheme.primary,
  //         iconColor: Colors.grey,
  //         iconColorSelected: Theme.of(context).colorScheme.primary,
  //         backspaceColor: Theme.of(context).colorScheme.primary,
  //         skinToneDialogBgColor: Colors.white,
  //         skinToneIndicatorColor: Colors.grey,
  //         enableSkinTones: true,
  //         // showRecentsTab: true,
  //         recentsLimit: 28,
  //         replaceEmojiOnLimitExceed: false,
  //         noRecents: const Text(
  //           'No Recents',
  //           style: TextStyle(fontSize: 20, color: Colors.black26),
  //           textAlign: TextAlign.center,
  //         ),
  //         loadingIndicator: const SizedBox.shrink(),
  //         tabIndicatorAnimDuration: kTabScrollDuration,
  //         categoryIcons: const CategoryIcons(),
  //         buttonMode: ButtonMode.MATERIAL,
  //         checkPlatformCompatibility: true,
  //       ),
  //     ),
  //   );
  // }
}
