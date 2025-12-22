import 'package:flutter/material.dart';
import '../../../models/message_model.dart';
import 'bubbles/deleted_message_bubble.dart';
import 'bubbles/message_content.dart';
import 'bubbles/reply_preview_in_bubble.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String currentUserId;
  final bool isMe;
  final bool showTail;
  final bool isSelected;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final VoidCallback onSwipeReply;

  const MessageBubble({
    super.key,
    required this.message,
    required this.currentUserId,
    required this.isMe,
    required this.showTail,
    required this.isSelected,
    required this.onLongPress,
    required this.onTap,
    required this.onSwipeReply,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isDeleted) {
      return DeletedMessageBubble(isMe: isMe);
    }

    final theme = Theme.of(context);
    
    final normalColor = isMe ? theme.colorScheme.primary : theme.colorScheme.secondary;
    final bubbleColor = isSelected ? normalColor.withValues(alpha: 0.7) : normalColor;
    final rowColor = isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent;
    final textColor = isMe ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;
    final timeColor = isMe 
        ? theme.colorScheme.onPrimary.withValues(alpha: 0.7) 
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);

    final bool isShortMessage = message.text.length < 25 && !message.text.contains('\n');

    return Container(
      color: rowColor,
      child: Dismissible(
        key: Key(message.id),
        direction: DismissDirection.startToEnd,
        dismissThresholds: const {
          DismissDirection.startToEnd: 0.15,
        },
        confirmDismiss: (direction) async {
          onSwipeReply();
          return false;
        },
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: Icon(Icons.reply, color: theme.disabledColor),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent, 
          onLongPress: onLongPress,
          onTap: onTap,
          child: Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: 2, bottom: 2,
                left: isMe ? 64 : 16,
                right: isMe ? 16 : 64,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                  minWidth: 70, 
                ),
                child: IntrinsicWidth(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(!isMe && showTail ? 0 : 16),
                        topRight: Radius.circular(isMe && showTail ? 0 : 16),
                        bottomLeft: const Radius.circular(16),
                        bottomRight: const Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ReplyPreviewInBubble(
                          message: message,
                          isMe: isMe,
                          textColor: textColor,
                          barColor: isMe ? Colors.white : theme.colorScheme.primary,
                        ),

                        if (!isMe && showTail)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              message.senderName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade800,
                                fontSize: 13,
                              ),
                            ),
                          ),

                        MessageContent(
                          message: message,
                          textColor: textColor,
                          timeColor: timeColor,
                          isShortMessage: isShortMessage,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}