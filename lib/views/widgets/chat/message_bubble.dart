import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/message_model.dart';
import '../../../viewmodels/chat_viewmodel.dart';
import 'bubbles/deleted_message_bubble.dart';
import 'bubbles/message_content.dart';
import 'bubbles/reply_preview_in_bubble.dart';
import 'reactions/reaction_picker_dialog.dart';
import 'reactions/message_reactions_display.dart';

class MessageBubble extends StatefulWidget {
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
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  Offset _tapPosition = Offset.zero;

  void _showReactionPicker(BuildContext context) {
    final viewModel = Provider.of<ChatViewModel>(context, listen: false);

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => ReactionPickerDialog(
        tapPosition: _tapPosition,
        onDismiss: () => Navigator.of(context).pop(),
        onReactionSelected: (reaction) {
          FocusScope.of(context).unfocus(); 
          
          viewModel.reactToMessage(widget.message, reaction);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message.isDeleted) {
      return DeletedMessageBubble(isMe: widget.isMe);
    }

    final theme = Theme.of(context);
    final normalColor = widget.isMe ? theme.colorScheme.primary : theme.colorScheme.secondary;
    final bubbleColor = widget.isSelected ? normalColor.withValues(alpha: 0.7) : normalColor;
    final rowColor = widget.isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent;
    final textColor = widget.isMe ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;
    final timeColor = widget.isMe 
        ? theme.colorScheme.onPrimary.withValues(alpha: 0.7) 
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);

    final bool isShortMessage = widget.message.text.length < 25 && !widget.message.text.contains('\n');

    return Container(
      color: rowColor,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Dismissible(
            key: Key(widget.message.id),
            direction: DismissDirection.startToEnd,
            dismissThresholds: const {DismissDirection.startToEnd: 0.15},
            confirmDismiss: (direction) async {
              widget.onSwipeReply();
              return false;
            },
            background: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: Icon(Icons.reply, color: theme.disabledColor),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent, 
              onPanDown: (details) {
                _tapPosition = details.globalPosition;
              },
              onLongPress: () {
                widget.onLongPress();
                _showReactionPicker(context);
              },
              onTap: widget.onTap,
              child: Align(
                alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 2, 
                    bottom: 12, 
                    left: widget.isMe ? 64 : 16,
                    right: widget.isMe ? 16 : 64,
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
                            topLeft: Radius.circular(!widget.isMe && widget.showTail ? 0 : 16),
                            topRight: Radius.circular(widget.isMe && widget.showTail ? 0 : 16),
                            bottomLeft: const Radius.circular(16),
                            bottomRight: const Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ReplyPreviewInBubble(
                              message: widget.message,
                              isMe: widget.isMe,
                              textColor: textColor,
                              barColor: widget.isMe ? Colors.white : theme.colorScheme.primary,
                            ),

                            if (!widget.isMe && widget.showTail)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  widget.message.senderName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade800,
                                    fontSize: 13,
                                  ),
                                ),
                              ),

                            MessageContent(
                              message: widget.message,
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

          Positioned(
            bottom: -4, 
            right: widget.isMe ? 24 : null, 
            left: widget.isMe ? null : 24,  
            child: MessageReactionsDisplay(
              message: widget.message,
              isMe: widget.isMe,
            ),
          ),
        ],
      ),
    );
  }
}