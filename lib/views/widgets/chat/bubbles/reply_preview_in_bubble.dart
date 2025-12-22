import 'package:flutter/material.dart';
import '../../../../models/message_model.dart';

class ReplyPreviewInBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final Color textColor;
  final Color barColor;

  const ReplyPreviewInBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.textColor,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    if (message.replyToText == null) return const SizedBox.shrink();

    final displaySender = message.replyToSenderId == message.senderId 
        ? 'Você' 
        : (message.replyToSenderName ?? 'Desconhecido');

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: barColor,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displaySender,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: textColor.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            message.replyToText ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}