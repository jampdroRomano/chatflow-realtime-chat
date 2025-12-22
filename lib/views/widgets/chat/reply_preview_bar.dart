import 'package:flutter/material.dart';
import '../../../models/message_model.dart';

class ReplyPreviewBar extends StatelessWidget {
  final ChatMessage replyingTo;
  final String currentUserId;
  final VoidCallback onCancel;

  const ReplyPreviewBar({
    super.key,
    required this.replyingTo,
    required this.currentUserId,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = replyingTo.senderId == currentUserId 
        ? "Você" 
        : replyingTo.senderName;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 14,
                    color: theme.colorScheme.primary
                  )
                ),
                Text(
                  replyingTo.text, 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  style: const TextStyle(color: Colors.grey)
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey), 
            onPressed: onCancel
          )
        ],
      ),
    );
  }
}